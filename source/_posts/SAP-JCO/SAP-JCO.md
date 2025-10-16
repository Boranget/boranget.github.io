---
title: SAP-JCO
date: 2025-08-27 10:35:19
updated: 2025-08-27 16:35:19
tags:
  - SAP
  - JCO
categories:
  - 笔记
---

# 参考资料

[JAVA对接SAP接口使用sapjco3的见解-CSDN博客](https://blog.csdn.net/qq_38284858/article/details/90053402)

[(39 封私信 / 80 条消息) JAVA使用JCO方式调用SAP接口 - 知乎](https://zhuanlan.zhihu.com/p/589883353)

# 定义

java应用连接sap系统使用的中间件，底层使用native方法调用sap的rfc接口实现

# 使用

获取jco的jar包和dll包，添加到项目依赖

需要将sap的连接信息配置到连接中，可通过springbean的方式管理