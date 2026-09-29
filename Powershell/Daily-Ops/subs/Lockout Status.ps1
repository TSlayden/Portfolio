#This script queries the Domain Controller and returns any users who are locked out.
#It also offers functionality to unlock those accounts.

#Often run at the start of the day and after lunch when lockouts are most common.

$LS_again = 1

while($LS_again){

    cls

    Write-Host "Querying Status, please wait..."

    Get-ADUser -Filter * -Properties SAMAccountName, LockedOut | Where-Object {$_.LockedOut -eq 'True'} | Format-Table SAMAccountName, LockedOut

    $username = Read-Host -Prompt 'Enter User to Unlock'

    Write-Host "Unlocking, please wait..."

    Unlock-ADAccount -Identity $username

    Write-Host "$username is unlocked"


    $selection = Read-Host -Prompt 'Unlock Another? y/n'

    if( ($selection -eq 'y') -or ($selection -eq 'Y') ){
        $LS_again = 1
    }else{
        $LS_again = 0
    }
}