#!/bin/bash

echo "Start Script 2"

# Shows the menu to the user
read -p "Select the samba Configuration:
[1] - Install
[2] - Create
[3] - Delete
[4] - Change
[5] - Deactivate
[6] - Map folder from Windows
" choice_number


# Menu
# Install
if [ $choice_number = "1" ]; then
	# Service installation
	yum install samba4 -y
	systemctl start smb
	systemctl enable smb
fi

# Create
if [ $choice_number = "2" ]; then
	# Asks the name of the user and adds samba pass
	read -p "Insert the name of the samba user: " user_name
	smbpasswd -a $user_name


	# Asks user for the name of the folder
	read -p "Insert the name of the directory: " folder_name

	# Creates the folder
	mkdir -p /$folder_name


	# Edit file "/etc/samba/smb.conf"
	echo -n "
[${folder_name}]
	path = /${folder_name}
	browseable = yes
	public = yes
	writeable = yes" >> /etc/samba/smb.conf

# restart services
systemctl restart smb
systemctl restart nmb

fi

# Delete
if [ $choice_number = "3" ]; then
	# Asks user for the name of the folder to delete
	read -p "***DELETE*** Insert the name of the directory: " folder_name

	# Deletes the folder in the "smb.conf" file
	sed -i "/$folder_name/,+4 d" /etc/samba/smb.conf
	rm -rf /$folder_name
fi

# Change
if [ $choice_number = "4" ]; then
	# Asks the user for the name of the folder to modify
	read -p "***MODIFY*** Insert the name of the directory: " folder_name
	
	# Asks the user for the new name
	read -p "Insert the new name: " new_folder_name
	
	# Modifies the name of the file in the "smb.conf" and the name of the folder
	sed -i "s/$folder_name/$new_folder_name/g" /etc/samba/smb.conf

	# Changes the name of the directory
	mv /$folder_name /$new_folder_name
fi

# Deactivate
if [ $choice_number = "5" ]; then
	# Asks user for the name of the folder to deactivate
	read -p "***DEACTIVATE*** Insert the name of the directory: " folder_name
	
	# Disables the directory in the "smb.conf" file
	sed -i "/$folder_name/,+4 s/^/#/" /etc/samba/smb.conf

fi

# Map folders from windows
if [ $choice_number = "6" ]; then
	# Install the service
	yum install cifs-utils -y
	
	# Asks the user the windows IP and the name of the folder
	read -p "Insert the IP of the windows machine: " ip_windows
	read -p "Insert the name of the windows folder: " folder_windows
	read -p "Insert the name of the new shared folder: " folder_server
	
	#echo "*{$ip_windows}**{$folder_windows}**{$folder_server}"

	# Creates new folder in the server
	mkdir -p /$folder_server

	# Asks for the name of the windows user
	read -p "Insert the name of the windows user: " user_windows
	
	# mount
	mount -t cifs -o username=$user_windows //$ip_windows/$folder_windows /$folder_server
fi


# Restart service
systemctl restart smb

echo "Finish Script 2"
