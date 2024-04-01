# Used with Remediation Scripting. This is the remediation part. The detection part is found in its own script.
# Checks that Firefox has auto update enabled, if not it will turn it on.

if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Policies\Mozilla\FireFox") -ne $true) 
{ 
	New-Item "HKCU:\SOFTWARE\Policies\Mozilla\FireFox" -force -ea SilentlyContinue };

New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Policies\Mozilla\FireFox" -Name "DisableAppUpdate" -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
