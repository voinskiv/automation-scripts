@echo off

set drivelabel=Backups
set path=\Backups\%COMPUTERNAME%\%USERNAME%
set backupdate=%date:~6,4%-%date:~3,2%-%date:~0,2%
set backuptime=%time:~0,2%%time:~3,2%%time:~6,2%
set timestamp=%backupdate%-%backuptime: =0%
set options=--progress --onedrive-no-versions
set filter=--exclude .*/ --exclude ~*
set log=--log-file "%APPDATA%\rclone\backup.log"
set settings=%options% %filter% %log%

echo Find local drive
for /f %%d in ('wmic volume get driveletter^, label ^| find "%drivelabel%"') do set local=%%d
if "%local%"=="" (exit /b) else set destination=%local%%path%

echo Back up Desktop files
rclone sync %settings% "%USERPROFILE%\Desktop" "%destination%\Desktop\Letztes" --backup-dir "%destination%\Desktop\%timestamp%"

echo Back up Documents files
rclone sync %settings% "%USERPROFILE%\Documents" "%destination%\Dokumente\Letztes" --backup-dir "%destination%\Dokumente\%timestamp%"

echo Back up Pictures files
rclone sync %settings% "%USERPROFILE%\Pictures" "%destination%\Bilder\Letztes" --backup-dir "%destination%\Bilder\%timestamp%"

echo Back up Google Drive files
rclone sync %settings% "G:\Meine Ablage" "%destination%\Meine Ablage\Letztes" --backup-dir "%destination%\Meine Ablage\%timestamp%"
