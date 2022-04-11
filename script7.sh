#!/bin/bash

echo "Start Script 7"


#sk user for a directory name inside /shared folder
read -p "Insert a directory name to share inside /storage: " shared_directory

echo "/storage/${shared_directory} 192.168.1.0/24(rw,hide,sync)" >> /etc/exports

echo "Please execute this comand in your client machine inside the same network:

mount -t nfs [server_ip]:/storage/${shared_directory} /[your_folder_name]
"

# restart NFS service
systemctl restart nfs

echo "Finish Script 7"
