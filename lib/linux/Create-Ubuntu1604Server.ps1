<#
This script takes some setup
https://docs.microsoft.com/en-us/windows/wsl/install-win10

<# Use these two command in Admin Powershell Window to run this script.
cd  C:\Users\bhaos\Desktop\PowerShell-HyperV-HACK\lib\linux
.\Create-Ubuntu1604Server.ps1
#>

# Variables for this Script 
# ToDo: Organize these correctly.
$temp_workspace = "$env:userprofile\Desktop\Temp"
# ToDo: Rename this to what it actually is.
$tmp = "$env:userprofile\Desktop\Temp\iso"
# ToDo: Fix this so it is more portable
$sourceDirectory = "$env:userprofile\Desktop\PowerShell-HyperV-HACK\lib\linux"
# ToDo: Attach this to the script that downloads the ISO
$downloadedISO="$env:userprofile\Desktop\ubuntu-16.04.4-server-amd64.iso"
$isoFile = "$env:userprofile\Desktop\Temp\iso\ubuntu-16.04.4-server-amd64.iso"
$isoFileRemastered = "$env:userprofile\Desktop\Temp\iso\ubuntu-16.04.4-server-amd64-unattended.iso"

# Set Variables for Autorun ISO 

$seed_file = "haos.seed"
$hostname = 'tempubuntu'
$switchname = 'HaoScripSwtch1'
$timezone = 'US/Chicago'

# VM User Variables
$rootPassword = "password"
$rootPassword2 = "password"
$username = "newuser"
$password = "password"
$password2 = "password"


function exit_script_correctly_completed(){
  $useless_exit_var = Read-Host " hit return to exit" 

  Stop-VM -name $hostname -Force
  Remove-VM -Name $hostname -Force

  Remove-VMSwitch $switchname 

  Remove-Item $temp_workspace -Force -Recurse
  
  
  Write-Host "Exiting Script" -ForegroundColor green
  cd $env:userprofile\Desktop\PowerShell-HyperV-HACK\lib\linux
  exit
}

function copy_iso_to_temp_dir_on_desktop(){
  # Create needed Directory
  #new-item -itemtype directory -path $tmp
  Write-Host "Copying ISO" -ForegroundColor green
  copy-item $downloadedISO -Destination $isoFile
}


# ToDo: Minify this.
# Check if the passwords match and generate encrypted hash to use in preseed file 
if ($password -eq $password2)
{
    Write-host "Your passwords match, Generating encrypted hash" -ForegroundColor Green -BackgroundColor Black
    # generate the password hash
    $pwhash = bash -c "echo $password | mkpasswd -s -m sha-512"
} 
else 
{
    Write-host "Your passwords do not match; please restart the script and try again" -ForegroundColor Red -BackgroundColor White
    break
}
#echo 'user password hash :'
#echo $pwhash
# Check if the root passwords match and generate encrypted hash to use in ks.cfg file 
if ($rootPassword -eq $rootPassword2)
{
    Write-host "Your root passwords match, Generating encrypted hash" -ForegroundColor Green -BackgroundColor Black
    # generate the password hash
    $rootPwdHash = bash -c "echo $rootPassword | mkpasswd -s -m sha-512"
} 
else 
{
    Write-host "Your root passwords do not match; please restart the script and try again" -ForegroundColor Red -BackgroundColor White
    break
}
#echo 'root password hash:'
#echo $rootPwdHash


# ToDo: Abstract out hard-set paths
# Creating / Verifying Required Folder Structure is available to work
Write-Host "Creating / Verifying Required Folder Structure" -ForegroundColor Yellow
if (-not (Test-Path $tmp)) 
{
    Write-Host "Creating Folder $tmp" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $tmp | Out-Null
    Write-Host "Created Folder $tmp" -ForegroundColor Green
    
    Write-Host "Creating Folder $tmp\iso_org" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path "$tmp\iso_org" | Out-Null
    Write-Host "Created Folder $tmp\iso_org" -ForegroundColor Green
} 
else 
{
    Write-Host "Folder $tmp already exists." -ForegroundColor Green
    if (-not (Test-Path "$tmp\iso_org"))
    {
        Write-Host "Creating Folder $tmp\iso_org" -ForegroundColor Yellow
            New-Item -ItemType Directory -Path "$tmp\iso_org" | Out-Null
        Write-Host "Created Folder $tmp\iso_org" -ForegroundColor Green
    } 
    else 
    {
        Write-Host "Folder $tmp\iso_org already exists." -ForegroundColor Green
    }
}



copy_iso_to_temp_dir_on_desktop

# Mounting C:\LabSources\ISOs\ubuntu-16.04.1-server-amd64.iso file and copy content locally
Write-Host "Mounting Original ISO" -ForegroundColor Yellow

$ISODrive = (Get-DiskImage $isoFile | Get-Volume).DriveLetter
if(! $ISODrive){
    Mount-DiskImage -ImagePath $isoFile -StorageType ISO
}

$ISODrive = (Get-DiskImage $isoFile | Get-Volume).DriveLetter
Write-Host ("$isoFile Drive is " + $ISODrive)

Write-Host "Extracting ISO content to working directory C:\Temp\iso_org" -ForegroundColor Yellow
$ISOSource = ("$ISODrive" + ":\*.*")
xcopy $ISOSource "$tmp\iso_org\" /e

# Copy baseline Kickstart Configuration File To Working Folder
Copy-Item "$sourceDirectory\ks.cfg" -Destination "$tmp\iso_org" -Force

