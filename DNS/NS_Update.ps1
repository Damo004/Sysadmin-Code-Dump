# Used when moving a bulk of DNS records NS values to a new NS value. Automated this tedious task on Windows servers.

$dns_check = import-csv "C:\Scripts\files\tested_dns.csv"

foreach ($dns in $dns_check){
	if ($dns.dnsrecord -eq "ns1.example.com.au. ns3.example.com.au." -or $dns.dnsrecord -eq "ns3.example.com.au. ns1.example.com.au."){
    		Remove-DnsServerResourceRecord -ZoneName $dns.domain -Name "@" -RRType NS -Force
		$newNS = "ns11.example.com.au", "ns12.example.com.au"
		foreach ($newNsServer in $newNS) {
    			Add-DnsServerResourceRecord -ZoneName $dns.domain -Name "@" -NS -NameServer $newNsServer
		}
	}
	elseif ($dns.dnsrecord -eq "Error: The zone " +$dns.domain+ " was not found on server NS1.") {
		foreach($dns_add in $dns.domain){ 
			Add-DnsServerPrimaryZone -Name $dns_add -ZoneFile $dns_add".dns"
			Add-DnsServerResourceRecord -ZoneName $dns_add -A -Name "@" -IPv4Address 0.0.0.0
			Add-DnsServerResourceRecord -ZoneName $dns_add -A -Name "www" -IPv4Address 0.0.0.0
		}
		A
		$newNS = "ns11.example.com.au", "ns12.example.com.au"
		foreach ($newNsServer in $newNS) {
    			Add-DnsServerResourceRecord -ZoneName $dns.domain -Name "@" -NS -NameServer $newNsServer
		}
	}
	elseif ($dns.dnsrecord -eq "ns1.example.com.au. ns11.example.com.au. ns12.example.com.au.") {
		Remove-DnsServerResourceRecord -ZoneName $dns.domain -Name "@" -RRType NS -Force
		$newNS = "ns11.example.com.au", "ns12.example.com.au"
		foreach ($newNsServer in $newNS) {
    			Add-DnsServerResourceRecord -ZoneName $dns.domain -Name "@" -NS -NameServer $newNsServer
		}
	}
	else {
		Write-Host $dns.domain "record is already" $dns.dnsrecord
	}
}
