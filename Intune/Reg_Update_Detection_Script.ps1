# Used to check if Firefox has automated updates enabled. Used with remediation scripting. This is the detection portion only.

$path = "HKCU:\SOFTWARE\Policies\Mozilla\FireFox"
$dword = "DisableAppUpdate"

try
{   
        if ((Get-ItemPropertyValue -Path $path -name $dword -ea stop) -eq 0){
            #Below necessary for Intune as of 10/2019 will only remediate Exit Code 1
            Write-Output "Exist"
            exit 0
        
    }   
}
catch{
    $errMsg = $_.Exception.Message
    Write-host $errMsg
    exit 1
}
