<#

This module is used to enable Automatically Expanding Email Archives in Exchange.
By default, an account has a hard limit but can be set to expand in 10gb increments automatically if enabled.
This module is intended for users who prosess very tenured inboxes or who receive a high volume of emails (like the president)

***HUGE NOTE***
Outlook by default may define a limit on the .pst file size for cached data. If caching is enabled, a Registry key may need to be
modified or else Outlook will constantly throw errors about the .pst size and no new data will be pulled from Exchange.


#>

<#
1 Log in to Exchange

2 Select user for Auto-Expanding Archive

3 Logout

#>

<#1 Logging in to Exchange requires the EXO V2 powershell module to be installed
    -Prompt for the email address on which to enable Auto-expansion
#>

$ex_User = Read-Host -Prompt "Enter Email address of mailbox archive to expand"

Write-Host "Logging in..."

Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline

Write-Host "Logged in"


#2 Enable auto expanding archive for user
Write-Host "Expanding $ex_User archive"

Enable-Mailbox -Identity $ex_User -AutoExpandingArchive

Write-Host "Auto Expand command issued"


#3 End active session
Write-Host "Logging out..."
Disconnect-ExchangeOnline -Confirm:$false
Write-Host "Finished"
PAUSE