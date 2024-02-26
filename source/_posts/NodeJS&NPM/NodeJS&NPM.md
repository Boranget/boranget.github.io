---
title: NodeJS&NPM
date: 2023-11-10 16:40:19
updated: 2023-11-10 16:40:19
tags:
  - NodeJS&NPM
categories:
  - 笔记
---

# NodeJS

类似于java虚拟机，可以再浏览器外部运行js，且可以操作系统IO流，安装教程在本博客搜索”node安装“

# NPM

类似于后端的Maven，但是只能管理依赖

- 前端框架的下载工具

    可将云端仓库中的依赖下载到本地 

- 前端项目的管理工具

    项目初始化、依赖管理、研发模式运行、编译  

## 切换镜像

```bash
// 查看
npm config get registry
// 切换
npm config set registry https://registry.npmmirror.com
```

## 设置本地仓库地址

```bash
// 查看
npm config get prefix
// 设置
npm config set prefix "E:\tools\NodeJS\NPMGloableRegistry"
```

## npm升级

```bash
// 升级
npm install -g npm@9.6.6
// 验证
npm -v
```

## 仓库依赖查询

[npm | Home (npmjs.com)](https://www.npmjs.com/)

## npm常用命令

- 项目初始化

    - npm init

        初始化当前文件夹（项目）的信息，生成package.json文件

    - npm init -y

        所有信息使用默认

- 安装依赖

    - npm install 包名

        当前项目安装包

    - npm install 包名@版本号

        当前项目安装包带版本号

    - npm install

        根据package.json中的依赖信息安装依赖

    - npm install -g 包名

        全局库中安装包

    - npm  ls

        查看当前项目依赖

    - npm  ls

        查看当前项目依赖

    - npm run

        在package.json中的script属性