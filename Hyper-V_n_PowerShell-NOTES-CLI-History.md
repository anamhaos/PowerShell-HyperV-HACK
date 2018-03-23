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