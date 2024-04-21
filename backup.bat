@echo off

rclone sync "%USERPROFILE%\Desktop" onedrive:"\Backups\%COMPUTERNAME%\Desktop\Letztes" --backup-dir onedrive:"\Backups\%COMPUTERNAME%\Desktop\%date%" --onedrive-no-versions
rclone sync "%USERPROFILE%\Documents" onedrive:"\Backups\%COMPUTERNAME%\Dokumente\Letztes" --backup-dir onedrive:"\Backups\%COMPUTERNAME%\Dokumente\%date%" --onedrive-no-versions
rclone sync "G:\Meine Ablage" onedrive:"\Backups\Meine Ablage\Letztes" --backup-dir onedrive:"\Backups\Meine Ablage\%date%" --onedrive-no-versions
