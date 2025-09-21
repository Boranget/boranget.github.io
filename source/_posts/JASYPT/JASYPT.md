---
title: JASYPT
date: 2025-09-21 12:35:19
updated: 2025-09-21 12:35:19
tags:
  - JASYPT
  - 加密
categories:
  - notes
---

# 参考资料

[【Springboot】Springboot整合Jasypt，让配置信息安全最优雅方便的方式 - 南瓜慢说 - 博客园](https://www.cnblogs.com/larrydpk/p/12037857.html)

# 简述

加密工具，现多用于加密springboot中的配置文件

# 使用

```xml
<dependency>
  <groupId>com.github.ulisesbocchio</groupId>
  <artifactId>jasypt-spring-boot-starter</artifactId>
  <version>2.1.1</version>
</dependency>
```

配置文件中直接使用`ENC()`声明加密后数据

```properties
# 数据库配置（密码已加密）
spring.datasource.url=jdbc:mysql://localhost:3306/mydb
spring.datasource.username=root
spring.datasource.password=ENC(EVnE5sH2g8t+wM5eQrF5aA==)
```

# 根密码配置

根密码值jasypt使用的密码，可通过配置文件或者启动参数传入，推荐启动参数

```yaml
jasypt:
  encryptor:
    password: your_encryption_password
```

```
-Djasypt.encryptor.password=your_encryption_password
```

