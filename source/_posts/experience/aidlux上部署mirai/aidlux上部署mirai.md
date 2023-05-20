---
title: aidlux上部署mirai
date: 2022-03-20 16:50:30
tags:
---

# aidlux上部署mirai

## jdk11安装

* 注：如果遇到失败的情况可以尝试换源，我没有换源安装成功了
* apt-get update
* apt install openjdk-11-jdk

## 安装mirai

* （感谢AidLux开发者技术1群的网友 “受、死 ” 提供的思路）
* 先下载windows版本的[iTXTech MCL Installer](https://github.com/iTXTech/mcl-installer/releases)![在这里插入图片描述](aidlux上部署mirai/19a10579bb6a42e19db23bc949fb8216.png)


* 运行后会生成这些文件![在这里插入图片描述](aidlux上部署mirai/77923899467844739cbc7f012945ee04.png)

* 将这些文件（安装器，文档，cmd文件可以除外）通过aidlux网页端的文件管理器上传到aidlux中![在这里插入图片描述](aidlux上部署mirai/fe0f8a2ad8bd4b1590c10708de9d7272.png)

  * 如存入/home/mirai/目录下
* 前往/home/mirai/目录，运行./mcl执行安装（或者java -jar mcl.jar执行安装）
* 安装完成（直接启动）
* ./mcl 启动

## 自动登录设置

* vim打开/home/mirai/config/Console/AutoLogin.yml文件

* 编辑账号密码,:wq保存退出

## 滑动验证码问题

* 参考[mirai (mamoe.net)](https://docs.mirai.mamoe.net/mirai-login-solver-selenium/)
* 其中方法一中手机客户端在[Releases · mzdluo123/TxCaptchaHelper (github.com)](https://github.com/mzdluo123/TxCaptchaHelper/releases)下载

## 欢迎各位补充