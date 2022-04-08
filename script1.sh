#!/bin/bash

echo Hello World

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
read -p "Insert a domain name: " domain_name

# test
