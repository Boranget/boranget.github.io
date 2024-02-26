---
title: JupyterNotebook的安装
date: 2023-11-19 19:35:19
updated: 2023-11-20 16:50:30
tags:
  - JupyterNotebook
categories:
  - 经验
---

# 安装python

https://www.python.org/

找到最新版或者你要下载的版本，往下滑，找到下载列表，选择合适的系统，点击下载。

直接运行安装包，可一路选择默认，最后会要求修改path长度限制，允许即可。

**pip设置清华源**

```bash
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

# pip安装jupyter

```bash
pip install jupyter notebook
```

# 运行

```bash
jupyter notebook
```

