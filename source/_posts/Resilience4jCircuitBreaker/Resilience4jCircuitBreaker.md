---
title: Resilience4j Circuit Breaker
date: 2025-09-21 13:27:19
updated: 2025-09-21 13:27:19
tags:
  - Resilience4j
  - 熔断
categories:
  - 笔记
---

# 参考资料

[(36 封私信 / 80 条消息) Spring Boot使用Resilience4j容错：熔断、重试、限时、限流、隔板 - 知乎](https://zhuanlan.zhihu.com/p/583585713)

[在 Spring Boot 应用中使用 Resilience4j - spring 中文网](https://springdoc.cn/spring-boot-resilience4j/)

# 简述

作为 Hystrix 的替代方案，专为 Java 8+ 和函数式编程设计，轻量且模块化，仅聚焦于核心的容错机制（熔断、降级、限流等），不依赖其他重型库。目前是 Spring Cloud 官方推荐的容错组件（替代 Hystrix）。

# 使用

```xml
<dependency>
    <groupId>io.github.resilience4j</groupId>
    <artifactId>resilience4j-spring-boot2</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```