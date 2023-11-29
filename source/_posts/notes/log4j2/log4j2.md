---
title: log4j2
date: 2023-09-19 10:55:19
tags:
  - log4j2
categories:
  - 笔记
---

# 依赖

```xml
 <!--spring web-->
 <!--需要排除冲突依赖-->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
      <exclusions>
        <exclusion>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter-logging</artifactId>
        </exclusion>
      </exclusions>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-log4j2</artifactId>
    </dependency>
```



# 配置配置文件的读取路径

application.yml中配置

```yml
logging:
  config: classpath:log4j2/log4j2-dev.xml
```

# 配置文件配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration>

  <Properties>
    <!-- 日志存放路径, 从项目根目录开始 -->
    <property name="log.path" value="logs"/>
  </Properties>

  <Appenders>
    <!--*********************控制台日志配置***********************-->
      <Console name="console" target="SYSTEM_OUT">
        <!--设置日志格式及颜色-->
        <!-- "disableAnsi"设为"false"表示开启Ansi，这样在输出日志时，会有ANSI转义码，
        使得日志带有样式，例如颜色、闪烁等效果。
        "noConsoleNoAnsi"是Logback的一个特性，
        它防止在控制台输出时使用不支持的ANSI转义码，设置为"false"表示不禁止使用。 -->
        <PatternLayout
                pattern="%d %highlight{%-5level}{ERROR=Bright RED, WARN=Bright Yellow, INFO=Bright White, DEBUG=Bright Cyan, TRACE=Bright White} %style{[%t]}{bright,magenta} %style{%c{1.}.%M(%L)}{cyan}: %msg%n"
                disableAnsi="false" noConsoleNoAnsi="false"/>
      </Console>

    <!--*********************文件日志配置***********************-->
    <RollingFile name="rollingFile" fileName="${log.path}/bankforward.log"
      filePattern="${log.path}/bankforward-%d{yyyy-MM-dd}.log">
      <PatternLayout>
        <Pattern>%d %p %c{1.} [%t] %m%n</Pattern>
      </PatternLayout>
      <Policies>
        <!--每天生成一个日志文件-->
        <!-- 这里的策略是根据filePattern中的粒度决定的，
             filePatter粒度为天，这里就是一天一个日志 -->
        <TimeBasedTriggeringPolicy/>
      </Policies>
      <!--保留30天日志-->
      <DefaultRolloverStrategy>
        <Delete basePath="${log.path}" maxDepth="2">
          <IfFileName glob="*.log"/>
          <!--!这里的age必须和filePattern协调, 后者是精确到dd, 这里就要写成xd, xD就不起作用
          另外, 数字最好>2, 否则可能造成删除的时候, 最近的文件还处于被占用状态,导致删除不成功!-->
          <!--30天-->
          <IfLastModified age="30d"/>
        </Delete>
      </DefaultRolloverStrategy>
    </RollingFile>
  </Appenders>
  <Loggers>
    <!-- 日志全局设置 -->
    <root level="info">
      <!-- 输出到文件 -->
      <appender-ref ref="rollingFile"/>
      <!-- 输出到控制台 -->
      <appender-ref ref="console"/>
    </root>

    <!--按包名细控日志级别-->
    <Logger name="com.hand" level="debug"/>
  </Loggers>
</Configuration>

```



