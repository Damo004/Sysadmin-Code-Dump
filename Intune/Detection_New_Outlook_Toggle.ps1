$results = 0
$path = (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\General")
$dword = ((Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\General").PSObject.Properties.Name -contains "HideNewOutlookToggle")

try
{   
    if ($path -ne $true){
	if ($dword -ne $true){
        	#Below necessary for Intune as of 10/2019 will only remediate Exit Code 1
        	Write-Host "Doesn't Exist"
        	Return $results.count
        	exit 1
	}
    }
    else{
        Write-Host "Exists"
        exit 0
    }    
}
catch{
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}
