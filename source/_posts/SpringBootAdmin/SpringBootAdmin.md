---
title: SpringBootAdmin
date: 2025-09-21 12:56:19
updated: 2025-09-21 12:56:19
tags:
  - SpringBootAdmin
  - 监控
categories:
  - notes
---

# 参考资料

[问：Spring Boot应用监控组件&工具，梳理一下？_springboot服务器性能监控组件-CSDN博客](https://blog.csdn.net/li_guolin/article/details/144004423)

[Spring Boot Admin，贼好使！Spring Boot Admin（SBA）是一个开源的社区项目，用于管理和 - 掘金](https://juejin.cn/post/7052857798530433031)

# 简述

专门针对 Spring Boot 应用的可视化监控平台，通过集成 Actuator 端点，提供服务健康状态、配置信息、日志查看、JVM 监控等一站式功能。开箱即用的可视化界面，无需复杂配置，适合中小团队快速搭建监控系统。

# 使用

## 服务端：

```xml
<dependency>
  <groupId>de.codecentric</groupId>
  <artifactId>spring-boot-admin-starter-server</artifactId>
</dependency>
```

```java
@EnableAdminServer
```

```properties
server.port=8090
spring.boot.admin.context-path=/admin
```



## 客户端

```xml
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-client</artifactId>
    <version>3.2.0</version>
</dependency>
```

```properties
# 配置监控端地址
spring.boot.admin.client.url=http://localhost:8090/admin
```

