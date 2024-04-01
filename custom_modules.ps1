# Script used to check permissions a user has for all mailboxes in the organisation

Function Get-CalendarPermission {
<#
.SYNOPSIS
    This is a script used to review all calendar permissions an user has within their organization
    
.NOTES
    Name: Get-CalendarPermission
    Author: Damian Gale
    Verion: 1.0
    DateCreated: 2023-Sep-28

.EXAMPLE
    Get-CalendarPermission -User "example@onplatinum.com.au"

.LINK
    N/A
#>

    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
            )]
        [string[]] $User
    )
    process {
        Get-Mailbox | ForEach-Object { Get-MailboxFolderPermission (($_.PrimarySmtpAddress.ToString())+":\Calendar") -User $user -ErrorAction SilentlyContinue} | Select-Object Identity,User,AccessRights
    }
}

Function Get-AllMailboxPermission {
    <#
    .SYNOPSIS
        This is a script used to review all mailbox permissions an user has within their organization
        
    .NOTES
        Name: Get-AllMailboxPermission
        Author: Damian Gale
        Verion: 1.0
        DateCreated: 2023-Oct-10
    
    .EXAMPLE
        Get-AllMailboxPermission -User "example@onplatinum.com.au"
    
    .LINK
        N/A
    #>
    
        [CmdletBinding()]
        param(
            [Parameter(
                Mandatory = $true,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                Position = 0
                )]
            [string[]] $User
        )
        process {
            Get-Mailbox | ForEach-Object { Get-MailboxPermission ($_.PrimarySmtpAddress.ToString()) -User $user -ErrorAction SilentlyContinue} | Select-Object Identity,User,AccessRights
        }
    }
