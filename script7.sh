#!/bin/bash

echo "Start Script 7"


# ask user for a directory name inside /shared folder
read -p "Insert a directory name to share inside /storage: " shared_directory

# create shared directory with permissions
mkdir -p /storage/$shared_directory
chmod 777 /storage -R

# write in /etc/expots 
echo "/storage/${shared_directory} 192.168.1.0/24(rw,hide,sync)" >> /etc/exports

echo "Please execute this comand in your client machine inside the same network:

yum install nfs-utils
mount -t nfs [server_ip]:/storage/${shared_directory} /[your_folder_name]
systemctl start nfs
"

# restart NFS service
systemctl restart nfs

echo "Finish Script 7"
