# Hyper-V n. PowerShell

New-VMSwitch -Name "HaoScripSwtch1" -NetAdapterName "Ethernet1A"


New-VM -Name "VMTest" -MemoryStartupBytes 1GB -SwitchName "HaoScripSwtch1" -NewVHDPath "C:\Users\bhaos\Desktop\test\VMTest.vhdx" -NewVHDSizeBytes 20GB

###### [*](https://www.red-gate.com/simple-talk/sysadmin/powershell/hyper-v-powershell-basics/)



Start-VM -name VMTest
# Spin up that new VM
vmconnect localhost 'VMTest'
# Start a terminal connected to the VM
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
