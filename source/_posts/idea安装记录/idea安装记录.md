---
title: idea安装记录
date: 2023-05-21 20:41:30
updated: 2023-12-09 16:50:30
tags:
  - idea
categories:
  - 经验
---

# 2021版安装记录

## 所需文件

链接：https://pan.baidu.com/s/1oQkinHQ-wEcGCRxEbu5KJQ 
提取码：dtzy

## 软件安装

正常安装idea即可，安装完成后关闭idea。

## 注册

1. 将jar包 FineAgent.jar 放入一个文件夹， 比如idea的安装目录
2. 用记事本打开idea安装目录中的bin/idea64.exe.vmoptions
3. 最下面一行添加-javaagent:D:\\idea\\FineAgent.jar，后半部分为 FineAgent.jar 的文件位置
4. 打开idea，选择Activation code, 输入激活码文件中的内容
5. 点击 Activate 进行激活，Continue 进入idea

安装结束

# 2023版安装记录

idea一直闪退，干脆就卸载装最新的了

## 下载安装包

在官网下载安装文件，下拉列表选择zip（默认是exe）

注意选择激活网站中支持的版本

## 激活网站

[https://jetbra.in/s](https://jetbra.in/s)

[JETBRA.IN CHECKER | IPFS](https://3.jetbra.in/)

地球图标为可用的网站，进入后上方有一个zip包下载，下载该zip包

## 修改配置文件

修改安装目录中bin文件夹中的idea64.exe.vmoptions文件，末尾追加如下内容，下面两行必须加

```
# 请修改为ja-netfilter.jar文件所在绝对路径
-javaagent:/path/to/ja-netfilter.jar=jetbrains
--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
```

> Operation guide: 
>     1. add -javaagent:/path/to/ja-netfilter.jar=jetbrains to your vmoptions (manual or auto)
>         2. log out of the jb account in the 'Licenses' window
>         3. use key on page https://jetbra.in/5d84466e31722979266057664941a71893322460
>         4. plugin 'mymap' has been deprecated since version 2022.1
>         5. don't care about the activation time, it is a fallback license and will not expire
>
> Enjoy it~
>
> JBR17:
>     add these 2 lines to your vmoptions file: (for manual, without any whitespace chars)
>     --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
>     --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
>
> NEW: 
>     Auto configure vmoptions:
>         macOS or Linux: execute "scripts/install.sh"
>         Windows: double click to execute "scripts\install-current-user.vbs" (For current user)
>                                          "scripts\install-all-users.vbs" (For all users)

## 激活

运行idea，选择激活码激活，在激活网站点击复制激活码，粘贴到idea激活码框中，若提示激活码非法，查看是否配置文件最后两行没加上，若无法复制则换一个网站