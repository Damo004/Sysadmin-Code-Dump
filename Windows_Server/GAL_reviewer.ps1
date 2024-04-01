# Came across an issue where GAL was not working for disabled users. This is due to some factors:
# 1. They have an on-prem AD linked to O365
# 2. They are missing attributes required to have users hidden from GAL:
#   a. mailNickname with a value
#   b. msExchHideFromAddressLists with a value

# Script will output all users found in the specified OUs with these values missing. Follow up script automates the task of fixing them.

$location = "C:\temp"
$group = "GAL_Not_Enabled"
$OUs = "OU=Disabled Users 2021,OU=Disabled Users,OU=Head Office,DC=Example,DC=local", "OU=Disabled Users 2022,OU=Disabled Users,OU=Head Office,DC=Example,DC=local", "OU=Disabled Users 2023,OU=Disabled Users,OU=Head Office,DC=Example,DC=local", "OU=Disabled Users,OU=Head Office,DC=Example,DC=local" 
$usersMissingData = foreach($OU in $OUs){
	Get-ADUser -SearchBase $OU -Properties * -Filter * |`
	Where-Object { 
	$_.mailNickname -eq $null -and
	-not($_.enabled) -and
	$_.msExchHideFromAddressLists -new $null
	}
} 
If ($usersMissingData.count -gt 0) {
    $usersMissingData | Select-Object SamAccountName, UserPrincipalName |`
        Sort-Object SamAccountName, UserPrincipalName | Export-Csv "$location\$group.csv" -NoTypeInformation -Append
}
