---
title: cloudflare代理github
date: 2023-07-21 16:50:30
updated: 2023-08-21 16:50:30
tags:
  - 代理
categories:
  - experience
---

# 参考资料

[gh-proxy](https://github.com/hunshcn/gh-proxy)

[资源分享|免费注册申请永久的eu.org顶级域名创建属于自己的域名,再也不用给博客域名续费了! - 墨天轮 (modb.pro)](https://www.modb.pro/db/514042)

# 工具

[虚拟地址生成器](https://www.meiguodizhi.com/cn-address)

# 起因

一直用着gh-proxy来代理github，偶尔发现页脚有源码分享，于是想着自己搭建一个

# Cloudflare注册

首页：[https://workers.cloudflare.com](https://workers.cloudflare.com/)

注册，登陆

Start building，取一个子域名，Create a Worker

会首先让激活一个测试代码，这里先激活，待会儿修改

复制 [index.js](https://cdn.jsdelivr.net/gh/hunshcn/gh-proxy@master/index.js) 到左侧代码框，`Save and deploy`。如果正常，右侧应显示首页。

但国内在访问web.dev域名会被拦截，这里需要自定义域名代理

# Hostry注册

经过尝试，现在Hostry已经无法使用qq邮箱和163邮箱注册，于是使用了临时接码平台（Hostry只用一次）

使用工具中的虚拟地址生成器生成信息

注册完邮箱里会收到验证邮件，第一次登陆会收到第二次邮件

登录时人机验证吗加载较慢，需要等一会儿

登录之后，点击Service中的Free DNS进入DNS页面

输入要申请的域名，点击创建DNS，后面的步骤默认即可

# eu.org注册

访问地址：https://nic.eu.org/ 进行账户注册

注册过程中的个人信息同样可以通过上方的信息生成器，但邮箱建议使用自己的邮箱，因为之后要接受域名审核成功的邮件

首先会接收到一封账户验证的邮件，点击进入登陆界面

登入后，界面比较简单，点击New Domain创建域名

已有信息无需修改

- Complete domain name 输入要申请的域名，与上方Hostry中的域名一致
- 勾选 Private（not shown in the public Whois）
- Name Servers 选择server names + replies on SOA + replies on NS(recommended)
- 最下方的列表左侧（Name1 ...）填写Hostry提供的如下几条
  - ns1.hostry.com
  - ns2.hostry.com
  - ns3.hostry.com
  - ns4.hostry.com
- 点击submit提交，出现如下结果即可

```
---- Servers and domain names check

Getting IP for NS1.HOSTRY.COM: 185.186.246.19
Getting IP for NS2.HOSTRY.COM: 206.54.189.187
Getting IP for NS3.HOSTRY.COM: 195.123.233.100
Getting IP for NS4.HOSTRY.COM: 45.32.157.198

---- Checking SOA records for BORANGET.EU.ORG

SOA from NS1.HOSTRY.COM at 185.186.246.19: serial 2023072202 (13.130 ms)
SOA from NS2.HOSTRY.COM at 206.54.189.187: serial 2023072202 (115.711 ms)
SOA from NS3.HOSTRY.COM at 195.123.233.100: serial 2023072202 (76.442 ms)
SOA from NS4.HOSTRY.COM at 45.32.157.198: serial 2023072202 (19.542 ms)

---- Checking NS records for BORANGET.EU.ORG

NS from NS1.HOSTRY.COM at 185.186.246.19: ok (11.674 ms)
NS from NS2.HOSTRY.COM at 206.54.189.187: ok (116.001 ms)
NS from NS3.HOSTRY.COM at 195.123.233.100: ok (75.258 ms)
NS from NS4.HOSTRY.COM at 45.32.157.198: ok (18.837 ms)


No error, storing for validation...
Saved as request 20230722060459-arf-64412

Done
```

