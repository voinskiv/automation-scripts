MANUFACTURER=$(powershell "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property Manufacturer" | grep Dell)
YELLOW="\e[33m"; ENDCOLOR="\e[0m"

echo "
alias update=\"usoclient StartInteractiveScan\"
alias dellupdate=\"usoclient StartInteractiveScan\"
alias install=\"winget install --name\"
alias uninstall=\"winget uninstall --name\" " >> ~/.bash_profile; . ~/.bash_profile

echo Set up data encryption
manage-bde -on C:
echo -e ${YELLOW}Save recovery key to turn on data encryption${ENDCOLOR}

echo Update system
# Deploy Windows updates
update
# Deploy Dell updates
"/C/Program Files/Dell/CommandUpdate/dcu-cli.exe" //configure -scheduleAuto
"/C/Program Files/Dell/CommandUpdate/dcu-cli.exe" //applyUpdates

echo Customize system settings
# Change desktop background image 
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\img0.jpg" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings" /v EnabledState /t REG_DWORD /d "0" /f
# Change lock screen
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f
# Turn off search on taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f
# Turn off chat on taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f
# Turn off widgets on taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
# Turn off Bing in search
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V BingSearchEnabled /T REG_DWORD /D 0 /f

echo Uninstall pre-installed apps
uninstall "Clipchamp" --accept-source-agreements
uninstall "Dell Core Services"
uninstall "Dell Digital Delivery"
uninstall "Dell Digital Delivery Services" --silent
"/C/Program Files/Dell/Dell Display Manager 2.0/uninst.exe" //S
"/C/Program Files (x86)/InstallShield Installation Information/{286A9ADE-A581-43E8-AA85-6F5D58C7DC88}/DellOptimizer.exe" -remove -silent
uninstall "Dell SupportAssist"
uninstall "Dell SupportAssist OS Recovery Plugin for Dell Update"
uninstall "Dell SupportAssist Remediation"
uninstall "Family"
uninstall "Feedback-Hub"
uninstall "Filme & TV"
uninstall "Nachrichten"
uninstall "Microsoft 365 (Office)"
uninstall "Solitaire & Casual Games"
uninstall "Spotify"
uninstall "Microsoft-Tipps"
uninstall "Xbox Game Bar"
uninstall "Xbox"
uninstall "Xbox TCUI"

echo Install apps
install "Microsoft 365 Apps"
install "Adobe Acrobat Reader DC (64-bit)"
install "Tailscale" -h
install "Google Chrome"
install "Google Drive"
install "Rclone"

echo Turn on remote login using SSH
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server
powershell -Command "& {Set-Service -Name sshd -StartupType 'Automatic';}"
powershell -Command "& {Start-Service sshd;}"

echo Turn on remote management using Remote Desktop
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="Remotedesktop" new enable=Yes

echo Disable not needed startup apps
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f

echo Clear Desktop and Downloads
del /q "%UserProfile%\Desktop\*"
del /q "%Public%\Desktop\*"
del /q "%UserProfile%\Downloads\*"
rd /s /q "%SystemDrive%\$recycle.bin"

echo Action required
echo [ ] Create PIN to sign in
echo [ ] Clear taskbar and start menu
echo [ ] Update pre-installed apps
echo [ ] Set up installed apps

pause
