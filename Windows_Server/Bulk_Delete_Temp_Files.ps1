# Script used to find and delete all temp files in a user profile on a system. Allows this to be a 1 run script without needing to manually do the boring stuff

# Defining the user profile path

$User_Path = "C:\Users"

$Users = Get-ChildItem $User_Path

foreach($User in $Users.Name){
    Remove-Item -Path "$User_Path\$user\AppData\Local\Temp" -Recurse
}
