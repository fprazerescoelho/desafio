#!/usr/bin/env bash

# Atualiza SO e pacotes
sudo yum update -y

# Instalacao de Apache+PHP+Mysql (Em docker no final do arquivo)
#sudo yum -y install httpd mariadb mariadb-server php php-common php-mysql php-gd php-xml php-mbstring php-mcrypt php-xmlrpc unzip wget
#sudo systemctl enable httpd
#sudo systemctl enable mariadb

# Instalacao ldap
sudo yum -y install openldap compat-openldap openldap-clients openldap-servers openldap-servers-sql openldap-devel
sudo systemctl enable slapd

# Instalacao PHPLdapAdmin (Em docker no final do arquivo)
#sudo yum -y install epel-release
#sudo yum -y install php-ldap php-mbstring php-pear php-xml phpldapadmin

# Instalacao Zabbix
sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
sudo yum clean all
sudo yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent

# Habilita regras de firewall

sudo firewall-cmd --permanent --zone=public --add-port=22/tcp
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --permanent --zone=public --add-port=81/tcp
sudo firewall-cmd --permanent --zone=public --add-port=443/tcp
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 1 -p tcp -m tcp --dport=80 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 1 -p tcp -m tcp --dport=443 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 1 -p tcp -m tcp --dport 53 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 1 -p udp --dport 53 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 2 -j ACCEPT
sudo firewall-cmd --reload

# Instala port-knocking

sudo wget http://li.nux.ro/download/nux/dextop/el7/x86_64//knock-server-0.5-7.el7.nux.x86_64.rpm
sudo yum -y install knock-server-0.5-7.el7.nux.x86_64.rpm
sudo systemctl enable knockd

# Instala docker

sudo yum -y install docker
sudo systemctl enable docker

# Instala git

sudo yum -y install git

# Instala Wordpress em docker

sudo docker run --name wordpressdb -e MYSQL_ROOT_PASSWORD=desafio -d mysql:5.7
sudo docker pull wordpress
sudo docker run -e WORDPRESS_DB_PASSWORD=desafio --name wordpress --link wordpressdb:mysql -p 80:80 -v "$PWD/html/WP":/var/www/html -d wordpress

# Instala Zabbix em docker
sudo mkdir -p /docker/mysql/zabbix/data
docker run --name zabbix-java-gateway -t \
      -d zabbix/zabbix-java-gateway:latest
docker run --name zabbix-server-mysql -t \
      -e DB_SERVER_HOST="172.17.0.2" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="desafio" \
      -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
      --link wordpressdb:mysql \
      --link zabbix-java-gateway:zabbix-java-gateway \
      -p 10051:10051 \
      -d zabbix/zabbix-server-mysql:latest
docker run --name zabbix-web-nginx-mysql -t \
      -e DB_SERVER_HOST="172.17.0.2" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="desafio" \
      --link wordpressdb:mysql \
      --link zabbix-server-mysql:zabbix-server \
	  -p 81:80 \
      -d zabbix/zabbix-web-nginx-mysql:latest
	  
	# Instala PHPLDAPAdmin em docker  
docker run -p 443:443 \
        --env PHPLDAPADMIN_LDAP_HOSTS=172.17.0.1 \
        --detach osixia/phpldapadmin:0.9.0
