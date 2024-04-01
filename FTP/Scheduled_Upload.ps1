# NAME Scheduled_Upload.ps1
# PURPOSE Uploading files to FTP Server
# AUTHOR Damian Gale
# CREATED 21/07/2023
# SCHEDULE TBA

# Used in conjunction with Task Scheduler to automatically upload files to the target server. Files with the prefix EXA02 and with no spaces (E.g., EXA02_test.docx) are uploaded to the target file. If any file is missing this value the upload will break at the file misnamed. I have been to busy to add in redundancy checks and file skipping. Maybe oneday.

#Setting up Variables
$Timestamp = Get-Date -Format "yyyyMMdd_HHmm"
$UploadPath = "\\fs01\Company_Name\1. Folder\Upload_Folder\"
$ArchivePath = "\\fs01\Company_Name\1. Folder\Upload_Folder\Archive\"
$LogPath = "\\fs01\Company_Name\1. Folder\Upload_Folder\UploadLogs\"
$fileprefix = "EXA02"
$file =  Get-ChildItem $UploadPath | where-object {$_.Name -like "$fileprefix*"} | select-object -ExpandProperty Name
$FileName1 = "$UploadPath"+"$file"
$FileName2 = "$UploadPath"+"$file"+"_"+$Timestamp+".xlsx"
$ArchiveName = "$ArchivePath"+"$file"+"_"+$Timestamp+".xlsx" 

Set-Location $UploadPath

# Checking for mapped drive
function map_drive
{
    Write-host "Checking for mapped drive" -ForegroundColor Yellow
    
    $driveCheck = (Get-PSDrive -Name "Y" -ErrorAction SilentlyContinue)

    if ($driveCheck)
        {
	      Write-host "Drive mapped proceeding to upload" -ForegroundColor Green

          }
        else
        {
        Write-host "Drive not mapped, proceeding to map drive and then upload" -ForegroundColor Green
        New-PSDrive -Persist -Name "Y" -PSProvider "FileSystem" -Root $UploadPath 
        }
}


# Defining FTP Credentials
$ftpuser = "example_user" 
$ftpsecpass = "example_stored_password"  
$ftppass=$ftpsecpass|ConvertTo-SecureString
$sshValue = "pA8HsALppOjzXYjEwH4fl+dDtwG6f/frAuDapPgneN0="

# Uploading files with the prefix wam02
function UploadFTP
    {
    Write-host "Files are being uploaded" -ForegroundColor Yellow
    & "C:\Program Files (x86)\WinSCP\WinSCP.com" `
      /log="$LogPath\winSCP_$Timestamp.log" /ini=nul `
      /command `
        "open sftp://"$ftpuser":"$ftppass"@0.0.0.0 -hostkey=`"`"ssh-rsa 2048 "$sshValue"`"`"" `
	  "cd archive" `
        "put $File ./" `
        "exit"

    $winscpResult = $LastExitCode
    if ($winscpResult -eq 0)
        {
          Write-Host "Success"
          
          #Appending file with date & time, moving to archive folder
          Write-host "Files are being renamed and archived" -ForegroundColor Yellow
          Rename-Item $FileName1 $FileName2
          Move-Item $FileName2 $ArchiveName          
        }
        else
        {
          Write-Host "Error"
        }
}

UploadFTP
