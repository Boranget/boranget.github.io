---
title: MySQL安装与配置
date: 2023-05-27 16:50:30
updated: 2023-01-22 16:50:30
tags:
  - mysql
categories:
  - 经验
---

# windows

## 卸载

打开安装器，点击右侧的remove

![image-20230527205355781](MySQL安装与配置/image-20230527205355781.png)

选中要卸载的组件next > execute

若卸载失败， 可以打开Windows 应用管理卸载

## 下载

在mysql官网下载安装器[MySQL :: Download MySQL Installer](https://dev.mysql.com/downloads/windows/installer/)：msi结尾文件

## 安装

1. choosing a setup type 

   其中：

   - developer default  会安装 server，connectors，workbench，文档，实例
   - server only 只安装server
   - client only 只安装 client
   - full 安装所有
   - custom 自定义

   这里选择 custom 自定义

2. select products

   选中左边的组件，点击中间的按钮可以添加到右边进行安装，这里我只选择了server 和 shell。

   点击右侧框中的具体组件，下方会出现蓝色字体 advanced option，点击设置安装位置

   这里分别制定为

   server 

   ​	D:\tools\mysql\mysql8\server

   ​	D:\tools\mysql\mysql8\server\data

   shell

   ​	D:\tools\mysql\mysql8\shell

3. Installation

   点击execute，会显示正在安装，当状态为complete即安装结束

## 配置

安装完成后，安装器会自动跳到配置界面

type and networking 这个页面配置端口和内存占用等，默认即可，可以勾选最下面的 show advanced and logging option next

authentication method 选择下面5.x的模式 next

accounts and roles 填写root密码 next

windows service 默认 next

server file permission 默认 next

logging options 这里的日志会存放到我们上面指定的server-data目录下 默认 next

advanced options 默认 next

apply configuration execute

finish

最后将 D:\tools\mysql\mysql8\server\bin 目录配置到环境变量的path中

## 测试连接

打开一个新的cmd窗口， 输入mysql -uroot -p 回车，输入密码，连接成功即可

# ubuntu

```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl status mysql
```

MySQL 8.0上，对root用户使用`auth_socket`插件进行身份验证。`auth_socket`插件仅对从`localhost`连接到Unix socket文件用户进行身份验证。这意味着无法通过提供密码来以root用户连接到MySQL服务器。但可以通过命令`sudo mysql`连接到MySQL服务器。

开启root用户的密码登录，并允许从其他ip登录

```bash
# 修改host为%，
use mysql
select user,host from user;
update user set host='%' where user='root' and host='localhost';
# 开启root用户的密码登录
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的密码';
# 刷新权限
FLUSH PRIVILEGES;
```

修改配置文件开启远程登录`/etc/mysql/mysql.conf.d/mysqld.cnf`

```properties
# 注释改行
#bind-address = 127.0.0.1
```

重启mysql

```bash
systemctl status mysql
systemctl stop mysql
systemctl start mysql
```

# navicat

## 10061错误

查看是否没开放远程登录的权限