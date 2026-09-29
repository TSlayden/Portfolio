#This is the core onboarding script. It conducts cloning of user groups from existing employees
# to newly created Active Directory accounts with similar job responsibilities

#The script will also create their personal network directory and assign the relevant permissions

Write-Host "Use Ctrl+C to break script at any time" -ForegroundColor red -BackgroundColor black

$source_user = Read-Host -Prompt "Enter user account to copy from"

$firstname = Read-Host -Prompt "Enter New User's first name"

$lastname = Read-Host -Prompt "Enter New User's last name"

$location = ""
$wstop = 1

while( $wstop ){
    $location = Read-Host -Prompt "Is New User a (B)ronson or (H)opkinsville user?"
    switch($location){
        "B" {
                $location = "Bronson"
                $wstop = 0
            }
        "H" {
                $location = "Hopkinsville"
                $wstop = 0
            }
        default {$wstop = 1}
    }
}

$password = Read-Host -Prompt "Enter New User's password"

$AD_verify = Read-Host -Prompt "Is the above information correct? Y/N"

switch($AD_verify){
    "Y"{
        $AD_verify = 0
        Write-Host "Loading Powershell Modules. Please wait..."
    }
    default{
        $AD_verify = 1
    }
}

if($AD_verify){
    Break
}

#Generate User specific profile Setup information
$canonical_name = "autotech.local/" + $location + "/" + $location + " Users/" + $lastname + ", " + $firstname
$CN = $lastname + ", " + $firstname
$display_name = $lastname + ", " + $firstname
$distinguished_name = "CN=" + $lastname + "\, " + $firstname + ",OU=" + $location + " Users,OU=" + $location + ",DC=autotech,DC=local"
$given_name = $firstname
$name = $lastname + ", " + $firstname
$path = "OU=" + $location + " Users,OU=" + $location + ",DC=autotech,DC=local"
$sam_account_name = $lastname + $firstname.Substring(0,1)
$sn = $lastname
$surname = $lastname
$user_principal_name = $sam_account_name + "@autotech.local"

#This block checks if the user exists already.
#If so, one more character is pulled from the user's first name to generate the login name
$chkstop=1
$chk_iter=2
while($chkstop){
    if(dsquery user -samid $sam_account_name){
        Write-Host "User $sam_account_name already exists, pulling 1 more first name letter"
        $sam_account_name = $lastname + $firstname.Substring(0,$chk_iter)
        $user_principal_name = $sam_account_name + "@autotech.local"
        $chk_iter++
    }else{
        $chkstop = 0
    }
}

#Test Write for value checking
#Write-Host $canonical_name + `n + $CN + `n + $display_name + `n + $distinguished_name + `n + $given_name + `n + $name + `n + $path + `n + $sam_account_name + `n + $sn + `n + $surname + `n + $user_principal_name

$copy_from_user = Get-ADUser -Identity $source_user -Properties CannotChangePassword,Enabled,PasswordNeverExpires,ScriptPath

New-ADUser `
-AccountPassword (ConvertTo-SecureString -AsPlainText "$password" -Force) `
-DisplayName $display_name `
-GivenName $given_name `
-Name $name `
-Path $path `
-SamAccountName $sam_account_name `
-Surname $surname `
-UserPrincipalName $user_principal_name `
-Instance $copy_from_user


#Add User to Copied user's groups
$new_ad_user = Get-ADUser -Identity $sam_account_name
$gpmembership = Get-ADPrincipalGroupMembership -Identity $copy_from_user

foreach($member in $gpmembership){
#    Write-Host $member
    Add-ADGroupMember -Identity $member -Members $new_ad_user
}

Write-Host "An Error with +CategoryInfo: NotSpecified: (CN=Domain Users...) is OK."
Write-Host "User $sam_account_name created"


#Create new user's home folder and provide only them Full Control access
$server = ""
$new_user_path =""

switch($location){
    "Bronson" {
            $server = "B"
        }
    "Hopkinsville" {
            $server = "H"
        }
}

$new_user_path = "\\ncc1701$server\home\$sam_account_name"

if(Test-Path $new_user_path){
    Write-Host "User Home Folder Exists, skipping setup."
}else{

    $ad_group = "Builtin\Administrators"
    New-Item -Path $new_user_path -ItemType Directory
    $acl = Get-Acl $new_user_path
    $acl.SetAccessRuleProtection($true,$false)

    $AccessRule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("autotech.local\$sam_account_name","FullControl","ContainerInherit,ObjectInherit","None","Allow")
    $AccessRule2 = New-Object System.Security.AccessControl.FileSystemAccessRule($ad_group,"FullControl","ContainerInherit,ObjectInherit","None","Allow")
    $acl.SetAccessRule($AccessRule1)
    $acl.AddAccessRule($AccessRule2)
        
    $acl | Set-Acl $new_user_path

    Write-Host "New Home folder for $sam_account_name created at"
    Write-Host "$new_user_path"
}

$pause = Read-Host -Prompt "Press Enter to Continue"