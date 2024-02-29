---
title: github使用action自动部署hexo
date: 2023-09-10 16:01:30
updated: 2023-09-11 16:50:30
tags:
  - github
  - action
categories:
  - experience
---

# 参考资料

[使用 GitHub Actions 自动部署 Hexo 博客到 GitHub Pages - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/161969042)

[GitHub Actions 来自动部署 Hexo - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/170563000)

# 起因

之前一直是在本地构建完成后上传到github，这次尝试使用github的action来完成

# 流程

## 生成密钥对

Linux系统执行

```
ssh-keygen -t rsa -b 4096 -C "Hexo Deploy Key" -f github-deploy-key -N ""
```

会在当前目录生成公钥和私钥两个文件

## 配置私钥

在存放博客源码仓库的设置setting下，赵傲secrets and variables，展开后选择actions，点击 new repository secret，输入密钥名与之前生成的github-deploy-key文件内容（非pub）

## 配置公钥

将公钥配置到需要部署网页的仓库，像我源码目录和网页仓库都是同一个，只不过是不同分支，就在当前setting下继续配置，否则进入部署网页的仓库的setting。

setting -> deploy keys

将生成的pub内容粘贴进去，勾选allow write access，允许push操作

## 编写脚本

在项目中新建文件，地址为.github/workflows/deploy.yml，文件名可自定义。

其内容

```yml
name: Hexo Deploy

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest # 使用最新版ubuntu为环境
    if: github.event.repository.owner.id == github.event.sender.id

    steps:
      - name: Checkout source
        uses: actions/checkout@v2
        with:
          ref: master

      - name: Setup Node.js
        uses: actions/setup-node@v1
        with:
          node-version: '12'

      - name: Setup Hexo
        env:
          ACTION_DEPLOY_KEY: ${{ secrets.HEXO_DEPLOY_KEY }} # 环境变量设置key为部署key
        run: |
          mkdir -p ~/.ssh/
          echo "$ACTION_DEPLOY_KEY" > ~/.ssh/id_rsa
          chmod 700 ~/.ssh
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts
          git config --global user.email "boranget@outlook.com"
          git config --global user.name "boranget"
          npm install hexo-cli -g
          npm install

      - name: Deploy
        run: |
          hexo clean
          hexo deploy
```



