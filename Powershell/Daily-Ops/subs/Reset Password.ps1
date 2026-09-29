#This is a quick password reset script which takes a username and a password and initiates the reset
#There is an optional switch to mandate the user to select a new password on login.
#This may not be ideal in instances where the user logs in with a thin client as the login
# process does not facilitate reset at login.

$username = Read-Host -Prompt 'Enter User to change pw'

$new_pass = Read-Host -Prompt "Enter New Password"

$change_pw_logon = Read-Host -Prompt "Prompt User to Change Password at Logon? Y/N"

$verify_check = Read-Host -Prompt "Is the above correct? Y/N"

switch($verify_check){
    "Y"{
        Write-Host "Resetting password..."
    }
    default{
        Break
    }
}

$ad_instance = Get-ADUser -Identity $username

switch($change_pw_logon){
    "Y"{
        Set-ADUser -Identity $ad_instance -ChangePasswordAtLogon $true
        Unlock-ADAccount -Identity $ad_instance
    }
    default{
        Unlock-ADAccount -Identity $ad_instance
    }

}

Set-ADAccountPassword -Identity $ad_instance -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $new_pass -Force)

Write-Host "$username password is now changed."

PAUSE