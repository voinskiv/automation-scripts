#!/bin/bash
#
# winget install --name "Git" --source winget
#
# Install WinGet packages, optimise and set settings

# Path to Dell Command Update CLI
dcu_cli="/C/Program Files/Dell/CommandUpdate/dcu-cli.exe"

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

uninstall_apps() {
  local app_list=("$@")
  for app in "${app_list[@]}"; do
    winget uninstall --name "$app" --accept-source-agreements --silent
  done
}

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

install_apps() {
  for app in "${apps_to_install[@]}"; do
    winget install --name "$app" --accept-source-agreements --silent
  done
}

registry_settings=(
  # Set desktop background image
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
  "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" "0"
)

apply_registry_settings() {
  for setting in "${registry_settings[@]}"; do
      set_registry_value "$setting"
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

install_apps

apply_registry_settings

del /q "$USERPROFILE/Desktop/*"

# Check for and initiate OS updates
usoclient StartInteractiveScan

# Configure Dell automatic scheduling and apply updates
if [ -f "$dcu_cli" ]; then
  "$dcu_cli" //configure -scheduleAuto
  "$dcu_cli" //applyUpdates
fi

# Activate BitLocker encryption and retrieve recovery key
manage-bde -on C:
manage-bde -protectors -get C: -type recoverypassword

# Install SSH Server and set to start automatically
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server
sc config ssh start=auto
sc start sshd

# Turn on Remote Desktop
set_registry_value "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" "0"
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes

# Disable startup items
wmic startup where name="SecurityHealth" call disable
wmic startup where name="OneDrive" call disable