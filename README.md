# Como instalar

Baixar e instalar o Virtualbox e o Vagrant

Baixar o arquivo Vagrantfile e executar os comandos abaixo:

vagrant init fprazerescoelho/desafio \
  --box-version 1
vagrant up

# Vagrant

O ambiente foi criado a partir de um box Centos7, onde o mesmo foi customizado e gerado um novo arquivo box.

As aplicações estão rodando a partir de instâncias do docker, sendo possível acessa-las conforme abaixo:

# Zabbix

http://localhost:8081

![zabbix1](https://user-images.githubusercontent.com/56374525/66694619-cae31600-ec8b-11e9-81e2-4d3ee76c6014.PNG)
![zabbix2](https://user-images.githubusercontent.com/56374525/66694620-ccacd980-ec8b-11e9-86f0-59bc0951cdd3.PNG)

# Wordpress

http://localhost:8080

![wordpress](https://user-images.githubusercontent.com/56374525/66694611-a850fd00-ec8b-11e9-99e2-08b6c0773d44.PNG)

# PHPLdapAdmin

https://localhost:4443

![phpldapadmin](https://user-images.githubusercontent.com/56374525/66694621-cf0f3380-ec8b-11e9-82de-d60a18a47bd5.PNG)