# Copy baseline Seed File (answers for unattended setup) To Working Folder
Copy-Item "$sourceDirectory\$seed_file" "$tmp\iso_org" -Force

# Update the ks.cfg file to reflect encrypted root password hash
(Get-Content "$tmp\iso_org\ks.cfg").replace("rootpw --disabled","rootpw --iscrypted $rootPwdHash" ) | Set-Content "$tmp\iso_org\ks.cfg"

# Update the seed file to reflect the users' choices
(Get-Content "$tmp\iso_org\$seed_file").replace('{{username}}', $username) | Set-Content "$tmp\iso_org\$seed_file"
(Get-Content "$tmp\iso_org\$seed_file").replace('{{pwhash}}', $pwhash) | Set-Content "$tmp\iso_org\$seed_file"
(Get-Content "$tmp\iso_org\$seed_file").replace('{{hostname}}', $hostname) | Set-Content "$tmp\iso_org\$seed_file"
(Get-Content "$tmp\iso_org\$seed_file").replace('{{timezone}}', $timezone) | Set-Content "$tmp\iso_org\$seed_file"

# Update the isolinux.cfg file to reflect boot time choices
(Get-Content "$tmp\iso_org\isolinux\isolinux.cfg").replace('timeout 0', 'timeout 1') | Set-Content "$tmp\iso_org\isolinux\isolinux.cfg"
(Get-Content "$tmp\iso_org\isolinux\isolinux.cfg").replace('prompt 0', 'prompt 1') | Set-Content "$tmp\iso_org\isolinux\isolinux.cfg"

# Building installer menu choice to make it default and use ks.cfg and mshende.seed files
$install_lable = @"
default autoinstall
label autoinstall
  menu label ^Automatically install Ubuntu
  kernel /install/vmlinuz
  append file=/cdrom/preseed/ubuntu-server.seed initrd=/install/initrd.gz auto=true priority=high preseed/file=/cdrom/haos.seed --
"@
#  append file=/cdrom/preseed/ubuntu-server.seed vga=788 initrd=/install/initrd.gz ks=cdrom:/ks.cfg preseed/file=/cdrom/haos.seed quiet --
(Get-Content "$tmp\iso_org\isolinux\txt.cfg").replace('default install', $install_lable) | Set-Content "$tmp\iso_org\isolinux\txt.cfg"

# Creating new ISO file at C:\LabSources\ISOs\ubuntu-16.04.1-server-amd64-unattended.iso
Write-Host " Creating the remastered iso"

Set-location "$tmp\iso_org"
#C:\LabSources\Linux\mkisofs.exe -D -r -V "UBUNTU1604SRV" -duplicates-once -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $isoFileRemastered .
C:\Users\bhaos\Desktop\PowerShell-HyperV-HACK\lib\bin\mkisofs.exe -D -r -V "UBUNTU1604SRV" -duplicates-once -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $isoFileRemastered .








# Create Hyper-v VM
#********************
# Create Folder for VM Config Files(?)
$vmFolder = "$env:userprofile\Desktop\Temp\Hyper-V\Virtual hard disks\Linux"
New-Item -ItemType Directory -Path $vmFolder -Force | Out-Null
New-VM -Name $hostname -NewVHDPath "$vmFolder\$hostname.vhdx" -NewVHDSizeBytes 20gb -MemoryStartupBytes 2GB


Set-VMDvdDrive -VMName $hostname -Path $isoFileRemastered

# Create Virtual Switch connected to ...
New-VMSwitch -Name "HaoScripSwtch1" -NetAdapterName "Ethernet1A"


# Conenct to Hyper-v VM Switch
$vmSwitch = Get-VMSwitch | Where-Object {$_.Name -eq 'HaoScripSwtch1'}


#Add-VMDvdDrive -VMName $hostname -Path $isoFileRemastered




$vmActiveSwitch = Get-VM -Name $hostname -ErrorAction SilentlyContinue | Get-VMNetworkAdapter -ErrorAction SilentlyContinue

if (! $vmActiveSwitch.SwitchName){
    Write-Host "Adding Switch"
    Get-VM -Name $hostname | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName $vmSwitch.Name
}






# Add host entry on my physical machine pointing to VM ip address to connect VM over ssh
#Add-Content $env:SystemRoot\system32\drivers\etc\hosts -Value "192.168.1.12    vubuntusrv"
# Below is line to clear the host entry after vm is discarded
# (Get-Content "$env:SystemRoot\system32\drivers\etc\hosts") | Where-Object {$_ -ne "192.168.1.12    vubuntusrv"} | Set-Content "$env:SystemRoot\system32\drivers\etc\hosts"

# Starting Virtual Machine and Connecting through VM console
Start-VM -Name $hostname
vmconnect.exe localhost $hostname





exit_script_correctly_completed
Write-Host "Exiting Script w. Error" -ForegroundColor red
cd $env:userprofile\Desktop\PowerShell-HyperV-HACK\lib\linux
exit









# Connect to server once ready using putty
# C:\LabSources\Linux\putty.exe -ssh user1@192.168.1.12

















<# Original Code KEEP THIS
# Get User Configurable Values
$rootPassword = Read-Host " Please enter your preferred root password: " 
$rootPassword2 = Read-Host " Confirm your preferred root password: "
$username = Read-Host " Please enter your preferred username: "
$password = Read-Host " Please enter your preferred password: " 
$password2 = Read-Host " Confirm your preferred password: "
#>
