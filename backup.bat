@echo off

rclone sync "%userprofile%\Desktop" onedrive:"\Backups\Desktop-01\Desktop\Letztes" --backup-dir=onedrive:"\Backups\Desktop-01\Desktop\%date%" --onedrive-no-versions --exclude desktop.ini
rclone sync "%userprofile%\Documents" onedrive:"\Backups\Desktop-01\Dokumente\Letztes" --backup-dir=onedrive:"\Backups\Desktop-01\Dokumente\%date%" --onedrive-no-versions --exclude desktop.ini
rclone sync "G:\Meine Ablage" onedrive:"\Backups\Meine Ablage\Letztes" --backup-dir=onedrive:"\Backups\Meine Ablage\%date%" --onedrive-no-versions --exclude desktop.ini
