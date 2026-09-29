<#

The company changed its primary domain name in 2023 and this script was used to test stitching together the new domain names dynamically.
The new email alias was a combination of First_Name.Last_Name@New_Domain
In event a service account did not have a First_Name or Last_Name, the Mail Nickname was used instead

#>

<#

1. Start Transcript & Log in to Exchange

2. Get all users

3. Build new email address

#>

Import-Module -Name AzureAD
Import-Module -Name ExchangeOnlineManagement


<#1. Start Transcript & Log in to Exchange #>
Start-Transcript -Path CheckAlias.log -Append

Connect-AzureAD

<#2. Get all users
  -Define constant for domain name
  -Pull all users from AD
#>
$Domain = "@jtekt-cs-na.com"

$AD_Users = Get-AzureADUser -All:$true

#Write-Host $AD_Users

<#3. Build new email address
  -Grab First and Last Names from user objects
  -Stitch them together with domain constant. Use MailNickname in instances where Name is not available
#>
foreach($User in $AD_Users){

$FirstName = Select-Object -InputObject $User -ExpandProperty GivenName

$LastName = Select-Object -InputObject $User -ExpandProperty Surname

    if($FirstName -eq $null){
      $MailNickname = Select-Object -InputObject $User -ExpandProperty MailNickname
    
      Write-Host "$MailNickname$Domain"
    }
    else{
      Write-Host "$FirstName.$LastName$Domain"
    }


}


PAUSE
Disconnect-ExchangeOnline -Confirm:$false
