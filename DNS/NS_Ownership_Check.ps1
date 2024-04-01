# Script used to see if the DNS record is hosted by the MSP. This is helpful when given a list of domains to check and verify if the NS record resolves to your own servers.
# The purpose for this one is to check without needing access to the NS Servers themselves.

function Test-DNSRecord {
    param(
        [string]$Domain
    )
    
    try {
        $result = nslookup -type=NS $Domain | Where-Object { $_ -match "ns1.example.com.au" }
        $result2 = nslookup -type=NS $Domain | Where-Object { $_ -match "ns11.example.com.au" }
        if ($result) {
            $dnsRecord = $result -replace '\s+', ' ' -join ' '
            return $dnsRecord
        } elseif ($result2) {
            $dnsRecord = $result2 -replace '\s+', ' ' -join ' '
            return $dnsRecord
        } else {
            return "$Domain is not hosted by Company"
        }
    } catch {
        return "Error: $_"
    }
}

# Load data from CSV
$csvPath = "C:\Scripts\DNS\dns.csv"
$outputPath = "C:\Scripts\DNS\tested_dns.csv"

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
