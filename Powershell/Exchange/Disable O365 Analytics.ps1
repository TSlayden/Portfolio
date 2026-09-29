<#

This module is used to gather info on who is receiving Microsoft Viva Briefing emails.
It provides functionality to opt-out of those emails should a user find them to be a nuisance.

#>


<#

1. Log in to Exchange

2. Get list of all users

3. Review List/Complile into Array

4. Disable Analytics

#>


<#1. Log in to Exchange #>
Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline

Write-Host "Exchange Online Connected!"
Write-Host "Gathering User Information..."

<#2. Get list of all users 
    - Gets user list sorted by last name, expands their email property
#>
$enabled_list = New-Object System.Collections.ArrayList($null)
$email_list = Get-User -Filter * -Sortby LastName | Select-Object -ExpandProperty WindowsEmailAddress

Write-Host "Done!"
Write-Host "Checking analytics..."

<#3 Review List / Compile into an Array
    -Iterates through the list and grabs email names where the feature is enabled
    -Outputs the users to console
#>
ForEach ($email in $email_list){



    if($email -ne ""){
        
        try{
            $add_in_state = Get-MyAnalyticsFeatureConfig -Identity $email | Select-Object -ExpandProperty IsAddInEnabled

            if($add_in_state -eq "true"){
                <#Write-Host $email#>
                [void]$enabled_list.Add($email)
            }
        }catch{
            Write-Host "Error getting analytics for $email"
        }

    }
}

cls
Write-Host "The following people have analytics enabled:"

$DA_int = 0
ForEach($enabled in $enabled_list){
    Write-Host "$DA_int) $enabled"
    $DA_int++
}

Write-Host "`n `n"

<#4 Disable Analytics
    -Prompts to Disable the Analytics for all listed users or only specific users should some prefer to stay opted-in
#>

$DA_choice = Read-Host -Prompt "Disable Analytics for All, One, or None? A/O/N"

switch($DA_choice){

    "A"{
        ForEach($email in $enabled_list){
            Set-MyAnalyticsFeatureConfig -Identity $email -PrivacyMode opt-out
        }
    }

    "O"{
        $DA_one_continue = 1
        
        while($DA_one_continue){
            $DA_user = Read-Host -Prompt "Enter Index of User to Disable"
            Set-MyAnalyticsFeatureConfig -Identity $enabled_list[$DA_user] -PrivacyMode opt-out

            $DA_one_continue_choice = Read-Host -Prompt "Disable Another? y/n"

            switch($DA_one_continue_choice){
                
                "Y"{
                    $DA_one_continue = 1
                }
                default{
                    $DA_one_continue = 0
                }

            }
        }
    }

    default{
        Write-Host "Cancelling - Logging out"
    }

}


Disconnect-ExchangeOnline -Confirm:$false
