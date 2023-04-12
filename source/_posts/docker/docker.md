---
title: docker
date: 2022-12-8 16:50:30
tags:
---

# 概念

## 镜像

只读模板，用于创建容器

## 容器

由模板创建的  实例，包括一个linux环境和运行在其中的应用     

## 仓库

存放镜像的地方

# 安装

 需要在linux上部署docker

仓库安装时注意不要选择国外镜像
阿里云个人加速服务 

# 运行  

docker run ***

在本地仓库寻找有没有***这个镜像，若有，照其实例化一个容器，若没有，在远端仓库查找有无该镜像，若有，下载到本地仓库并执行，若无，报错找不到

# 一些功能

## 启动

启动 systemctl start docker 

停止 systemctl stop docker

重启 systemctl restart docker

查看状态 systemctl status docker

开机启动 systemctl status docker

查看docker概要信息 docker info

查看总体帮助文档 docker --help

查看命令帮助文档 docker 具体命令 --help

## 镜像

查看本地镜像 docker images

在远端仓库查找镜像-限制数目 docker search

拉取镜像（下载），不加tag默认最新 docker pull

删除镜像 docker rmi 

查看镜像、容器、数据卷所占的空间 docker system df

虚悬镜像 仓库名，标签名都是none的镜像，无用，删除 