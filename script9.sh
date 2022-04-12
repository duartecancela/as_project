#!/bin/bash

echo "Start Script 9"

# Create a incremental backup from important server folders and config files
rsync -av --link-dest /backups/server_backup {/root,/etc/exports,/etc/passwd,/etc/shadow,/etc/group} /backups/server_backup

echo "Finish Script 9"
