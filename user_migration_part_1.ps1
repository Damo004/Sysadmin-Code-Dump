# Script used to make the tedious tasks of transferring a user from 1 server to another, less annoying as it already is
# This is when they may have information spread across 2 different servers. This is the first part of a 2 part script to do the transfer.

# Broken down into the following steps and this script will do the following:
# Step 1. Log into the server with the user profile. This is to build the LogixFX profile. 
# Step 2. Copy data across as required. This is where the script will step in.
# Step 3. Setup Outlook. Default printer as required. To investigate if we can grab their regkeys to add this, potentially saving manual setup.
# Step 4. Change RDP icon on desktop. This is manual, automated this via Kaseya.
# Step 5. Educate the users. Shouldn't be any more difficult then use this icon to connect now.

# Key items to transfer:
# - Signatures (C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Signatures)
# - Chrome Data (C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data)
# - Downloads (C:\Users\%USERNAME%\Downloads)
# - Documents (C:\Users\%USERNAME%\Documents)
# - Desktop Items (C:\Users\%USERNAME%\Desktop)
# - Translogix RDP Icon (Already setup in C:\Users\Public\Desktop)
# - Windows Explorer Favourites (C:\Users\%USERNAME%\Links)

# Specifications:
# Data is split between both servers. 1 server will have a more updated version. Will need to ensure the data from the server with the latest modification is pulled, and not the older server.
# Get-Item | ForEach-Object {$_.LastWriteTime}

# Need to retrieve username and store as a variable
$username = Read-Host "Input username"

# Grabbing the value of the last time the user profile was modified. We want to grab the latest version
$server1 = "\\server1\C$\Users\$username"
$server2 = "\\server2\C$\Users\$username"
$newServer1 = "\\example.net.au\fs01\newServer1\customer01\Redirected_Folders\$username"

# - Signatures (C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Signatures)
if ((Get-Item $server1\AppData\Roaming\Microsoft\Signatures | ForEach-Object {$_.LastWriteTime}) -gt (Get-Item $server2\AppData\Roaming\Microsoft\Signatures | ForEach-Object {$_.LastWriteTime})){
    Copy-Item -Path "$server1\AppData\Roaming\Microsoft\Signatures" -Destination "C:\Users\$username\AppData\Roaming\Microsoft\" -Recurse -Force -Verbose 
}
else {
    Copy-Item -Path "$server2\AppData\Roaming\Microsoft\Signatures" -Destination "C:\Users\$username\AppData\Roaming\Microsoft\" -Recurse -Force -Verbose
}

# - Chrome Data (C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data)
if ((Get-Item $server1\AppData\Roaming\Microsoft\Signatures | ForEach-Object {$_.LastWriteTime}) -gt (Get-Item $server2\AppData\Roaming\Microsoft\Signatures | ForEach-Object {$_.LastWriteTime})){
    Copy-Item -Path "$server1\AppData\Local\Google\Chrome\User Data" -Destination "C:\Users\$username\AppData\Local\Google\Chrome\" -Recurse -Force -Verbose 
}
else {
    Copy-Item -Path "$server2\AppData\Local\Google\Chrome\User Data" -Destination "C:\Users\$username\AppData\Local\Google\Chrome\" -Recurse -Force -Verbose
}

# - Downloads (C:\Users\%USERNAME%\Downloads)
if ((Get-Item $server1\Downloads | ForEach-Object {$_.LastWriteTime}) -gt (Get-Item $server2\Downloads | ForEach-Object {$_.LastWriteTime})){
    Copy-Item -Path "$server1\Downloads" -Destination "C:\Users\$username\" -Recurse -Force -Verbose 
}
else {
    Copy-Item -Path "$server2\Downloads" -Destination "C:\Users\$username\" -Recurse -Force -Verbose
}

# - Documents (C:\Users\%USERNAME%\Documents)
if ((Get-Item $server1\Documents | ForEach-Object {$_.LastWriteTime}) -gt (Get-Item $server2\Documents | ForEach-Object {$_.LastWriteTime})){
    Copy-Item -Path "$newServer1\My Documents" -Destination "C:\Users\$username\" -Recurse -Force -Verbose
    Copy-Item -Path "$server1\Documents" -Destination "C:\Users\$username\" -Recurse -Force -Verbose
}
else {
    Copy-Item -Path "$newServer1\My Documents" -Destination "C:\Users\$username\" -Recurse -Force -Verbose
    Copy-Item -Path "$server2\Documents" -Destination "C:\Users\$username\" -Recurse -Force -Verbose
}

# - Desktop Items (C:\Users\%USERNAME%\Desktop)
if ((Get-Item $server1\Desktop | ForEach-Object {$_.LastWriteTime}) -gt (Get-Item $server2\Desktop | ForEach-Object {$_.LastWriteTime})){
    $items = Get-ChildItem -Path "$server1\Desktop"

    foreach($item in $items){
        $newItem = Join-Path -Path "C:\Users\$username\Desktop" -ChildPath $item.Name
        $public = Join-Path -Path "C:\Users\Public\Desktop" -ChildPath $item.Name
        if (-not (Test-Path -Path $newItem)) {
            if (-not (Test-Path -Path $public)){
                Copy-Item -Path $item.FullName -Destination $newItem -Recurse -Verbose
                Copy-Item -Path "$newServer1\Desktop" -Destination "C:\Users\$username\" -Recurse -Force -Verbose
            }
        } else {
            Write-Host "Skipped $($item.Name) because it already exists in $($newItem)"
        }
    }
}
else {
    $items = Get-ChildItem -Path "$server2\Desktop"

    foreach($item in $items){
        $newItem = Join-Path -Path "C:\Users\$username\Desktop" -ChildPath $item.Name
        $public = Join-Path -Path "C:\Users\Public\Desktop" -ChildPath $item.Name
        if (-not (Test-Path -Path $newItem)) {
            if (-not (Test-Path -Path $public)){
                Copy-Item -Path $item.FullName -Destination $newItem -Recurse -Verbose
                Copy-Item -Path "$newServer1\Desktop" -Destination "C:\Users\$username\" -Recurse -Force -Verbose
            }
        } else {
            Write-Host "Skipped $($item.Name) because it already exists in $($newItem)"
        }
    }
}

# - Translogix RDP Icon (Already setup in C:\Users\Public\Desktop)
# Nothing needed

# - Windows Explorer Favourites (C:\Users\%USERNAME%\Links)
if ((Get-Item $server1\Links | ForEach-Object {$_.LastWriteTime}) -gt (Get-Item $server2\Links | ForEach-Object {$_.LastWriteTime})){
    $links = Get-ChildItem -Path "$server1\Links"
    
    foreach($link in $links){
        if ($link.Extension -eq ".lnk"){
            Copy-Item -Path "$server1\Links\$link" -Destination "C:\Users\$username\Links" -Force -Recurse -Verbose 
        }
        else{
            Write-Host "$link is not valid. Please manually add this."
        }
    } 

    # Adding item into Quick Access via PowerShell
    Remove-Item -Path "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms" -Force -Verbose
}
else {
    $links = Get-ChildItem -Path "$server2\Links"
    
    foreach($link in $links){
        if ($link.Extension -eq ".lnk"){
            Copy-Item -Path "$server2\Links\$link" -Destination "C:\Users\$username\Links" -Force -Recurse -Verbose 
        }
        else{
            Write-Host "$link is not valid. Please manually add this."
        }
    }

    # Adding item into Quick Access via PowerShell
    Remove-Item -Path "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms" -Force -Verbose
}
