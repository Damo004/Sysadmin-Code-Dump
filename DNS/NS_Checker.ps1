function Test-DNSRecord {
    param(
        [string]$Domain
    )
    
    try {
        $result = get-dnsserverresourcerecord $Domain -RRType "NS"
        if ($result.recorddata.nameserver -match "ns1.example.com.au") {
            $dnsRecord = $result.recorddata.nameserver -replace '\s+', ' ' -join ' '
            return $dnsRecord
	}
	elseif ($result.recorddata.nameserver -match "ns11.example.com.au"){
            $dnsRecord = $result.recorddata.nameserver -replace '\s+', ' ' -join ' '
            return $dnsRecord
	}
	else {
            return "$Domain is not currently in the DNS server"
        }
    } catch {
        return "Error: $_"
    }
}

# Load data from CSV
$csvPath = "C:\Scripts\files\dns.csv"
$outputPath = "C:\Scripts\files\tested_dns.csv"

$domains = Import-Csv -Path $csvPath | Select-Object -ExpandProperty DNS

$results = @()

foreach ($domain in $domains) {
    $output = Test-DNSRecord $domain
    $results += [PSCustomObject]@{
        Domain = $domain
        DNSRecord = $output
    }
}

$results | Export-Csv -Path $outputPath -NoTypeInformation
