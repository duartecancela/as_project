#!/bin/bash

echo "Start Script 4"

# ask user for domain name and DNS record type
read -p "Insert the domain name to insert the new record type? " domain_name
read -p "Insert the DNS record type? A or MX :  " dns_record_type

if [ $dns_record_type = "MX" -o $dns_record_type = "mx" ]; then

	# delete old MX record
        sed -i "/	IN	MX/ d" /var/named/$domain_name.hosts
	# add new MX record
        echo "	IN	MX	10	mail.$domain_name." >> /var/named/$domain_name.hosts
fi

if [ $dns_record_type = "A" -o $dns_record_type = "a" ]; then
        read -p "Insert the DNS record type name?  www ou ftp : " dns_record_name
		
	# delete old A record
        sed -i "/^$dns_record_name	IN	A/ d" /var/named/$domain_name.hosts

        if [ $dns_record_name = "www" ]; then
		
        	read -p "Insert the IP for record type name www? : " www_ip
		
		# write new DNS record type name for www
                echo "$dns_record_name	IN	A	${www_ip}" >>  /var/named/$domain_name.hosts
        fi

        if [ $dns_record_name = "ftp" ]; then
		
        	read -p "Insert the IP for record type name ftp? : " ftp_ip
		
		# write new DNS record type name for ftp
                echo "$dns_record_name	IN	A	${ftp_ip}" >> /var/named/$domain_name.hosts
        fi
fi

# restart DNS 
systemctl restart named

echo "Finish Script 4"
