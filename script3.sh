#!/bin/bash

echo "Start Script 3"

# initialize variables
ip=$(hostname -I)
server_ip=$(echo "$ip" | sed 's/ //g') 
file_named_conf="/etc/named.conf"

# ask user for a domain name
read -p "Insert a domain name to create a Virtual Host: " domain_name

# create directories, index.html file and and change permissions
mkdir -p /var/www/$domain_name
echo "
<h3>Welcome to<h3>
<br>
<h1>${domain_name}<h1>
" > /var/www/${domain_name}/index.html
chown -R $USER:$USER /var/www/$domain_name
sudo chmod -R 755 /var/www

# create a Virtual Host configuration file
echo "
<VirtualHost ${server_ip}:80>
    ServerName www.${domain_name}
    ServerAlias ${domain_name}
    DocumentRoot /var/www/${domain_name}
	<Directory "/var/www/${domain_name}">
		Options Indexes FollowSymLinks
		AllowOverride All
		Order allow,deny
		Allow from all
		Require method GET POST OPTIONS
	</Directory>
</VirtualHost>
" > /etc/httpd/conf.d/$domain_name.conf

# initialize variables
file_named_conf="/etc/named.conf"
listen_old="listen-on port 53 { 127.0.0.1; };"
listen_new="listen-on port 53 { 127.0.0.1; any; };"
allow_old="allow-query     { localhost; };"
allow_new="allow-query    { localhost; any; };"

# change lines in named.conf
sed -i "s/$listen_old/$listen_new/" $file_named_conf
sed -i "s/$allow_old/$allow_new/" $file_named_conf

# add a master zone to named.conf beafore a specific marker
master_zone="zone \"$domain_name\" IN {\n       type master;\n       file \"/var/named/$domain_name.hosts\";\n};\n "
marker="zone \".\""
sed -i "/^$marker/i $master_zone" $file_named_conf

# add DNS hosts file
echo -n  "\$ttl 38400
@	IN	SOA	dns.serverasproject.dev. mail.serverasproject.dev. (
			1165190726 ; serial
			10800 ; refresh
			3600 ; retry
			604800 ; expire
			38400 ; minimum
)
	IN	NS	serverasproject.dev.
	IN	A	${server_ip}
www	IN	A	${server_ip}" > /var/named/$domain_name.hosts

# restart DNS and apache
systemctl restart named
systemctl restart httpd

echo "Finish Script 3"
