# Follow up to GAL_reviewer.ps1 that uses the data extracted to update necessary values.
# 1. Adds the user UPN to the mailNickName attribute
# 2. Updates the msExchHideFromAddressLists attribute to TRUE

import-csv -path C:\temp\GAL_Not_Enabled.csv | foreach {
set-aduser -identity $_.samaccountname -add @{msExchHideFromAddressLists="TRUE"} -Replace @{MailNickName = $_.UserPrincipalName}
