---
title: seafile安装
date: 2024-01-17 10:35:19
updated: 2024-01-17 16:50:30
tags:
  - seafile
categories:
  - 经验
---

# 参考资料

[部署 Seafile 服务器 - seafile-manual-cn](https://cloud.seafile.com/published/seafile-manual-cn/deploy/using_mysql.md#user-content-安装)

[seafile云盘的安装-（保姆级教程）_seafile安装-CSDN博客](https://blog.csdn.net/qq_50660509/article/details/129706671)

[【debug】seafile创建管理员账户失败_error happened during creating seafile admin.-CSDN博客](https://blog.csdn.net/u013345641/article/details/100868871)

[ERROR 1396 (HY000): Operation ALTER USER failed for ‘root‘@‘localhost‘-CSDN博客](https://blog.csdn.net/q258523454/article/details/84555847)

[ubuntu 22.04安装mysql 8.0与避坑指南_ubuntu22.04安装mysql-CSDN博客](https://blog.csdn.net/weixin_39636364/article/details/131234559)

[如何在Ubuntu 22.04安装MySQL | myfreax](https://www.myfreax.com/how-to-install-mysql-on-ubuntu-22-04/#:~:text=本教程介绍了如何在Ubuntu 22.04上安装和配置MySQL。 包括 使用apt命令 安装MySQL 8.0服务器，初始化MySQL并配置MySQL的验证方式，以root用户身份登录MySQL，解决MySQL root用户权限问题。 在撰写本文时，Ubuntu,sudo apt install mysql-server 安装MySQL服务器。 安装完成后，MySQL服务将作为 systemd服务 自动启动。)

# 环境

系统使用 ubuntu 22.04

安装版本选择 [11.0.3 64bit](https://seafile-downloads.oss-cn-shanghai.aliyuncs.com/seafile-server_11.0.3_x86-64.tar.gz)

需要提前安装如下环境

```shell
# Ubuntu 22.04 (almost the same for Ubuntu 20.04 and Debian 11, Debian 10)
sudo apt-get update
sudo apt-get install -y python3 python3-setuptools python3-pip libmysqlclient-dev   ldap-utils libldap2-dev
sudo apt-get install -y memcached libmemcached-dev

sudo pip3 install --timeout=3600 django==3.2.* future==0.18.* mysqlclient==2.1.* pymysql pillow==10.0.* pylibmc captcha==0.4 markupsafe==2.0.1 jinja2 sqlalchemy==2.0.18 psd-tools django-pylibmc django_simple_captcha==0.5.* djangosaml2==1.5.* pysaml2==7.2.* pycryptodome==3.16.* cffi==1.15.1 python-ldap==3.4.3 lxml
```

此外需要手动安装 mysql

# 安装

在官网下载seafile的压缩包，将其按照官网建议的目录结构解压

```
/opt/seafile
├── installed
│   └── seafile-server_7.0.0_x86-64.tar.gz
└── seafile-server-7.0.0
    ├── reset-admin.sh
    ├── runtime
    ├── seafile
    ├── seafile.sh
    ├── seahub
    ├── seahub.sh
    ├── setup-seafile-mysql.sh
    └── upgrade
```

进入seafile-server-7.0.0目录，执行setup-seafile-mysql.sh

按照提示逐个输入系统信息

```
What is the name of the server? It will be displayed on the client.
3 - 15 letters or digits
[ server name ] SeafileTest

What is the ip or domain of the server?
For example: www.mycompany.com, 192.168.1.101
[ This server's ip or domain ] 填写服务器ip地址或者域名

Which port do you want to use for the seafile fileserver?
[ default "8082" ] 

-------------------------------------------------------
Please choose a way to initialize seafile databases:
-------------------------------------------------------

[1] Create new ccnet/seafile/seahub databases
[2] Use existing ccnet/seafile/seahub databases

[ 1 or 2 ] 1

What is the host of mysql server?
[ default "localhost" ] 

What is the port of mysql server?
[ default "3306" ] 

What is the password of the mysql root user?
[ root password ] 

verifying password of user root ...  done

Enter the name for mysql user of seafile. It would be created if not exists.
[ default "seafile" ] 

Enter the password for mysql user "seafile":
[ password for seafile ] 

verifying password of user seafile ...  done

Enter the database name for ccnet-server:
[ default "ccnet-db" ] 

Enter the database name for seafile-server:
[ default "seafile-db" ] 

Enter the database name for seahub:
[ default "seahub-db" ] 

---------------------------------
This is your configuration
---------------------------------

    server name:            SeafileTest
    server ip/domain:       **********

    seafile data dir:       /opt/seafile/seafile-data
    fileserver port:        8082

    database:               create new
    ccnet database:         ccnet-db
    seafile database:       seafile-db
    seahub database:        seahub-db
    database user:          seafile



---------------------------------
Press ENTER to continue, or Ctrl-C to abort
---------------------------------
Generating ccnet configuration ...

Generating seafile configuration ...

done
Generating seahub configuration ...

----------------------------------------
Now creating ccnet database tables ...

----------------------------------------
----------------------------------------
Now creating seafile database tables ...

----------------------------------------
----------------------------------------
Now creating seahub database tables ...

----------------------------------------

creating seafile-server-latest symbolic link ...  done

-----------------------------------------------------------------
Your seafile server configuration has been finished successfully.
-----------------------------------------------------------------

run seafile server:     ./seafile.sh { start | stop | restart }
run seahub  server:     ./seahub.sh  { start <port> | stop | restart <port> }

-----------------------------------------------------------------
If you are behind a firewall, remember to allow input/output of these tcp ports:
-----------------------------------------------------------------

port of seafile fileserver:   8082
port of seahub:               8000

When problems occur, Refer to

        https://download.seafile.com/published/seafile-manual/home.md

for information.

```

# 设置mysql中seafile用户的权限

root用户登录mysql，执行

```sql
ALTER USER 'seafile'@'127.0.0.1' IDENTIFIED BY 'your_password' PASSWORD EXPIRE NEVER;
ALTER USER 'seafile'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'your_password';

FLUSH PRIVILEGES;
```

# 修改seahub绑定地址

vim conf/gunicorn.fong.py

修改bind一行

```py
bind = "0.0.0.0:8000"
```

# 启停服务

进入seafile服务目录

```shell
./seahub.sh start|stop
./seafile.sh start|stop
```

在初次启动seahub时会要求指定管理员用户与密码

# 设置文件服务地址

浏览器访问服务器地址:8000，使用管理员账户登录，点击头像，选择系统管理，点击设置，在FILE_SERVER_ROOT一栏填写文件服务地址，通常为 服务器地址:8082