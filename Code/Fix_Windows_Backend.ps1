# Run in Administrator PowerShell. This adjusts only the observed Python TCP
# block rule so the existing project allow rule can apply to port 3001.
$ErrorActionPreference = 'Stop'
$cnBlockName = 'TCP Query User{FA46018F-5F4D-4DBC-83D5-ECB66893C658}C:\users\admin\appdata\local\programs\python\python313\python.exe'
$cnRule = Get-NetFirewallRule -Name $cnBlockName
$cnApp = $cnRule | Get-NetFirewallApplicationFilter
$cnPort = $cnRule | Get-NetFirewallPortFilter
if ($cnRule.Action -ne 'Block' -or $cnRule.Direction -ne 'Inbound' -or $cnApp.Program -ine 'C:\users\admin\appdata\local\programs\python\python313\python.exe' -or "$($cnPort.Protocol)" -notin @('TCP','6')) {
    throw 'The observed rule no longer matches. Stop and send this output.'
}
Set-NetFirewallRule -Name $cnBlockName -LocalPort '0-3000','3002-65535'
Get-NetFirewallRule -Name $cnBlockName | Get-NetFirewallPortFilter | Format-List Protocol,LocalPort
Write-Output 'The Python TCP block still covers other ports. Port 3001 now uses the existing project allow rule; the UDP block and firewall stay enabled.'
