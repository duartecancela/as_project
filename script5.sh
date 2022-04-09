#!/bin/bash

echo "Start Script 5"

# ask user for IP number and save it in 4 variables
read -p "Insert a IP number: " ip_number
IFS=. read ip1 ip2 ip3 ip4 <<< "$ip_number"

# ask user for domain name
read -p "Insert the domain name: " domain_name

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
110	IN      PTR	www.$domain_name.
111	IN	PTR	ftp.$domain_name." > /var/named/${ip3}.${ip2}.${ip1}.in-addr.arpa.hosts

# restart DNS 
systemctl restart named

echo "Finish Script 5"
