---
title: wsl2ubuntu安装
date: 2024-01-05 10:35:19
updated: 2024-01-05 10:35:19
tags:
  - wsl2
categories:
  - 经验
---

# 参考资料

[Windows10/11 三步安装wsl2 Ubuntu20.04（任意盘） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/466001838)

[Windows 11 系统下安装 WSL2+Ubuntu22.04+GCC+VI教程-CSDN博客](https://blog.csdn.net/kahhsss/article/details/131902623#:~:text=在开始菜单中找到下打开PowerShell，，右键以管理员身份运行，输入wsl --install命令，然后重新启动计算机。 打开Microsoft store%2C找到Ubuntu22.04，点击下载，下载完成后自动安装，在开始界面打开。,在WINDOWS功能中，开启 Windows 虚拟化和 Linux 子系统，等待系统完成更改，如图。)

[【2023最新】Windows11 wsl2 ubuntu22.04安装与配置_wsl --install -d ubuntu-22.04-CSDN博客](https://blog.csdn.net/ljw_study_in_CSDN/article/details/129752865)

[如何在Windows11上安装WSL2的Ubuntu22.04（包括换源）_wsl2换源-CSDN博客](https://blog.csdn.net/syqkali/article/details/131524540)

# 前置条件

已开启wsl2

# 安装

在winsows商店中搜索ubuntu，找到需要的版本点击获取即可安装（到C盘）

或者使用命令行 `wsl --install`

# 设置

安装完成后点击启动会打开控制台，界面显示引导信息需要输入用户名和密码，设置完成即可进入系统

# 镜像配置

sudo 编辑 `/etc/apt/sources.list`，建议先cp备份

在原有配置下添加如下配置

```
deb https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse

#deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse

#deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

#deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

#deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse

#deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
```

# 字体安装

提示找不到ubuntu mono字体，可在网上下载改字体，将字体文件放入c/windows/fonts中