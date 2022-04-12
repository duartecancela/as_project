#!/bin/bash

echo "Start Script 7"

# NFS menu options
read -p "NFS Menu options- Please choose a number? :
1 - Create
2 - Delete
3 - Disable
" menu_option


if [ $menu_option = "1" ]; then
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
fi


if [ $menu_option = "2" ]; then
	# ask user which shared directory want to delete
	read -p "Please insert the diretory name that you want to delete? " delete_directory
	
	# delete shared diretory
	sed -i "/\/$delete_directory/ d" /etc/exports
	rm -rf /storage/$delete_directory
	
	# restart NFS service
	systemctl restart nfs
fi

if [ $menu_option = "3" ]; then

	# ask user which shared directory want to disable
	read -p "Please insert the diretory name that you want to disable? " disable_directory
	
	# disable shared diretory
	sed -i  "/$disable_directory /s/^/#/" /etc/exports	

	# restart NFS service
	systemctl restart nfs
fi

echo "Finish Script 7"
