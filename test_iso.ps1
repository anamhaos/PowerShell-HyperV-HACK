# Hyper-V n. PowerShell Iterative VM Tool

$VM_Name="TempVM1"
$VM_Switch_Name="TempSwitch"
$Host_Net_Adapter_Name="Ethernet1A"
$VM_Create_Workspace="$env:userprofile\Desktop\PowerShell-HyperV-HACK\VMTEMP"
$VM_Confg_Store="$VM_Create_Workspace\confgs"
$VM_Drive_Store="$VM_Create_Workspace\drives"
$ISO_Name="ubuntu-16.04.4-server-amd64-unattended.iso"
$ISO_Location="$env:userprofile\Desktop"
$ISO_Path="$ISO_Location\$ISO_Name"

# Create Virtual Switch connected to ...
#New-VMSwitch -Name $VM_Switch_Name -NetAdapterName $Host_Net_Adapter_Name
# Create VM w. new Virtual Drive 
New-VM -Name $VM_Name -Path $VM_Confg_Store -MemoryStartupBytes 4GB -SwitchName $VM_Switch_Name -NewVHDPath $VM_Drive_Store\$VM_Name.vhdx -NewVHDSizeBytes 20GB
# Attach iso to VM
Set-VMDvdDrive -VMName $VM_Name -Path $ISO_Path
# Spin up that new VM
Start-VM -name $VM_Name
# Start a terminal connected to the VM
vmconnect localhost $VM_Name

# pause 2 muk with VM
read-host
Stop-VM -name $VM_Name -Force

Remove-VM -Name $VM_Name -Force

#Remove-VMSwitch $VM_Switch_Name -Force

# Delete Workspace
#Remove-Item $VM_Create_Workspace -Force -Recurse

<#
# Open Admin Windows Powershell 
cd $env:userprofile\Desktop\PowerShell-HyperV-HACK
.\setup_iterative_vm.ps1
#>
