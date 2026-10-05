$ErrorActionPreference = 'Continue'
Write-Output '=== Wi-Fi IPv4 ==='
Get-NetIPAddress -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 | Select-Object IPAddress, PrefixLength, AddressState | Format-Table -AutoSize
Write-Output '=== Backend listener and executable ==='
$cnListeners = Get-NetTCPConnection -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue
$cnListeners | Select-Object LocalAddress, LocalPort, OwningProcess | Format-Table -AutoSize
$cnExecutables = @()
foreach ($cnListener in $cnListeners) {
    $cnProcess = Get-CimInstance Win32_Process -Filter "ProcessId = $($cnListener.OwningProcess)"
    $cnExecutables += $cnProcess.ExecutablePath
    $cnProcess | Select-Object ProcessId, Name, ExecutablePath | Format-List
}
Write-Output '=== Active network profile ==='
Get-NetConnectionProfile | Select-Object InterfaceAlias, NetworkCategory, IPv4Connectivity | Format-Table -AutoSize
Write-Output '=== Active project allow rule ==='
$cnRule = Get-NetFirewallRule -Name 'CN_Phase1_Backend_A' -PolicyStore ActiveStore -ErrorAction SilentlyContinue
$cnRule | Select-Object Name, Enabled, Direction, Action, Profile, EnforcementStatus, PolicyStoreSourceType | Format-List
$cnRule | Get-NetFirewallAddressFilter | Format-List LocalAddress, RemoteAddress
$cnRule | Get-NetFirewallPortFilter | Format-List Protocol, LocalPort, RemotePort
Write-Output '=== Firewall profile settings ==='
Get-NetFirewallProfile -PolicyStore ActiveStore | Select-Object Name, Enabled, DefaultInboundAction, AllowInboundRules, AllowLocalFirewallRules | Format-Table -AutoSize
Write-Output '=== Enabled inbound block rules for Python or all programs ==='
Get-NetFirewallRule -PolicyStore ActiveStore -Enabled True -Direction Inbound -Action Block | ForEach-Object {
    $cnBlock = $_
    $cnApp = $cnBlock | Get-NetFirewallApplicationFilter
    if (($cnApp.Program -match 'python') -or ($cnApp.Program -eq 'Any') -or ($cnExecutables -contains $cnApp.Program)) {
        $cnPort = $cnBlock | Get-NetFirewallPortFilter
        $cnAddress = $cnBlock | Get-NetFirewallAddressFilter
        [PSCustomObject]@{
            Name = $cnBlock.Name
            DisplayName = $cnBlock.DisplayName
            Program = $cnApp.Program
            Profile = $cnBlock.Profile
            Protocol = $cnPort.Protocol
            LocalPort = ($cnPort.LocalPort -join ',')
            RemoteAddress = ($cnAddress.RemoteAddress -join ',')
            PolicyStoreSourceType = $cnBlock.PolicyStoreSourceType
        } | Format-List
    }
}
Write-Output 'Read-only check complete. No firewall rules or network settings were changed.'
