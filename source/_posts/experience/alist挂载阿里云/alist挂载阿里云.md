---
title: alist挂载阿里云
date: 2023-11-12 10:35:19
tags:
  - alist
categories:
  - 经验
---

# 参考资料

[一键脚本 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/script.html)

# 安装alist

```bash
curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s install
```

# 设置密码

进入alist安装目录 /opt/alist

```bash
---------如何获取密码？--------
先cd到alist所在目录:
cd /opt/alist
随机设置新密码:
./alist admin random
或者手动设置新密码:
./alist admin set NEW_PASSWORD
```

# 访问

访问ip:5244后使用admin和密码进行登录

# 管理

点击下方管理按钮进入管理界面

# 挂载阿里云

## 获取阿里云刷新token

[Get Aliyundrive Refresh Token | AList Docs (nn.ci)](https://alist.nn.ci/tool/aliyundrive/request.html)

点击scan qrcode，使用阿里云飘盘扫描二维码后点击 i have scan，会跳转页面，显示刷新token

## 挂载

左侧存储 > 添加 > 阿里云盘open

填写一个挂载点

填写刷新token，保存

# 操作

查看状态：systemctl status alist
启动服务：systemctl start alist
重启服务：systemctl restart alist
停止服务：systemctl stop alist

# 配置文件

配置文件路径：/opt/alist/data/config.json
