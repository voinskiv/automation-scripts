@echo off

set destination=--onedrive-no-versions onedrive:"\Backups\%COMPUTERNAME%

rclone sync "%USERPROFILE%\Desktop" %destination%\Desktop\Letztes" --backup-dir %destination%\Desktop\%date%"
rclone sync "%USERPROFILE%\Documents" %destination%\Dokumente\Letztes" --backup-dir %destination%\Dokumente\%date%"
rclone sync "G:\Meine Ablage" %destination%\Meine Ablage\Letztes" --backup-dir %destination%\Meine Ablage\%date%"
