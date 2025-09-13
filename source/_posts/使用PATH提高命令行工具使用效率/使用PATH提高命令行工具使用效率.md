---
title: 使用PATH提高命令行工具使用效率
date: 2024-05-17 14:35:19
updated: 2024-05-17 14:35:19
tags:
  - path
categories:
  - 经验
---

# 基本思想

编写bat脚本作为程序入口，将bat脚本所在文件夹放入path环境变量，即可在命令行中直接使用

# 目录设计

```
E:\MYPATH
├─bin
└─oexsd
```

其中，MYPATH根目录用于存放各工具的详细文件以及一个bin文件夹，bin文件夹中存放自定义的命令行工具如bat文件

# 环境变量配置

添加环境变量`MY_PATH_HOME`，指向`MYPATH`目录

在环境变量Path中添加bin目录：`%MY_PATH_HOME%\bin`

# jar包工具bat

```bat
java  -jar %MY_PATH_HOME%/oexsd/oexsd.jar %1
```

