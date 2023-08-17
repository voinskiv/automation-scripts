@echo off

echo Add ssh
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server
powershell -Command "& {Set-Service -Name sshd -StartupType 'Automatic';}"
powershell -Command "& {Start-Service sshd;}"

echo Add Remote Desktop
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="Remotedesktop" new enable=Yes

echo Remove apps
winget uninstall --name "Clipchamp" --accept-source-agreements
winget uninstall --name "Dell Core Services"
winget uninstall --name "Dell Digital Delivery"
winget uninstall --name "Dell Digital Delivery Services" --silent
"%ProgramFiles%\Dell\Dell Display Manager 2.0\uninst.exe" /S
"%ProgramFiles(x86)%\InstallShield Installation Information"\{286A9ADE-A581-43E8-AA85-6F5D58C7DC88}\DellOptimizer.exe -remove -silent
winget uninstall --name "Dell SupportAssist"
winget uninstall --name "Dell SupportAssist OS Recovery Plugin for Dell Update"
winget uninstall --name "Dell SupportAssist Remediation"
winget uninstall --name "Family"
winget uninstall --name "Feedback-Hub"
winget uninstall --name "Filme & TV"
winget uninstall --name "Nachrichten"
winget uninstall --name "Solitaire & Casual Games"
winget uninstall --name "Spotify Music"
winget uninstall --name "Microsoft-Tipps"
winget uninstall --name "Xbox Game Bar"
winget uninstall --name "Xbox"
winget uninstall --name "Xbox TCUI"

echo Add OS Updates
usoclient ScanInstallWait

echo Add Dell Updates
"%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe" /configure -scheduleAuto
"%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates

:: auto App Updates

echo Remove widgets from taskbar
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f

echo Set Wallpaper
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\web\wallpaper\Windows\img0.jpg" /f

echo Clear Desktop Downloads
del /q "%userprofile%"\Desktop\*
del /q "%userprofile%"\Downloads\*setup.bat
rd /s /q "%systemdrive%"\$recycle.bin

:: pause
