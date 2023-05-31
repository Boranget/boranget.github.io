---
title: JWT
date: 2022-12-27 16:50:30
tags:
  - jwt
categories:
  - 笔记
---

# 定义

json web token

安全验证用，单点登录适用，开销小，有签名机制 

# 结构

header.payload.signature

- header: 头信息，令牌类型和签名算法
- payload：有效负载，放一些非敏感信息
- signature：签名，信息有无被修改的验证  

   