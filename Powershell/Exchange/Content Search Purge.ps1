<#

Content Search Purge is intended to be used in conjunction with a user-initiated content search in the Exchange portal.
Once the results are queried and reviewed in the Exchange portal, this script can be run to purge the results out of the system.

#>


<#

1. Log in to Exchange and Re-route to Compliance & Security Center

2. Get list of all content searches

3. Build a function to Review List of Content Searches

4. Soft Purge items from content search

#>


<#1. Importing the module and getting connected
    - Two connections will happen here
    - One goes to Exchange Online
    - The second redirects to the Compliance & Security Center
#>
Import-Module ExchangeOnlineManagement

Write-Host "You must log in with ITAdmin at the login prompts."
PAUSE

Connect-ExchangeOnline

Write-Host "Exchange Online Connected!"
Write-Host "Re-routing to Compliance & Security Center..."

Connect-IPPSSession

Write-Host "Done!"

<#2. Get a list of all content searches
    - Pulls a list of all Searches in the system
    - Populates them in a list for later usage
#>

Write-Host "Populating Compliance Searches..."

$name_list = New-Object 'System.Collections.Generic.List[string]'
$gather_list = Get-ComplianceSearch  | Select-Object -ExpandProperty Name

<#Here we are breaking out all Searches into a list#>
ForEach ($item in $gather_list){

    [void]$name_list.Add($item)
    
}

<#3. A function to show the list of searches
    - Review the list
    - Select an item from the list, based on index
    - Verify the selected Search is the correct one to purge
    - Confirm selection, or deny
    - If denied, prompt to Search again or logout
    - If confirmed, begin Soft Purge of selected Search
#>

function List-Searches{

cls
Write-Host "Here is a list of Searches:"

<#Apply the Indexes to the list of gathered Searches#>
$CS_int = 0
ForEach($item in $gather_list){
    Write-Host "$CS_int) $item"
    $CS_int++
}

Write-Host "`n `n"

$CS_choice = Read-Host -Prompt "Enter Index of Item to Delete"

<#Pull the user selected Search out of the Search list, based on the User Provided Index#>
$CS_item = $name_list[$CS_choice]

<#User will confirm if the selected item is correct#>
$CS_confirm = Read-Host -Prompt "You are Deleting items from: $CS_item `n Is this correct? (Y/N)"

<#If confirmed, Purge of Selected item will begin
    If denied, user will be prompted to Search again or quit
        If user searches again, the function will call itself recursively
        If user quits, Powershell will gracefully close its connections#>
switch($CS_confirm){
    "Y"{
        New-ComplianceSearchAction -SearchName $CS_item -Purge -PurgeType SoftDelete
        Write-Host "Purge started. You will now be gracefully disconnected from Exchange. Please"
        PAUSE
    }
    default{
        $CS_confirm = Read-Host -Prompt "Continue Purging? (Y/N)"
           Switch($CS_confirm){
                   "Y"{
                        List-Searches
                   }
                   default{
                        Write-Host "Disconnecting Sessions, Please Wait"
                   }
           }
    }

}

}

List-Searches

Disconnect-ExchangeOnline -Confirm:$false
