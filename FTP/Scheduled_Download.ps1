# NAME Scheduled_Download.ps1
# PURPOSE Downloading files from Folder
# AUTHOR Damian Gale
# CREATED 21/07/2023
# SCHEDULE TBA

# Used in conjunction with Task Scheduler to automatically download files from the target server. 

#Setting up Variables
$Timestamp = Get-Date -Format "yyyyMMdd_HHmm"
$DownloadPath = "\\fs01\Company_Name\1. Folder\Download_Folder\"
$ArchiveFolder = "$ArchivePath"+"$Timestamp"
$ArchivePath = "\\fs01\Company_Name\1. Folder\Upload_Folder\Archive\"
$LogPath = "\\fs01\Company_Name\1. Folder\Upload_Folder\UploadLogs\"
$fileprefix = "EXA02"

Set-Location $DownloadPath

# Checking for mapped drive
function map_drive
{
    Write-host "Checking for mapped drive" -ForegroundColor Yellow
    $driveCheck = Y

    if ($driveCheck -eq $False)
        {
        Write-host "Drive not mapped, proceeding to map drive and then upload" -ForegroundColor Green
        New-PSDrive Y FileSystem $UploadPath -Scope Global -Persist: $true
          }
        else
        {
        Write-host "Drive mapped proceeding to upload" -ForegroundColor Green
        }
}


# Defining FTP Credentials
$ftpuser = "example_user" 
$ftpsecpass = "example_stored_password"  
$ftppass=$ftpsecpass|ConvertTo-SecureString
$sshValue = "pA8HsALppOjzXYjEwH4fl+dDtwG6f/frAuDapPgneN0="

# Uploading files with the prefix wam01
function DownloadFTP
    {
      Write-host "Files are being Downloaded" -ForegroundColor Yellow
    & "C:\Program Files (x86)\WinSCP\WinSCP.com" `
      /log="$LogPath\winSCP_$Timestamp.log" /ini=nul `
      /command `
        "open sftp://"$ftpuser":"$ftppass"@0.0.0.0 -hostkey=`"`"ssh-rsa 2048 "$sshValue"`"`"" `
        "Get / " `
        "exit"
    

    $winscpResult = $LastExitCode
    if ($winscpResult -eq 0)
        {
        Write-Host "Success"
        mkdir $ArchiveFolder
        $files =  Get-ChildItem $DownloadPath | where-object {$_.Name -like "$fileprefix*"} | select-object -ExpandProperty Name
        foreach ($file in $files)
        {
        $downloadfile = "$DownloadPath"+"$file"
        $ArchiveFile = "$ArchiveFolder"+"\"+"$file"
        copy-Item -Path $downloadfile  -Destination $ArchiveFile
        }
        }
        else
        {
          Write-Host "Error"
        }

}

DownloadFTP
