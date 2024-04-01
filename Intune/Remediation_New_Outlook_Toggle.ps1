New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Options'-Name 'General' -Force -ea SilentlyContinue;

New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\General' -Name 'HideNewOutlookToggle' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
