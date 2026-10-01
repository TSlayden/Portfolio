This is a collection of utility scripts designed in PowerShell to automate repetitive tasks and uncommon administrative workflows.

-Daily-Ops
Daily Ops consists of a Main Menu script which redirects to several frequently used Active Directory based subtasks.

    1. Find Lockouts - Queries all user lockouts within a user-defined day range for a specified Domain Controller (DC). Useful for tracking down the origin of frequent lockouts.
    
    2. View Locked-Out Users - Queries the DC and returns all currently locked-out accounts with built-in unlocking capability.

    3. Reset User Password - A quick password reset tool which accepts a username and new password, initiating a reset. Includes an optional switch to mandate a password change upon next login.

    4. Disable Account - An access revocation script that rapidly deactivates a user's Active Directory account and associated Exchange mailbox (if applicable).

    5. Copy a User AD Account - A core onboarding script which clones security groups from an existing user to a new account and provisions the new user's network file share.

    6. Remote Control Prometheus Session - Shadows a Remote Desktop session on the thin client server, providing VNC-like control over the active session.

    7. Get Host IP (Experimental) - Resolves and displays IP addresses for a given host. Useful for identifying secondary IPs when DNS routes to a stale entry or disconnected interface.


-Exchange
This directory contains a series of ad-hoc maintenance scripts written for Exchange Online administration. The README within details each script's function.