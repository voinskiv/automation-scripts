@echo off

set destination=onedrive:\Backups\%COMPUTERNAME%\%USERNAME%
set timestamp=%date:~6,4%-%date:~3,2%-%date:~0,2%-%time:~0,2%%time:~3,2%%time:~6,2%
set options=--progress --onedrive-no-versions
set filter=--exclude .*/ --exclude {~*,*.ini}
set log=--log-file "%APPDATA%\rclone\backup.log"
set settings=%options% %filter% %log%

echo Back up Desktop files
rclone sync %settings% "%USERPROFILE%\Desktop" "%destination%\Desktop\Letztes" --backup-dir "%destination%\Desktop\%timestamp%"

echo Back up Documents files
rclone sync %settings% "%USERPROFILE%\Documents" "%destination%\Dokumente\Letztes" --backup-dir "%destination%\Dokumente\%timestamp%"

echo Back up Pictures files
rclone sync %settings% "%USERPROFILE%\Pictures" "%destination%\Bilder\Letztes" --backup-dir "%destination%\Bilder\%timestamp%"

echo Back up Google Drive files
rclone sync %settings% "G:\Meine Ablage" "%destination%\Meine Ablage\Letztes" --backup-dir "%destination%\Meine Ablage\%timestamp%"
