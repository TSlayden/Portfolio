#This is the vital user deactivation script. Whenever IT receives a notice to deactivate a user,
# this script quickly deactivates their Active Directory and Exchange account. (if applicable)

$username = Read-Host -Prompt 'Enter User to Disable'
$date = Get-Date -Format "MMdd"

Disable-ADAccount -Identity $username

Set-ADAccountPassword -Identity $username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Void$date" -Force)

Write-Host "$username is Disabled"

$info_verify = Read-Host -Prompt "Does the user have email? Y/N"

switch($info_verify){
    "Y"{
        $info_verify = 0
        
<#        $upp = Read-Host -AsSecureString -Prompt "Enter O365 Password"
        
        $cur_user = (Get-WmiObject -class win32_computersystem | select username)
        $str_index = $cur_user.username.IndexOf("\")
        $upn = $cur_user.username.Substring([int]$str_index+1) + "@douglasautotech.com"

        $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $upn, $upp
        
        Write-Host "Logging in as $upn to Disable Account"
        PAUSE
#>    }
    default{
        $info_verify = 1
    }
}

if($info_verify){
    Break
}

<#
1 Log in to Exchange

2 Disable account 

3 Logout
#>


#1 Logging in to Exchange requires the EXO V2 powershell module to be installed

Import-Module AzureAD

<#Connect-AzureAD -Credential $Credential#>
Connect-AzureAD

Write-Host "Logged in"


#2 Block login to Exchange
Set-AzureADUser -ObjectID "$username@douglasautotech.com" -AccountEnabled $false
Write-Host "Submitted Sign-in Block Command for $username@douglasautotech.com"


#3 End active session
Write-Host "Logging out..."
Disconnect-AzureAD -Confirm:$false
Write-Host "Finished"
PAUSE
