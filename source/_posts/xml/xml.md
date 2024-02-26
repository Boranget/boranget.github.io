---
title: xml
date: 2023-11-04 16:14:19
updated: 2023-11-04 16:14:19
tags:
  - xml
categories:
  - 笔记
---

# XML

EXtensible Markup Language 可扩展标记语言

常用于做配置文件

# 声明

```xml
<?xml version="1.0" encoding="UTF-8"?>
```

# 特点

- 根标签只能有一个
- 第一行永远是声明，前不可有任何注释
- xml可以有约束，用于约束xml中可以出现的内容
    - dtd 语法简单，相对不细致，后缀为dtd
    - schema 复杂，相对细致，后缀为xsd