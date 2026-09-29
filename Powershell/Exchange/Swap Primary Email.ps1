<#

The company changed its primary domain name in 2023 and this script was used to update all users' email addresses.
It pulls their AD object and stitches together the new email name using a combination of their firstname.lastname@domainname
The change was implemented in phases, doing only a couple of departments at a time to minimize the volume of issues which may crop up.

#>

<#

1. Connect to Azure & Define variables

2. Choose department to swap

3. Pulls name properties out of user objects and generates new email addresses

#>

Import-Module AzureAD
Import-Module ExchangeOnlineManagement

<#1. Connect to Azure & Define variables #>
Connect-AzureAD

$AD_ObjectID = ""
$AD_MailNickname = ""
$AD_UPN = ""
$AD_FirstName = ""
$AD_LastName = ""
$AD_JCSNA_Domain = "@jtekt-cs-na.com"
$AD_DAC_Domain = "@douglasautotech.com"
$AD_JTEKT_UPN = ""
$AD_Users = ""

<#2. Choose department to swap
    -Grabs all user objects based on chosen department
#>
$AD_Department = Read-Host -Prompt "Select department to swap"

Write-Host $AD_Department

$AD_Users = Get-AzureADUser -Filter "Department eq '$AD_Department'"

##Write-Host "User Revoked"

<#3. Pulls name properties out of user objects and generates new email addresses
    -Uses the $AD_JTEKT_UPN variable for new email address
    -Sets new -MailNickname and -UserPrincipalName
    -Forces the email account to log out everywhere so new UPN takes effect

#>
foreach($User in $AD_Users){

    $AD_ObjectID = Select-Object -InputObject $User -ExpandProperty ObjectId
    $AD_FirstName = Select-Object -InputObject $User -ExpandProperty GivenName
    $AD_LastName = Select-Object -InputObject $User -ExpandProperty Surname
    $AD_UPN = Select-Object -InputObject $User -ExpandProperty UserPrincipalName
    $AD_MailNickname = $AD_FirstName+"."+$AD_LastName
    $AD_JTEKT_UPN = $AD_FirstName+"."+$AD_LastName+$AD_JCSNA_Domain

#    Write-Host $AD_FirstName $AD_LastName $AD_UPN $AD_MailNickname $AD_JTEKT_UPN
    
    #Apply New Account Settings
    Set-AzureADUser -ObjectId $AD_ObjectID -MailNickName $AD_MailNickname
    Set-AzureADUser -ObjectId $AD_ObjectID -UserPrincipalName $AD_JTEKT_UPN
    
    #LOGOUT SESSIONS
    Select-Object -InputObject $User | Revoke-AzureADUserAllRefreshToken

    Write-Host "$AD_MailNickname Reset Submitted"

}

Disconnect-AzureAD -Confirm:$false
Write-Host "Done!"
PAUSE