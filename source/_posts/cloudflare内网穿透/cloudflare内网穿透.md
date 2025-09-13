---
title: cloudflare内网穿透
date: 2024-09-07 13:35:19
updated: 2024-09-07 13:35:19
tags:
  - cloudflare
  - 内网穿透
categories:
  - 经验
---

# 参考资料

[没有公网IP? 免费域名搭建cloudflare内网穿透，不限流量 - 哔哩哔哩 (bilibili.com)](https://www.bilibili.com/read/cv35069293/)

# 前置

- 需要cloudflare账户
- 需要有一个在cf上托管的域名

# 配置Tunnel

进入首页的Zero Trust，（随便）取一个组织名，选择免费的服务，到选择付款方式时，返回[cloudflare首页](https://dash.cloudflare.com )，重新进入Zero Trust（免的添加付款方式），找到左侧Network下的Tunnels，进入Add一个Tunnel，选择Cloudflare（另一个是WARP），取一个名字，接着下载要穿透的系统的版本。

# wifi棒子穿透

穿透Wifi棒子时，选择debian arm64的版本，下面会展示下载以及安装启动命令，由于网络的问题，可以先用迅雷云盘下载好安装包，传到wifi棒子上，再执行下面的安装与启动命令，启动成功后（启动时可能会报错，但以服务运行状态以及当前页面显示为准），当前页面下方会显示有连接的系统。

![image-20240907144034956](cloudflare内网穿透/image-20240907144034956.png)

# 配置域名

点击下一步后，进入域名与映射的配置

![image-20240907144152996](cloudflare内网穿透/image-20240907144152996.png)

配置成功后点击保存。

# 连接测试

本地启动一个网络服务后，访问上方配置的域名查看是否能够访问到。