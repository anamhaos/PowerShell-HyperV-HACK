
Get-NetAdapter # Shows ...
Get-VMSwitch # Shows Virtual Switches
Get-VMHost # Shows Specs of Virtual Host
Get-VM # Shows Virtual Machines
vmconnect localhost '' # Open terminal for named VM as in $vmconnect localhost 'vm_name_here'


Stop-VM -name "vm_name_here" -Force
Remove-VM -Name "vm_name_here" -Force

Stop-VM -name "tempubuntu" -Force
Remove-VM -Name "tempubuntu" -Force

Get-VMSwitch
Remove-VMSwitch "HaoScripSwtch1" 


tempubuntu
vubuntusrv

 
# IN PROGRESS



Dismount-DiskImage -ImagePath  "$env:userprofile\Desktop\Temp\iso\ubuntu-16.04.4-server-amd64.iso\" -StorageType ISO







Enable-VMIntegrationService -VMName "VMTest" -Name 'Guest Service Interface'

Copy-VMFile -Name VMTest -SourcePath 'C:\Users\bhaos\Desktop\exper\exp2.bash' -DestinationPath '/newuser/' -FileSource Host

Copy-VMFile -Name VMTest -SourcePath 'C:\Users\bhaos\Desktop\ubuntu-16.04.4-server-amd64.iso' -DestinationPath '/iso/' -CreateFullPath -FileSource Host

Get-VM "VMTest" | Checkpoint-VM -SnapshotName "vmFiles" -Passthru | %{Get-VHD -VMId $_.vmid} | %{Mount-VHD $_.ParentPath -ReadOnly -Passthru} | Get-Disk | Get-Partition | Get-Volume

Get-VM "VMTest" | Checkpoint-VM -SnapshotName "vmIsoFiles" -Passthru | %{Get-VHD -VMId $_.vmid} | %{Mount-VHD $_.ParentPath -ReadOnly -Passthru} | Get-Disk | Get-Partition | Get-Volume

Get-VMSnapshot -VMName "VMTest" -Name "vmIsoFiles" | %{Get-VHD -VMId $_.vmid} | %{Dismount-VHD $_.ParentPath} ; Remove-VMSnapshot -VMName "VMTest" -Name "vmIsoFiles"

# Trying to make iso
$ sudo su -
mkdir -p /mnt/iso
mount -o loop /iso/ubuntu-16.04.4-server-amd64.iso /mnt/iso

# Stop having to type sudo
sudo -i

# SUDO COMMANDS
# shutdown fast
init 0
# Show drives
lshw -C disk

   1 New-VMSwitch -Name "HaoScripSwtch1" -NetAdapterName "Ethernet1A"
   2 New-VMSwitch -Name "HaoScripSwtch1" -NetAdapterName "HaoScripSwtch"...
   3 clear
   4 Get-NetAdapter
   5 Get-VMSwitch
   6 Get-VMHost
   7 Get-VM
   8 Remove-VM -Name "VMTest" -Force...
   9 Remove-VM -Name "Ubuntu_Server" -Force
  10 Get-VM
  11 Remove-VMSwitch "HaoScripSwtch"
  12 Get-VMSwitch
  13 Remove-VMSwitch "EXTERNAL-Virtual_Swtich"
  14 Get-VMSwitch
  15 Remove-VMSwitch "Default Switch"
  16 Get-VMSwitch
  17 cd $env:userprofile\Desktop
  18 .\setup_vm.ps1
  19 Remove-VMSwitch "HaoScripSwtch1"
  20 .\setup_vm.ps1
  21 .\setup_vm.ps1
  22 .\setup_vm.ps1