---
title: https
date: 2023-07-04 09:50:30
updated: 2023-12-11 10:35:19
tags:
  - https
categories:
  - notes
---

# 参考资料

[HTTPS原理和TLS认证流程全解析 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/440612523)

[TLS 1.0 至 1.3 握手流程详解 - en_oc - 博客园 (cnblogs.com)](https://www.cnblogs.com/enoc/p/tls-handshake.html)

# HTTPS协议

http协议是明文传输，内容容易被中间人拦截后获取，且中间人可伪装为服务器，向客户端发送伪装的响应。

https在http应用层和tcp传输层中间加了一层SSL安全层，整个加密过程都没有侵入原先的http协议，故对http协议进行了很好的兼容。

# TLS/SSL

TLS协议就是SSL协议，SSL在被网景公司（Netscape）开发出来后，SSL1.0未公布，2.0具有重大缺陷，96年发布3.0，在SSL3.0的下一个版本便是TLS1.0，在此之后迭代TLS1.0、1.1、1.2和1.3，目前应用最广泛的为TLS1.2。

## TLS加密原理

类似于TCP会通过握手来建立连接，TLS也会通过握手来交换一些必要的基础信息。

既然TLS是为了保证传输安全，那肯定要对传输的数据进行加密，加密的方式一般有对称加密和非对称加密。

对称加密加密和解密都用的同一个密钥，由于CS方式的特殊性，如果采用对称加密，则会存在问题：是否所有客户端和服务端都用同一个密钥呢，当然如果这样做的话，则完全没有加密的必要了，因为任何一台客户端都可以用该密钥去截取其他客户端的信息。那如果每一对连接都是用不同的对称密钥呢？那对称密钥的首次传输也是个问题，不经过处理的话，首次传输的对称密钥也会被人截取。所以TLS同时采用了非对称加密方式来保护首次传输的对称密钥。

非对称加密，加密和解密的密钥是不同的，公钥会公布给各客户端用于加密信息，而私钥则会用于在服务端的数据解密操作。客户端可以生成一个对称密钥用于后续使用，但首次传输时会使用服务端提供的公钥将对称密钥进行加密传输给服务端。

那为何不全程使用非对称加密呢，原因是非对称的加解密操作很耗时，不如对称加密来的快。

那么服务端只需要将公钥发送给客户端，即可在后续的连接中使用客户端定义的对称密钥进行加密的信息传输。但紧接着有一个问题：如何判断这个公钥就是服务端的公钥而不是中间人产生的公钥呢？

## 数字证书和证书颁发机构

数字证书时一个文件，其中包含了某个服务站点的名字和公钥，该证书由证书颁发机构（Certificate Authority）CA 颁发，这是一个付费服务。服务端会将自己的证书发送给客户端，客户端则会向 CA 验证证书的真实性，验证通过则会取出证书中的公钥使用。

证书是多层次的，站点的证书由某一颁发机构颁发，该颁发机构的证书又由一个更高级别的颁发机构所颁发，以此向上，最高级别的颁发机构的证书是内置在客户端中的。

# SNI

server name indication

客户端在建立连接时指定要连接的服务器的名称。

# TLS握手步骤

1. 客户端发送”client hello“消息给服务器，其中包含客户端支持的加密方式、可选的压缩方式、一个随机字符串”client random“、一个可选的session id

2. 服务器响应”server hello“，其中包括选择的加密算法、服务端证书、以及随机字符串”server random“

3. 客户端验证服务端证书，从证书中提取公钥，同时生成”premaster secret“并使用公钥将其加密，客户端发送加密后的premaster secret给服务器

4. 服务端使用私钥解密获取premaster secret

5. 双方使用client random、server random、premaster secret组成相同的共享密钥”master secret“，后期使用该master secret做对称加密的通信

6. 双方互相发送finish信息：之前报文的摘要

    ![img](https/20220322162701.png)

## 压缩

压缩功能 TLS 不建议启用，甚至在 TLS 1.3 时相关功能被直接禁用。

这一方面是由于压缩功能并不是 TLS 协议的本职，同时也是因为压缩功能带来了安全上的问题。

## premaster secret

```c
struct {
  ProtocolVersion client_version;
  opaque random[46];
} PreMasterSecret;
```

客户端版本用于检测降级攻击，防止中间人使用旧的不安全的协议攻击

但如果这条消息是用服务端公钥加密的，那中间人就可以伪造一份发给服务端？

## 前向安全性

过去的通信的安全性不会受到未来的密钥泄露事件的影响。RSA 和 DH 的密钥协商方式在 TLS 1.3 中被删除就是因为不具备前向安全性。

拿 RSA 举例，如果我们一直使用 RSA 的密钥协商方式进行通信，虽然攻击人不能立刻的解密出通信密钥，但是可以持续的收集这些被加密的通信内容。直到某一天你的服务器终于被攻破，证书对应的私钥被攻击人拿到，那么他将可以使用私钥解密你在之前的所有连接建立时被加密的 pre master secret𝑝𝑟𝑒 𝑚𝑎𝑠𝑡𝑒𝑟 𝑠𝑒𝑐𝑟𝑒𝑡 ，并生成 master secret𝑚𝑎𝑠𝑡𝑒𝑟 𝑠𝑒𝑐𝑟𝑒𝑡 ，然后可以获得使用该密钥加密的所有会话数据。

## TLS1.2

TLS1.2中允许客户端在收到服务端返回的finish之前就可以发送被加密的业务数据，减少等待时间

