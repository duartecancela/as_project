#!/bin/bash

echo "Start Script 1"

# initialize variables
file_named_conf="/etc/named.conf"
listen_old="listen-on port 53 { 127.0.0.1; };"
listen_new="listen-on port 53 { 127.0.0.1; any; };"
allow_old="allow-query     { localhost; };"
allow_new="allow-query    { localhost; any; };"

# change lines in named.conf
sed -i "s/$listen_old/$listen_new/" $file_named_conf
sed -i "s/$allow_old/$allow_new/" $file_named_conf

# ask user for domain name
read -p "Insert a domain name to create a master zone with a record type A: " domain_name
read -p "Insert a IP for the master zone record type A: " master_zone_ip

# add a master zone to named.conf beafore a specific marker
master_zone="zone \"$domain_name\" IN {\n       type master;\n       file \"/var/named/$domain_name.hosts\";\n};\n "
marker="zone \".\""
sed -i "/^$marker/i $master_zone" $file_named_conf

echo -n  "\$ttl 38400
@	IN	SOA	dns.serverasproject.dev. mail.serverasproject.dev. (
			1165190726 ; serial
			10800 ; refresh
			3600 ; retry
			604800 ; expire
			38400 ; minimum
)
	IN	NS	serverasproject.dev.
	IN	A	${master_zone_ip}
www	IN	A	${master_zone_ip}" > /var/named/$domain_name.hosts

# restart DNS 
systemctl restart named

echo "Finish Script 1"

