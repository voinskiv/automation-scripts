@echo off

echo Add ssh
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server
powershell -Command "& {Set-Service -Name sshd -StartupType 'Automatic';}"
powershell -Command "& {Start-Service sshd;}"

echo Add Remote Desktop
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="Remotedesktop" new enable=Yes

echo Add Parsec
cd "%UserProfile%"\Downloads"
curl https://builds.parsecgaming.com/package/parsec-windows.exe -o parsec-windows.exe
parsec-windows.exe /silent /shared /vdd
:: ping localhost
:: del /f parsec-windows.exe

echo Remove Apps
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
winget uninstall --name "Microsoft 365 (Office)"
winget uninstall --name "Solitaire & Casual Games"
winget uninstall --name "Spotify Music"
winget uninstall --name "Microsoft-Tipps"
winget uninstall --name "Xbox Game Bar"
winget uninstall --name "Xbox"
winget uninstall --name "Xbox TCUI"

echo Add Apps
winget install "Google Chrome"
winget install "Google Drive"

echo Add Microsoft Teams
cd "%UserProfile%"\Downloads"
curl -LOJ https://go.microsoft.com/fwlink/?linkid=2187327
TeamsSetup_c_w_.exe /silent
:: ping localhost
:: del /f TeamsSetup_c_w_.exe

echo Add OS Updates
usoclient ScanInstallWait

echo Add Dell Updates
"%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe" /configure -scheduleAuto
"%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates

echo Add App Updates
:: winget upgrade --all --silent
powershell -Command "& {Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod;}"
start ms-windows-store:
:: https://www.codeproject.com/Tips/647828/Press-Any-Key-Automatically-Usi
:: start ms-powerautomate:

echo Remove Widgets from Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f

echo Remove Search from Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f

echo Disable Bing Search
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V BingSearchEnabled /T REG_DWORD /D 0 /f

echo Remove Chat from Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f

echo Set Wallpaper
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\img0.jpg" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f

echo Clear Desktop Downloads
del /q "%UserProfile%"\Desktop\*
del /q "%Public%"\Desktop\*
del /q "%UserProfile%"\Downloads\*
rd /s /q "%SystemDrive%"\$recycle.bin

echo Remove Apps at startup
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f

:: echo Set up Google Chrome
:: Sign In
:: Activate sync
:: Set as default browser (also pdf)

:: echo Set up Google Drive
:: Sign in
:: Add folders to sync
:: Add folders to backup to Photos

:: pause
