<#

This module is for verifying the Litigaiton hold state of users. Occasionally, a user may not have it enabled during creation and this ensures
compliance is being maintained for Exchange mailboxes.

#>

<#

1. Log in to Exchange

2. Get list of all users

3. Review List/Complile into Array

4. Enable Litigation Hold

#>


<#1. Log in to Exchange #>
Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline

Write-Host "Exchange Online Connected!"
Write-Host "Gathering User Information..."

<#2. Get list of all users 
    - Gets user list sorted by last name, expands their email property
#>
$disabled_list = New-Object System.Collections.ArrayList($null)
$email_list = Get-User -Filter * -Sortby LastName | Select-Object -ExpandProperty WindowsEmailAddress

Write-Host "Done!"
Write-Host "Checking Litigation Hold..."

<#3 Review List / Compile into an Array
    -Iterates through the list and grabs email names where the Litigation is disabled
    -Outputs the users to console
#>
ForEach ($email in $email_list){



    if($email -ne ""){
        
        try{
            $litigation_state = Get-Mailbox -Identity $email | Select-Object -ExpandProperty LitigationHoldEnabled

            
            if($litigation_state -eq "$false"){
                
                #Write-Host $email
                [void]$disabled_list.Add($email)
            }
            
        }catch{
            Write-Host "Error getting analytics for $email"
        }

    }
}


cls
Write-Host "The following people have litigation disabled:"

$LH_int = 0
ForEach($disabled in $disabled_list){
    Write-Host "$LH_int) $disabled"
    $LH_int++
}

Write-Host "`n `n"


<#4 Enable Litigation Hold
    -Prompts to Enable Litigation Hold for all listed users or only specific users should an account keep it disabled for some reason
#>

$LH_choice = Read-Host -Prompt "Enable Litigation for All, One, or None? A/O/N"

switch($LH_choice){

    "A"{
        ForEach($email in $disabled_list){
            Set-Mailbox -Identity $email -LitigationHoldEnabled $true
        }
    }

    "O"{
        $LH_one_continue = 1
        
        while($LH_one_continue){
            $DA_user = Read-Host -Prompt "Enter Index of User to Enable"
            Set-Mailbox -Identity $disabled_list[$DA_user] -LitigationHoldEnabled $true

            $LH_one_continue_choice = Read-Host -Prompt "Enable Another? y/n"

            switch($LH_one_continue_choice){
                
                "Y"{
                    $LH_one_continue = 1
                }
                default{
                    $LH_one_continue = 0
                }

            }
        }
    }

    default{
        Write-Host "Cancelling - Logging out"
    }

}


Disconnect-ExchangeOnline -Confirm:$false
