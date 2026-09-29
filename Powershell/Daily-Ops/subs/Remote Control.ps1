#This module is used to shadow a Remote Desktop Session on our Thin Client server.
#Normally, a computer may only have one RDP session active at a time, but the shadow
# service allows a VLC-like control over an active session.

#quser.exe queries all active sessions and returns them in a sessionID-user table
#An admin enters the session ID of the user they wish to control and the script manages the connection

cls

quser.exe /server:Prometheus

Write-Host "`n"

$userprompt = 'Enter ID of user to control'

$userselection = Read-Host -Prompt $userprompt

mstsc /v:Prometheus /shadow:$userselection /control /noconsentprompt

Write-Host 'Attempting to Connect...'

PAUSE