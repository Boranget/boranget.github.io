---
title: cas单点登录
date: 2024-03-06 14:35:19
updated: 2024-03-06 14:35:19
tags:
  - 单点登录
  - sso
categories:
  - 笔记
---

# 参考资料

[经典单点登录协议：CAS的原理与应用 - CSDN文库](https://wenku.csdn.net/column/6fe5dipf3s#:~:text=CAS（Central Authentication,Service）是一种基于票据的单点登录协议，旨在解决应用系统中用户认证和授权的统一管理问题。 CAS协议通过服务端统一验证用户身份，并颁发票据，各应用系统通过验证票据实现用户的单点登录，从而提高系统的安全性和便利性。)

[CAS单点登录(一)——初识SSO-CSDN博客](https://blog.csdn.net/Anumbrella/article/details/80821486)

[史上最强，Cas单点登录之服务端搭建_/cas/v1/tickets service.not.authorized.sso-CSDN博客](https://blog.csdn.net/numbbe/article/details/112175435)

# 概述

CAS central authentication service

基于票据的认证，由认证中心CAS服务器统一认证

# 过程

1. 用户访问系统应用
2. 系统检测到用户未登录（系统内无session），重定向到cas服务器
3. 用户在cas服务器进行登录
4. cas服务器验证用户身份，颁发票据
5. 用户携带票据返回到应用
6. 应用向cas发送请求验证票据
7. 验证成功，创建session返回携带cookie

# 术语概念

- TGC ticket-granting cookie
    由cas通过ssl的方式发送给终端用户，存放在浏览器的cookie中，该cookie只能基于https传输
- TGT ticket grangting ticket
    cas保存在服务器上的、为每个用户分别生成的登录证明，与上面返回给用户的TGC一一对应，当用户请求CAS时，会携带cookie中的TGC，按照TGC查询TGT，若能查到则说明用户之前登录过，若没有则需要用户重新登录。
- ST service Ticket
    cas给用户提供的某一应用的门票，用户访问该应用时携带，根据TGT签发，应用通过向CAS验证ST来查询用户是否登录。st在一次验证后，无论是否验证成功，都只能使用一次，一次验证后立即清除，若长时间未验证，也会清除

