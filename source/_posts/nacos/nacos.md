---
title: nacos
date: 2023-04-22 10:35:19
updated: 2024-01-22 10:35:19
tags:
  - nacos
categories:
  - notes
---

# 单例模式启动

```shell
./startup.sh -m standalone
```

# 没有命名空间的访问权限

初次访问提示，登陆后即可

# 开启认证

```properties
nacos.core.auth.system.type=nacos

### If turn on auth system:
nacos.core.auth.enabled=true

nacos.core.auth.server.identity.key=ping
nacos.core.auth.server.identity.value=pong

nacos.core.auth.plugin.nacos.token.secret.key=Ym9yYW5nZXRib3JhbmdldGJvcmFuZ2V0Ym9yYW5nZXQ=
```

## 设置管理员密码

`curl -X POST 'http://$nacos_server_host:$nacos_server_port/nacos/v1/auth/users/admin' -d 'password=$your_password'`

## 修改管理员密码

```
put http://localhost:7543/nacos/v1/auth/users
username: "nacos"
newPassword: "123456"
```

