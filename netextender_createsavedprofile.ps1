# Run powershell as admin then .\netextender_createsavedprofile.ps1 or copy and paste this code in and fill in the prompts.



# Creates a new NetExtender saved profile without having to connect to the VPN first for it to save the profile.
# -Nick Seratt


$VPNServer = Read-Host -Prompt 'Enter the VPN Host (and :port if necessary. ex: 123.45.67.89:4433)'
$VPNDomain = Read-Host -Prompt 'Enter the VPN Domain (ex: LocalDomain)'
$VPNUser = Read-Host -Prompt 'Enter the VPN Username (optional)'


$VPNRegistry = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\SonicWALL\SSL-VPN NetExtender\Standalone\Profiles\1D29F37492AE010]
"server"="$VPNServer"
"domain"="$VPNDomain"
"user"="$VPNUser"
"np0"=hex:00
"np1"=hex:d0,2b,28,4a,37,9f,d2,01
"np2"=hex:d0,2b,28,4a,37,9f,d2,01

[HKEY_LOCAL_MACHINE\SOFTWARE\SonicWALL\SSL-VPN NetExtender\Standalone\Profiles]
"defaultProfile"="$VPNServer($VPNUser@$VPNDomain)"
"@


$VPNRegistry -replace '\n', "`r`n"  | Out-File $env:TEMP\vpnreg.reg

cmd /C regedit.exe /S $env:TEMP\vpnreg.reg

Remove-Item  $env:TEMP\vpnreg.reg

Stop-Process -processname NEGui
Restart-Service  SONICWALL_NetExtender