---
title: ELK
date: 2025-09-21 12:56:19
updated: 2025-09-21 12:56:19
tags:
  - ELK
  - 监控
categories:
  - 笔记
---

# 参考资料

[Spring Boot整合ELK实现日志采集与监控Spring Boot整合ELK实现日志采集与监控 前言 在分布式项目 - 掘金](https://juejin.cn/post/7181637220267196474)

[Spring Boot与ELK环境：从搭建到整合的详尽指南-百度开发者中心](https://developer.baidu.com/article/detail.html?id=3244353)

# 简述

ELK 是三个开源工具的组合缩写：

Logstash：数据处理管道，用于收集、过滤和转换日志

Elasticsearch：分布式搜索引擎，用于存储和快速查询日志数据

Kibana：可视化平台，用于展示和分析 Elasticsearch 中的数据

用于整合多个微服务的日志到一个平台，方便快速进行问题排查

# 使用

在微服务的日志配置中，将日志输出到logstash开放出来的接口，

或者配置logstash，让其主动读取日志文件