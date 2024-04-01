# A record update tool for Windows DNS records. Useful if requiring to modify a large value in bulk.

$dns_check = import-csv "C:\Scripts\files\A_change.csv" | Select-Object -ExpandProperty DNS

foreach ($dns in $dns_check){
	$ARecord = Get-DnsServerResourceRecord -zonename $dns -Name "@" -RRType "A"
	foreach ($record in $Arecord){
		if ($record.hostname -eq "@" -or $record.hostname -eq "www"){
   			if ($record.ipaddress -ne "0.0.0.0"){
			    Remove-DnsServerResourceRecord -zonename $dns -name $record.hostname -RRType "A" -Force -PassThru
			    Add-DnsServerResourceRecord -zonename $dns -A -name $record.hostname -AllowUpdateAny -IPv4Address "0.0.0.0" -TimeToLive 01:00:00 -AgeRecord -PassThru
		   	}
		    	else{
			    Write-Host $dns+" no change needed."
		    	}
        	}
		else {
	    		Write-Host "Nope"
		}
    	}
}
