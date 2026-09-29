#This script is used to query all user lockouts within a user-defined day range for a specified DC

#This script is useful for determining where frequent lockouts are coming from, as well as
# any workstations which may have stale credentials attempting to access NTFS shares

$logservers
$logname = "Security"
$logid = "4740"
$logdate = 0
$logdays = 0

$logsource = ""
$logcount = 1

$logevents = ""

$paddivider = "-----------------------------------------"

cls
Write-Host "Collecting Domain Info..."
$logdomaincontroller = (Get-ADDomain).DNSRoot

Write-Host "Gathering Controller Info..."
$logservers = Get-ADDomainController -Filter * -Server $logdomaincontroller

Write-Host "DONE!"

[int]$logdays = Read-Host -Prompt "Enter Number of Days to search"

$logdays = $logdays * -1

$logdate = (Get-Date).AddDays($logdays)

foreach($lserver in $logservers){
    Write-Host "$logcount) $lserver"
    $logcount++
}

$logcount = Read-Host -Prompt "Select Log Server"

$logsource = $logservers[$logcount-1]

<# Write-Host $logsource

Write-Host $logdate
#>

<#
Get-EventLog -ComputerName $logsource -LogName $logname -InstanceId $logid -After $logdate -Newest 2 | Select-Object -Property TimeGenerated, Message
#>

$logevents = Get-WinEvent -ComputerName $logsource -FilterHashtable @{
    Logname="$logname"
    ID="$logid"
    StartTime="$logdate"

} | Select-Object -Property *

foreach($logevent in $logevents){
    Write-Host $paddivider
    Select-Object -InputObject $logevent -ExpandProperty TimeCreated | Write-Host
    Select-Object -InputObject $logevent -ExpandProperty Message | Write-Host
    Write-Host $paddivider
}

PAUSE
