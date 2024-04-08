@echo off

echo Set up data encryption with BitLocker
manage-bde -on C:

echo Update system
usoclient StartInteractiveScan

echo Deploy Dell updates
"%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe" /configure -scheduleAuto
"%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates

echo Change desktop background image 
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\img0.jpg" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings" /v EnabledState /t REG_DWORD /d "0" /f

echo Change lock screen
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f

echo Turn off search on taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f

echo Turn off chat on taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f

echo Turn off widgets on taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f

echo Turn off Bing in search
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V BingSearchEnabled /T REG_DWORD /D 0 /f

echo Uninstall not needed pre-installed apps
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
winget uninstall --name "Spotify"
winget uninstall --name "Microsoft-Tipps"
winget uninstall --name "Xbox Game Bar"
winget uninstall --name "Xbox"
winget uninstall --name "Xbox TCUI"

echo Install Microsoft 365 Apps
winget install --name "Microsoft 365 Apps"

echo Install Acrobat Reader to interact with PDF files
winget install --name "Adobe Acrobat Reader DC (64-bit)"

echo Turn on remote login using SSH
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server
powershell -Command "& {Set-Service -Name sshd -StartupType 'Automatic';}"
powershell -Command "& {Start-Service sshd;}"

echo Turn on remote management using Remote Desktop
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="Remotedesktop" new enable=Yes

echo Deploy secure remote access using Tailscale
winget install "Tailscale" -h

echo Install Google Chrome to sync Google account
winget install --name "Google Chrome"

echo Install Google Chrome to sync Google account files
winget install "Google Drive"

echo Disable startup apps
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f

echo Clear Desktop and Downloads
del /q "%UserProfile%\Desktop\*"
del /q "%Public%\Desktop\*"
del /q "%UserProfile%\Downloads\*"
rd /s /q "%SystemDrive%\$recycle.bin"

echo [ ] Turn on data encryption with BitLocker

echo [ ] Clear taskbar nad start menu

echo [ ] Update pre-installed apps

echo [ ] Set up Acrobat Reader

echo [ ] Set up Google Chrome

echo [ ] Set up Google Drive

pause
