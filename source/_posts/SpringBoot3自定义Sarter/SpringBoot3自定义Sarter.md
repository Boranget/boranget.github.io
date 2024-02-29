---
title: SpringBoot3自定义Sarter
date: 2023-09-04 16:50:30
updated: 2023-09-05 16:50:30
tags:
  - SpringBoot
categories:
  - experience
---

# 变化

- 在SpringBoot2.7之前，starter的自定义方式为在META-INF/spring.factories文件里添加

    ```
    org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
    XXAutoConfiguration
    XXAutoConfiguration
    XXAutoConfiguration
    .....
	```

- SpringBoot2.7时，添加了一种新的配置方式：在META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports文件里添加配置类名称，每行包含一个配置类全限定名，并且此时还是支持spring.factories的配置方式的

- 在SpringBoot3.x开始，移除了factories的配置方式

# 开发流程

## 引入依赖

需要引入自动配置的依赖

```xml
 <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-autoconfigure</artifactId>
</dependency>
```

## 创建配置类

配置类上要加AutoConfiguration的注解（不需要标注Congifuration注解了）

## 创建配置文件

文件名

```
META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports
```

文件内容

```
XXAutoConfiguration
XXAutoConfiguration
XXAutoConfiguration
```

