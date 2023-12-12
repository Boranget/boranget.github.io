---
title: vscode内网穿透
date: 2023-12-12 10:35:19
tags:
  - 内网穿透
categories:
  - 经验
---

# 参考资料

[Port forwarding local services with VS Code (visualstudio.com)](https://code.visualstudio.com/docs/editor/port-forwarding)

[VSCode自带内网穿透服务了，提供公网域名 (nodeseek.com)](https://www.nodeseek.com/post-45596-1)

# 工具

一台本机上的服务

vscode软件

# 方法

启动本机服务，记录其端口，比如以nginx默认页面80端口为例

打开vscode，切换至下方一个“端口”窗口，点击添加端口，填入nginx的80，回车。

vscode会弹出github登录认证，登录之后，vscode即会生成一个公网地址

![image-20231212102010787](vscode内网穿透/image-20231212102010787.png)

# 可见性

右键域名可设置可见性，默认只有相同github账户登录之后才可以访问，可设为公共