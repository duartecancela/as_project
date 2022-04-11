# as_project
System Administration project  

# install vim + plugins
yum install vim -y  
vi ~/.vimrc (set number)   
yum install zip unzip -y  
yum install wget -y  
https://www.thegeekstuff.com/2009/02/make-vim-as-your-bash-ide-using-bash-support-plugin/  



# git user config
yum install git -y  
git config --global user.name "Duarte Cancela"  
git config --global user.email duartecancela@gmail.com  
ssh-keygen  
cd .ssh  
cat id_rsa.pub (copiar e colar no github)  
ssh-add ~/.ssh/id_rsa  

# initialize project
git init  
git add README.md  
git add  
git commit -m "first commit"  
git branch -M main  
git remote add origin git@github.com:duartecancela/as_project.git  
git push -u origin main  

# server global config
vi /etc/selinux/config (SELINUX=disabled)  
yum install net-tools -y (ferramentas de rede)  
yum install httpd -y (servidor apache)  
yum install nfs-utils (nfs service)

# DNS server
yum install bind* -y (servidor dns)  

vi /etc/resolv.conf (

nameserver 192.168.1.164

)

vi /etc/named.conf (

listen-on port 53 { 127.0.0.1; any; };
allow-query     { localhost; any;};

zone "test.com" IN {
		type master;
		file "/var/named/test.com.hosts";
};

)

vi /var/named/test.com.hosts (

$ttl 38400
@	IN	SOA	dns.estig.pt. mail.as.com. (
			1165190726 ; serial
			10800 ; refresh
			3600 ; retry
			604800 ; expire
			38400 ; minimum
			)
	IN	NS	server.estig.pt.
	IN	A	10.2.0.1
www	IN	A	10.2.0.2
ftp	IN	A 	10.2.0.2

)

systemctl start named  

nslookup test.com 192.168.0.22  
nslookup -query=mx test.com 192.168.0.22  
nslookup -type=any test.com 192.168.0.22  

# NIS
--server and client  
yum install nfs-utils  
--server  
mkdir /storage/home  
vi /etc/exports ( /storage/home 127.27.10.0/24(rw,hide,sync) )  
--client  
df -h (lista os mount do file system)  
cd /  
mkdir /storage/home  
chmod -R 777 /storage/home/  
mount -t nfs 192.13.10.1:/storage/home /storage/home  




