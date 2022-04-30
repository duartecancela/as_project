#!/bin/bash

echo "Start Script 5"

# list existing master zones
echo "-- Exisiting master reverse zones --"
ls /var/named/*.in-addr.arpa.hosts
echo " "

# ask user for IP number and save it in 4 variables
read -p "Insert a IP number for reverse master zone: " ip_number
IFS=. read ip1 ip2 ip3 ip4 <<< "$ip_number"

# verify if reverse master zone exist
FILE=/var/named/${ip3}.${ip2}.${ip1}.in-addr.arpa.hosts
if test -f "$FILE"
then
    echo "$FILE exists."
else
	
	# ask user for domain name
	read -p "Insert the domain name for reverse master zone: " domain_name

	# add a reverse master zone to named.conf beafore a specific marker
	master_zone="zone \"${ip3}.${ip2}.${ip1}.in-addr.arpa\" IN {\n       type master;\n       file \"/var/named/${ip3}.${ip2}.${ip1}.in-addr.arpa.hosts\";\n};\n "
	marker="zone \".\""
	sed -i "/^$marker/i $master_zone" /etc/named.conf

	# write a arpa.host file
echo "\$ttl 38400
@	IN	SOA	dns.estig.pt. mail.$domain_name. (
			1165192116
			10800
			3600
			604800
			38400 )
	IN      NS	dns.estig.pt.
${ip4}	IN      PTR	www.$domain_name.
${ip4}	IN	PTR	ftp.$domain_name." > /var/named/${ip3}.${ip2}.${ip1}.in-addr.arpa.hosts

	# restart DNS 
	systemctl restart named

fi

echo "Finish Script 5"
