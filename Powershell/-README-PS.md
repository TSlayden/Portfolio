These are an assortment of Powershell scripts written to tackle repetitive or uncommon tasks.

-Daily-Ops
Daily Ops consists of a Main Menu script which redirects to a number of common Active Directory based subtasks.

    1. Find Lockouts - This script is used to query all user lockouts within a user-defined day range for a specified DC. Useful for determining where frequent lockouts are originating.
    
    2. View Locked-Out Users - Queries the Domain Controller and returns any users who are locked out. Accounts may be unlocked here, too.

    3. Reset User Password - Quick password reset script which takes a username and a password and initiates a reset. Includes an optional switch to mandate the user to select a new password on login.

    4. Disable Account - A vital access revocation script, quickly deactivates a User's Active Directory and associated Exchange account. (if applicable)

    5. Copy a User AD Account - A core onboarding script, accepts an existing user and clones their security groups to a new user. Also creates the new user's network file share

    6. Remote Control Prometheus Session - Used to shadow a Remote Desktop Session on the Thin Client server, allows VLC-like control over an active session

    7. Get Host IP (Experimental) - Shows IP addresses for a given host. Useful for identifying a secondary IP address for a given Hostname in a scenario where DNS is routing to a stale DNS entry or disconnected network interface.


-Exchange
This contains a number of one-off scripts written to accomplish various tasks in Exchange Online. The README in the Exchange folder gives an overview of what each does.

