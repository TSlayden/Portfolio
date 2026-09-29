#This module is for assistance with troubleshooting network connectivity issues
#It maps hostnames to ip addresses, but care must be taken interpereting the results
# as stale entries may exist for disconnected network interfaces

$continue = 1

while($continue){

    $hostname = Read-Host -Prompt 'Enter Host to Find'

    [System.Net.Dns]::GetHostAddresses($hostname) | foreach { echo $_.IPAddressToString }

    $selection = Read-Host -Prompt 'Search Another? y/n'

    if( ($selection -eq 'y') -or ($selection -eq 'Y') ){
        $continue = 1
    }else{
        $continue = 0
    }
}