# Hyper-V n. PowerShell


# Create Virtual Switch connected to ...
New-VMSwitch -Name "HaoScripSwtch1" -NetAdapterName "Ethernet1A"

# Create VM w. new Virtual Drive 
New-VM -Name "VMTest" -MemoryStartupBytes 1GB -SwitchName "HaoScripSwtch1" -NewVHDPath "C:\Users\bhaos\Desktop\test\VMTest.vhdx" -NewVHDSizeBytes 20GB

# Create second Virtual Drive
#New-VHD -Path "C:\Users\bhaos\Desktop\test\VMTest2.vhdx" -SizeBytes 10GB -Fixed
# Attach second Virtual Drive
#Add-VMHardDiskDrive -VMName VMTest -Path "C:\Users\bhaos\Desktop\test\VMTest2.vhdx"




###### [*](https://www.red-gate.com/simple-talk/sysadmin/powershell/hyper-v-powershell-basics/)

# Attach iso to VM
Set-VMDvdDrive -VMName VMTest -Path "C:\Users\bhaos\Desktop\iso\ubuntu_server_unattended.iso"
###### [*](https://docs.microsoft.com/en-us/powershell/module/hyper-v/set-vmdvddrive?view=win10-ps)



# Spin up that new VM
Start-VM -name VMTest
# Start a terminal connected to the VM
vmconnect localhost 'VMTest'
###### [*](https://serverfault.com/questions/864676/full-non-interactive-start-connect-to-vm-from-powershell))

# Get-VMSwitch




read-host
# pause, muk with the VM
###### [*](https://hinchley.net/articles/update-an-iso-using-powershell/)



Stop-VM -name VMTest -Force

Remove-VM -Name "VMTest" -Force
###### [*](https://docs.microsoft.com/en-us/powershell/module/hyper-v/remove-vm?view=win10-ps)

Remove-VMSwitch "HaoScripSwtch1" -Force
###### [*](https://docs.microsoft.com/en-us/powershell/module/hyper-v/remove-vmswitch?view=win10-ps)



###### [*]()
###### [*]()
###### [*]()
###### [*]()
###### [*]()
###### [*]()
###### [*]()
