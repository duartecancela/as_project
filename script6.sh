#!/bin/bash

echo "Start Script 6"

read -p "Please choose one of this options?
1 - Delete a Forward Master Zone
2 - Delete a Reverse Master zone 
3 - Delete a Virtual Host
 " option

if [ $option = "1" ]; then
        read -p "Please, insert the name of Forward Master Zone that you want delete? " for_master_zone

	# delete master zone in named.conf and remove file in /var/named
        sed -i "/zone \"$for_master_zone\" IN {/,+3 d" /etc/named.conf
	rm -f /var/named/*$for_master_zone*

        systemctl restart named
fi

if [ $option = "2" ]; then
        read -p "Please, insert the IP of Reverse Master Zone that you want delete? " rev_master_ip

	# delete reverse master zone in named.conf and remove file in /var/named
	IFS=. read ip1 ip2 ip3 ip4 <<< "$rev_master_ip"
	pattern="${ip3}.${ip2}.${ip1}"
        sed -i "/zone \"${pattern}.in-addr.arpa\" IN {/,+3 d" /etc/named.conf
	rm -f /var/named/*${ip3}.${ip2}.${ip1}*

        systemctl restart named
fi

if [ $option = "3" ]; then
        read -p "Please, insert the Virtual Host domain name that you want delete? " vh_name

	# delete httpd virtual host conf file and remove site diretory
	rm -f /etc/httpd/conf.d/*$vh_name*
	rm -r -f /var/www/$vh_name

	# delete master zone in named.conf and remove file in /var/named
        sed -i "/zone \"$vh_name\" IN {/,+3 d" /etc/named.conf
	rm -f /var/named/*$vh_name*

        # restart DNS and apache
	systemctl restart named	
        systemctl restart httpd
fi

echo "Finish Script 6"
