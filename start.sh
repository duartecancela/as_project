# Shows the menu to the user
read -p "
<< Server Configuration v1.0 >>

Please select an option:

[1] - Create a domain forward master zone.
[2] - Configuration and use of the SAMBA service.
[3] - Virtual Hosts automatically creation and configuration.
[4] - Create type A and MX records in the DNS server automatically
[5] - Create reverse zones.
[6] - Delete Master Forward Zones, Virtual Hosts and Reverse Zones.
[7] - NFS service configuration.
[8] - Create critical system files and settings backup.
[9] - Create RAID 1+1 hotspare storage.
" menu_option

if [ $menu_option = "1" ]; then
	./script1.sh
fi

if [ $menu_option = "2" ]; then
	./script2.sh
fi

if [ $menu_option = "3" ]; then
	./script3.sh
fi

if [ $menu_option = "4" ]; then
	./script4.sh
fi

if [ $menu_option = "5" ]; then
	./script5.sh
fi

if [ $menu_option = "6" ]; then
	./script6.sh
fi

if [ $menu_option = "7" ]; then
	./script7.sh
fi

if [ $menu_option = "8" ]; then
	./script9.sh
fi


if [ $menu_option = "9" ]; then
	./script10.sh
fi







