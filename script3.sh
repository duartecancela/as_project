#!/bin/bash

echo "Start Script 3"

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
<VirtualHost *:80>
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

# restrat httpd service
systemctl restart httpd

echo "Finish Script 3"
