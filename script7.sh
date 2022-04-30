#!/bin/bash

echo "Start Script 7"

# NFS menu options
read -p "NFS Menu options - Please choose a number? :
[1] - Create
[2] - Edit
[3] - Delete
[4] - Disable
[5] - View exports file
" menu_option


if [ $menu_option = "1" ]; then
	# ask user for a directory name inside /shared folder and network ip
	read -p "Insert a directory name to share inside /storage: " shared_directory
	read -p "Insert the network ip: " network_ip

	# create shared directory with permissions
	mkdir -p /storage/$shared_directory
	chmod 777 /storage -R

	# write in /etc/expots 
	echo "/storage/${shared_directory} ${network_ip}/24(rw,hide,sync)" >> /etc/exports

	echo "Please execute this comand in your client machine inside the same network:

	yum install nfs-utils
	mount -t nfs [server_ip]:/storage/${shared_directory} /[your_folder_name]
	systemctl start nfs
	"

	# restart NFS service
	systemctl restart nfs
fi

if [ $menu_option = "2" ]; then

	# ask user which shared directory want to edit and give a new name
	read -p "Please insert the diretory name that you want to edit? " old_directory
	read -p "Please insert the new name for the direcory? " new_directory
	read -p "Insert the network ip: " network_ip

	# edit shared diretory (delete old, write new and update directory)
	sed -i "/\/$old_directory/ d" /etc/exports
	echo "/storage/${new_directory} ${network_ip}/24(rw,hide,sync)" >> /etc/exports
	mv /storage/$old_directory /storage/$new_directory 	

	# restart NFS service
	systemctl restart nfs
fi

if [ $menu_option = "3" ]; then
	# ask user which shared directory want to delete
	read -p "Please insert the diretory name that you want to delete? " delete_directory
	
	# delete shared diretory
	sed -i "/\/$delete_directory/ d" /etc/exports
	rm -rf /storage/$delete_directory
	
	# restart NFS service
	systemctl restart nfs
fi

if [ $menu_option = "4" ]; then

	# ask user which shared directory want to disable
	read -p "Please insert the diretory name that you want to disable? " disable_directory
	
	# disable shared diretory
	sed -i  "/$disable_directory /s/^/#/" /etc/exports	

	# restart NFS service
	systemctl restart nfs
fi

if [ $menu_option = "5" ]; then
	cat /etc/exports
fi

echo "Finish Script 7"
