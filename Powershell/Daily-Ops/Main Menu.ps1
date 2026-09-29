<#
This is the "main menu" for common quick tasks used in daily operations.
Most of these are Active Directory related tasks where a local script was faster to run than weeding through AD Users & Computers menus

1. Find lockouts: This script is used to query all user lockouts within a user-defined day range for a specified Domain Controller.
2. View Locked-Out Users: This script queries the Domain Controller and returns any users who are locked out.
3. Reset User Password: A quick password reset script which takes a username and a password and initiates the reset.
4. Disable Account: The vital user deactivation script for quickly revoking access to the Domain and Exchange Account.
5. Copy a User AD Account: An onboarding assist script. Copies an existing AD user to mirror their roles to a new user account.
6. Remote Control Session: Used to shadow a Remote Desktop Session on our Thin Client server.
7. Get Host IP: Assistance with troubleshooting network connectivity issues, Maps Hostnames to IP Addresses


#>

$continue = 1

while($continue){

cls

$mainmenu = 
'Select option:
1 - Find Lockouts
2 - View Locked-Out Users
3 - Reset User Password
4 - Disable Account
5 - Copy a User AD Account
6 - Remote Control Prometheus Session
7 - Get Host IP (Experimental)
Q - Quit

Enter Selection'

$userselection = Read-Host -Prompt $mainmenu

$scriptdirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

switch ($userselection){

    1{
        try{
            . ("$scriptdirectory\subs\Find Lockouts.ps1")
        }catch{
          Write-Host "Error loading script."
      }
    }
    
    2{
        try{
            . ("$scriptdirectory\subs\Lockout Status.ps1")
        }catch{
            Write-Host "Error loading script"
        }
    }    
    
    3{
        . ("$scriptdirectory\subs\Reset Password.ps1")
    }
    
    4{
        try{
            . ("$scriptdirectory\subs\Disable Account.ps1")
        }catch{
            Write-Host "Error loading script."
        }
    }
    
    5{
        #This block lacks a try/catch because it will most likey error adding groups. The error will stop the script in a try/catch.
        #This error will not be a fatal terminating error, so it is OK to ignore.
            . ("$scriptdirectory\subs\Copy AD User.ps1")
     }
    
    6{
        try{
            . ("$scriptdirectory\subs\Remote Control.ps1")
        }catch{
            Write-Host "Error loading script."
        }
    }

    7{
        try{
            . ("$scriptdirectory\subs\Get Host IPs.ps1")
        }catch{
            Write-Host "Error loading script."
        }
    }

    { ($userselection -eq "q") -or ($userselection -eq "Q") }{

        $continue = 0

    }

}

}
