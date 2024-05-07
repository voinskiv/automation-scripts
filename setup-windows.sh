#!/bin/bash
#
# winget install --name "Git" --source winget
#
# Install WinGet packages, optimise and set settings.

apps_to_uninstall=(
  "Tailscale"
  "Rclone"
  "Google Chrome"
  "Google Drive"
  "Microsoft 365 Apps for Enterprise"
  "Adobe Acrobat Reader DC (64-bit)"
)

dell_apps_to_uninstall=(
  "Dell Core Services"
  "Dell Digital Delivery"
  "Dell Digital Delivery Services"
  "Dell Display Manager"
  "Dell Optimizer"
  "Dell SupportAssist"
  "Dell SupportAssist OS Recovery Plugin for Dell Update"
  "Dell SupportAssist Remediation"
)

apps_to_install=(
  "Clipchamp"
  "Family"
  "Feedback-Hub"
  "Filme & TV"
  "Nachrichten"
  "Microsoft 365 (Office)"
  "Solitaire & Casual Games"
  "Spotify"
  "Microsoft-Tipps"
  "Xbox Game Bar"
  "Xbox"
  "Xbox TCUI"
)

registry_settings=(
    # Change desktop background image
    "HKCU\Control Panel\Desktop Wallpaper C:\Windows\Web\Wallpaper\Windows\img0.jpg"
    # Change lock screen
    "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager RotatingLockScreenEnabled 0"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager RotatingLockScreenOverlayEnabled 0"
    # Turn off search on taskbar
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Search SearchboxTaskbarMode 0"
    # Turn off chat on taskbar
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarMn 0"
    # Turn off widgets on taskbar
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarDa 0"
    # Turn off Bing in search
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Search BingSearchEnabled 0"
)

uninstall_apps() {
  local app_list=("$@")
  for app in "${app_list[@]}"; do
    winget uninstall --name "$app" --accept-source-agreements --silent
  done
}

install_apps() {
  local app_list=("$@")
  for app in "${app_list[@]}"; do
    winget install --name "$app" --accept-source-agreements --silent
  done
}

set_registry_value() {
    local reg_key="$1"
    local value_name="$2"
    local value_data="$3"
    reg add "$reg_key" /v "$value_name" /t REG_SZ /d "$value_data" /f
}

uninstall_apps "${apps_to_uninstall[@]}"

if [[ "$(wmic csproduct get vendor | grep -o 'Dell')" == "Dell" ]]; then
  uninstall_apps "${dell_apps_to_uninstall[@]}"
fi

install_apps "${apps_to_install[@]}"

# Iterate over each registry setting and apply it
for setting in "${registry_settings[@]}"; do
    set_registry_value $setting
done











echo "
alias update=\"usoclient StartInteractiveScan\"
alias dellupdate=\"usoclient StartInteractiveScan\" " >> ~/.bash_profile; . ~/.bash_profile

# Set up data encryption.
manage-bde -on C:
echo -e ${YELLOW}Save recovery key to turn on data encryption${ENDCOLOR}

# Update system.
## Deploy Windows updates.
update
## Deploy Dell updates.
"/C/Program Files/Dell/CommandUpdate/dcu-cli.exe" //configure -scheduleAuto
"/C/Program Files/Dell/CommandUpdate/dcu-cli.exe" //applyUpdates

# Set system settings.
## Change desktop background image.
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\img0.jpg" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings" /v EnabledState /t REG_DWORD /d "0" /f
## Change lock screen.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f
## Turn off search on taskbar.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f
## Turn off chat on taskbar.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f
## Turn off widgets on taskbar.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
## Turn off Bing in search.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f



reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\img0.jpg" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings" /v EnabledState /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V BingSearchEnabled /T REG_DWORD /D 0 /f









# Turn on remote login using SSH.
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server
powershell -Command "& {Set-Service -Name sshd -StartupType 'Automatic';}"
powershell -Command "& {Start-Service sshd;}"

# Turn on remote management using Remote Desktop.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="Remotedesktop" new enable=Yes

# Disable not needed startup apps.
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f

# Clear Desktop and Downloads.
del /q "%UserProfile%\Desktop\*"
del /q "%Public%\Desktop\*"
del /q "%UserProfile%\Downloads\*"
rd /s /q "%SystemDrive%\$recycle.bin"




YELLOW="\e[33m"; ENDCOLOR="\e[0m"
# Action required.
echo [ ] Create PIN to sign in
echo [ ] Clear taskbar and start menu
echo [ ] Update pre-installed apps
echo [ ] Set up installed apps

pause
