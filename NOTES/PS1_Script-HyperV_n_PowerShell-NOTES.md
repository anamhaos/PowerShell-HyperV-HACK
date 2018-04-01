# Hyper-V n. PowerShell

New-VMSwitch -Name "HaoScripSwtch1" -NetAdapterName "Ethernet1A"

<#
New-VM -Name "VMTest" -MemoryStartupBytes 1GB `
-SwitchName "HaoScripSwtch" `
-NewVHDPath "C:\Users\bhaos\Desktop\test\VMTest.vhdx" `
-NewVHDSizeBytes 20GB
*>

Start-VM -name VMTest

###### [*](https://www.red-gate.com/simple-talk/sysadmin/powershell/hyper-v-powershell-basics/)


powershell.exe -ExecutionPolicy Bypass -Command "& {Start-VM -Name 'VMTest'}"
###### [*](https://serverfault.com/questions/864676/full-non-interactive-start-connect-to-vm-from-powershell))





read-host
# pause, muk with the VM
###### [*](https://hinchley.net/articles/update-an-iso-using-powershell/)




Remove-VM -Name "VMTest" -Force
###### [*](https://docs.microsoft.com/en-us/powershell/module/hyper-v/remove-vm?view=win10-ps)

Remove-VMSwitch "HaoScripSwtch"
###### [*](https://docs.microsoft.com/en-us/powershell/module/hyper-v/remove-vmswitch?view=win10-ps)



###### [*]()
###### [*]()
###### [*]()
###### [*]()
###### [*]()
###### [*]()
###### [*]()
###### [*]()
