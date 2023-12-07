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

# 特点

- 服务端不保存任何客户端请求者信息
- 客户端的每次请求必须具备自描述信息，通过这些信息识别客户端身份

# 结构

header.payload.signature

- header: 头信息，令牌类型和签名算法
- payload：有效负载，放一些非敏感信息
- signature：签名，信息有无被修改的验证  

   

# 示例

- 原文

    ```
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
    ```

- 解码后

    - HEADER:ALGORITHM & TOKEN TYPE

        ```json
        {
          "alg": "HS256",
          "typ": "JWT"
        }
        ```

    - PAYLOAD:DATA
    
        ```json
        {
          "sub": "1234567890",
          "name": "John Doe",
          "iat": 1516239022
        }
        ```
    
    - VERIFY SIGNATURE
    
        ```json
        HMACSHA256(
          base64UrlEncode(header) + "." +
          base64UrlEncode(payload),
          your-256-bit-secret
        )
        ```

# 缺点

由于失效时间为jwt自带，服务端无法进行强制失效从而实现退出登录，若有该需求，服务端还是需要保存token信息，比如使用redis存储，但这样jwt的优点之一不占用服务端空间就显得很尴尬了