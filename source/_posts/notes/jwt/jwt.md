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
    
        