# When activating Archive within O365 Exchange, it can take upto 24 hours for it to start. This can be skipped by running the following:
# Please note to change the Idenitity value to the users email account

Start-ManagedFolderAssistant -Identity user@user.com
