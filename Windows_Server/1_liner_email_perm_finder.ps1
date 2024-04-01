# Connect to Exchange Online via CLI and change user@user.com to user email.

Get-Mailbox "user@user.com" | ForEach { Get-MailboxFolderPermission (($_.PrimarySmtpAddress.ToString())+”:\Calendar”) -User temp -ErrorAction SilentlyContinue} | select Identity,User,AccessRights | export-csv "C:\temp\temp_access_list.csv"
