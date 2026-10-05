# Run only when the project is finished, in Administrator PowerShell.
$ErrorActionPreference = 'Stop'
$cnBlockName = 'TCP Query User{FA46018F-5F4D-4DBC-83D5-ECB66893C658}C:\users\admin\appdata\local\programs\python\python313\python.exe'
Set-NetFirewallRule -Name $cnBlockName -LocalPort Any
Remove-NetFirewallRule -Name 'CN_Phase1_Backend_A'
Write-Output 'Restored the original Python TCP block and removed the project allow rule.'
