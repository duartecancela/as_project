#!/bin/bash

echo "Start Script 9"

# Create a incremental backup from important server folders and config files
rsync -av --link-dest /backups/server_backup {/root,/etc/exports,/etc/passwd,/etc/shadow,/etc/group,/etc/named,/var/named,/etc/httpd/conf*,/var/www/,/home} /backups/server_backup

# Compress backup folder with current date
tar -zcvf /backups/server_backup/backup_`date +%d-%m-%Y`.tar.gz /backups/server_backup

echo "Finish Script 9"
