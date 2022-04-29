#!/bin/bash

# 
# Criar 3 discos no VMBox com tamanho 5GB cada VDI
# Instalar pacote mdadm
# 
# Verificar discos
# -> fdisk -l
#
# Criar raid
# 2 dicos para RAID 1 + 1 dicos hotspare
# 
# Definir tipo de ficheiro
# -> mkfs.xfs /dev/md0
#
# Criar pasta para montar
# -> mkdir /folder 
#
# Fazer o mount
# -> mount /dev/md0 /folder
#
# verificação do mount:
# mdadm --detail /dev/md0
#
#

echo "Start Script 10"

# Shows the menu to the user
read -p "Select the samba Configuration:
[1] - Install
[2] - Create
" choice_number

# Menu
# Install
if [ $choice_number = "1" ]; then
	# Service installation
	yum install mdadm -y
fi

# Create
if [ $choice_number = "2" ]; then
	# Asks the user for the name of the directory to mount
	read -p "Insert the name of the directory to mount: " raid_folder
	
	# Service create
	mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc --spare-devices=1 /dev/sdd
	
	# define the type of file system
	mkfs.xfs /dev/md0

	# create a directory to mount
	mkdir -p /$raid_folder

	# mount to the folder
	mount /dev/md0 /$raid_folder
fi
