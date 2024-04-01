# Used only to detect if the file is installed, and patch management is handeled by another software/RMM tool.

# Example: If OpenVPN < 3.4.2 then run

$path1 = "C:\Program Files\OpenVPN Connect"
$path2 = "C:\Program Files (x86)\OpenVPN Connect"
$file = "OpenVPNConnect.exe"

try
{   
        if ((Test-Path -Path $path1) -or (Test-Path -Path $path2)){
            #Below necessary for Intune as of 10/2019 will only remediate Exit Code 1
            Write-Output "Path Exists"
            if ((Get-Item $path1).VersionInfo.FileVersion -ge "3.4.2" -or ((Get-Item $path2).VersionInfo.FileVersion -ge "3.4.2"){
                Write-Host "Up to date"
                exit 0
            }
            else {
                Write-Host "Not Up to date"
                exit 1
            }
	}
        else{
	        Write-Output "Path Doesn't Exist"
	        exit 1
    	}   
}
catch{
    $errMsg = $_.Exception.Message
    Write-host $errMsg
    exit 1
}
