---
title: vercel部署hexo博客
date: 2023-09-10 15:50:30
updated: 2023-09-11 16:50:30
tags:
  - 托管
  - vercel
categories:
  - experience
---

# vercel

vercel是一个针对个人用户免费的服务托管服务

官网地址：https://vercel.com/

vercel与github账号进行绑定后，可以自动监控博客仓库的更改从而进行部署。遗憾的是生成的域名国内已经无法访问，不过代理一下体验一番还是可以的。

# 注册

进入官网，点击注册，选择使用github账户登录即可

# 导入仓库

进入vercel的主页后，会建议导入git仓库，这里先给vercel的github仓库读取权限，接着在下方展示的列表中选中hexo仓库，点击import

# 构建

填写完一些信息比如项目的名称后，便可以点击构建，构建过程可能会出错，比如仓库中存在yarn.lock文件等

# 展示

构建完成后便会部署到生成的域名，但该域名国内已经无法访问，如果有个人域名，可以进行域名的绑定服务。