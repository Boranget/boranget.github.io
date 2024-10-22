---
title: sftp服务搭建以及连接
date: 2024-10-11 10:35:19
updated: 2024-10-11 10:35:19
tags:
  - sftp
categories:
  - experience
---

# 参考资料

[SFTP服务器的搭建与使用_sftp服务器搭建-CSDN博客](https://blog.csdn.net/qq_35623011/article/details/85003109)

[SFTP搭建@windows using freeSHHd&FileZilla - 零一两二三 - 博客园 (cnblogs.com)](https://www.cnblogs.com/wzs2016/p/6394990.html#:~:text=重点讲一下认证吧， freesshd支持两种方式的认证，password和public key，你可以使用其中的任意一种，也可以要求客户端同时进行两种认证，也就是说，如果两个都设置为required，客户端要想连入服务器，得同时要有密码和public key。,都设为allowed，任意一种认证都可以进入服务器。 第一种认证简单，只要在客户端输入用户名和密码就可以，第二种就需要一对密钥了（公钥和私钥，私钥客户端持有，公钥要放到服务器上，图中的public key folder就是存放各个客户端私钥对应的公钥的）.)

# 搭建sftp服务

下载freeSSHd安装，另一款常用的ftp工具filezilla的服务端并不提供sftp的功能（只有ftp和ftps）。

## 安装

1. 双击安装包后正常安装即可

2. 创建私钥：安装的最后会引导创建私钥
3. 设置为系统服务

## 配置

- 启动时会连接官网，但是官网已经挂了，所以直接ok

- 可以点击ssh标签页修改端口等信息
- 选择用户标签页新增用户，可选择密码模式、公钥模式

## sftp的认证方式

### 密码模式

给用户设置密码即可

### 公钥模式

生成一对公私钥，可使用xftp自带的工具生成，或者使用ssh-keygen。需要生成为ssh-rsa格式的密钥对，私钥客户端连接时使用，公钥存储在服务端authentication中的public key folder，**注意公钥命名必须与该公钥对应的用户名相同且无后缀。**

对于较新的sftp服务器，对安全要求比较高的，可能会需要生成比如rsa-sha2-256的密钥，可用如下方式生成：

```
 ssh-keygen -t rsa-sha2-256 -b 2048
```

# JSCH0.2.*连接Freesshd

[jenkins配置ssh的时候测试连接出现Algorithm negotiation fail_com.jcraft.jsch.jschalgonegofailexception: algorit-CSDN博客](https://blog.csdn.net/t0404/article/details/136206576)

jsch的版本从0.1.x升级到0.2.x的时候，禁用了ssh-rsa,ssh-dss算法，需要进行如下配置

```java
JSch.setConfig("server_host_key", JSch.getConfig("server_host_key") + ",ssh-rsa,ssh-dss");
            JSch.setConfig("PubkeyAcceptedAlgorithms", JSch.getConfig("PubkeyAcceptedAlgorithms") + ",ssh-rsa,ssh-dss");
```

# 私钥文件转换

`-----BEGIN RSA PRIVATE KEY-----`和`-----BEGIN PRIVATE KEY-----`的转换

执行

```
ssh-keygen -p -m PEM -f /path/to/your/rsa_private_key
```

如果提示权限过高，可将权限修改为600，如果修改权限无效，可能是在挂载盘上进行了修改，将其移入本地目录进行权限修改。

`-----BEGIN RSA PRIVATE KEY-----`到ssh key 的转换，这里需要用到puttygen，使用puttygen导入rsa 的私钥，接着导出openssh的私钥

![image-20241015164813651](sftp服务搭建以及连接/image-20241015164813651.png)

# 从私钥导出公钥

注意每次修改私钥格式后都要重新生成对应的公钥

`ssh-keygen -y -f conversion.key > conversion`

# RC2-40-CBC不支持

从p12证书中导出pem文件时报错

```
openssl pkcs12 -in ftp_scb_test0913.p12  -out sftp_key.pem
```

`80CB4337B67F0000:error:0308010C:digital envelope routines:inner_evp_generic_fetch:unsupported:../crypto/evp/evp_fetch.c:349:Global default library context, Algorithm (RC2-40-CBC : 0), Properties ()`

解决方式，添加provider参数

```
openssl pkcs12 -in ftp_scb_test0913.p12  -out sftp_key.pem -provider default -provider legacy
```

# JSCH文档

[ChannelSftp (JSch API) (epaul.github.io)](https://epaul.github.io/jsch-documentation/javadoc/)