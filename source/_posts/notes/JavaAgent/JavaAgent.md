---
title: JavaAgent
date: 2023-01-30 13:35:19
tags:
  - JavaAgent
categories:
  - 笔记
---

# 参考资料

[一文讲透Java Agent是什么玩意？能干啥？怎么用？ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/636603910)

# 背景

JVMPI（Java Virtual Machine Profiler Interface）与JVMDI（Java Virtual Machine Debug Interface）是java在1.5之前提出的jvm规范，分别要求jvm提供分析与调试的接口，1.5之后将两类接口合称为JVMTI（JVM Tool Interface）

# JAVA AGENT

在JDK1.5之后，jvm提供了探针接口Instrumentation。，底层依赖JVMTI的native api，在1.6之后，jvm提供了attach接口，同样是依赖JVMTI的native接口。

可认为Java Agent可以理解为是一种特殊的Java程序，是调用Instrumentation接口的客户端。

java agent无法单独启动，必须依附在一个java应用程序上，与其共享同一个jvm，通过Instrumentation接口与jvm进行交互。

Java Agent有两种执行方式：

- premain

    在应用运行之前会通过premain方法来实现在应用启动时侵入并代理应用，该方式使用Instrumentation接口实现

    该方法使用jvm参数-javaagent引入，同时可配置多个agent，但多个agent全类名若有重复，则后面的会将前面的覆盖。但若premain方法执行失败或者抛出异常则jvm会终止。

- agentmain

    在应用运行之后，通过attach API和agentmain方法实现在应用启动后的某一个运行阶段侵入并代理应用，该方式使用Attach接口

    启动应用之后，可以通过Java JVM 的Attach接口加载Java Agent。

    Attach 接口其实是JVM进程之间的沟通桥梁，底层通过Socket进行通信，JVM A可以发送指令给JVM B，JVM B在收到指令之后执行相应的逻辑。

    比如，在命令行中经常使用的Jstack、Jcmd、Jps等，都是基于这种机制实现的。

## Premain

首先使用maven构建premain包

maven配置：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>premainTest</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>8</maven.compiler.source>
        <maven.compiler.target>8</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>3.1.0</version>
                <configuration>
                    <archive>
                        <manifest>
                            <addClasspath>true</addClasspath>
                        </manifest>
                        <manifestEntries>
                            <Premain-Class>com.boranget.PreMainAgent</Premain-Class>
                            <Can-Redefine-Classes>true</Can-Redefine-Classes>
                            <Can-Retransform-Classes>true</Can-Retransform-Classes>
                            <Can-Set-Native-Method-Prefix>true</Can-Set-Native-Method-Prefix>
                            <!--
                            <Premain-Class>：指定包含premain方法的类，需要配置为类的全路径名，必须配置。
                            <Can-Redefine-Classes>：是否可以重新定义class，默认为false，可选配置。
                            <Can-Retransform-Classes>：是否可以重新转换class，实现字节码替换，默认为false，可选配置。
                            <Can-Set-Native-Method-Prefix>：是否可以设置Native方法的前缀，默认为false，可选配置。
                            -->
                        </manifestEntries>
                    </archive>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

```java
package com.boranget;

import java.lang.instrument.Instrumentation;

public class PreMainAgent {
    // 这里的方法名是固定的
    public static void premain(String agentArgs, Instrumentation inst) {
        System.out.println("*********我是PreMainAgent");
        System.out.println("*********agentArgs = " + agentArgs);
    }
}
```

将该premain使用maven打包，会自动填写MF文件，打包后存入一个路径，可照此流程再创建一个premain包。

随便构建一个运行类

```java
package com.boranget;

public class PremainTest {
    public static void main(String[] args) {
        System.out.println("运行中");
    }
}
```

添加jvm参数执行该类，其中路径为我将打包好的premain包存放的路径，haha1和haha2是我要传入的参数

`-javaagent:e:\test\JavaTest\premainTest\premainTest1.jar=haha1 `

`-javaagent:e:\test\JavaTest\premainTest\premainTest2.jar=haha2`

可以看到如下输出

```
*********我是PreMainAgent
*********agentArgs = haha1
*********我是PreMainAgent的弟弟PreMainAgent2
*********agentArgs = haha2
运行中
```

可见premain方法是在main方法之前执行的

如果在其中某个premain中抛出异常

```java
public class PreMainAgent3 {
    public static void premain(String agentArgs, Instrumentation inst) {
        System.out.println("*********我是PreMainAgent");
        System.out.println("*********agentArgs = " + agentArgs);
        throw new RuntimeException("123");
    }
}
/**
*********我是PreMainAgent
*********agentArgs = haha1
*********我是PreMainAgent的弟弟PreMainAgent2
*********agentArgs = haha2
*********我是PreMainAgent
*********agentArgs = haha2
FATAL ERROR in native method: processing of -javaagent failed
java.lang.reflect.InvocationTargetException
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at sun.instrument.InstrumentationImpl.loadClassAndStartAgent(InstrumentationImpl.java:386)
	at sun.instrument.InstrumentationImpl.loadClassAndCallPremain(InstrumentationImpl.java:401)
Caused by: java.lang.RuntimeException: 123
	at com.boranget.PreMainAgent3.premain(PreMainAgent3.java:9)
	... 6 more
Exception in thread "main" 
Process finished with exit code 1
**/

```

## Attach

attach的主要流程是启动主应用后，获取该应用的pid

用到VirtualMachine类时需要手动将该jar包添加到依赖中

这里用到了三个类：

第一个类是代理行为，需要打成jar包使用

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <version>3.1.0</version>
            <configuration>
                <archive>
                    <manifest>
                        <addClasspath>true</addClasspath>
                    </manifest>
                    <manifestEntries>
                        <Agent-Class>com.boranget.AgentMain</Agent-Class>
                        <Can-Redefine-Classes>true</Can-Redefine-Classes>
                        <Can-Retransform-Classes>true</Can-Retransform-Classes>
                    </manifestEntries>
                </archive>
            </configuration>
        </plugin>
    </plugins>
</build>
```

```java
public class AgentMain {
    public static void agentmain(String agentArgs, Instrumentation inst) {
        System.out.println("----------哈哈，我是agentmain");
        System.out.println("----------agentArgs = " + agentArgs);
    }
}
```

将该类打成jar包放到某位置备用

第二个类为运行主类，用于被代理

```java
public class AgentTest {
    public static void main(String[] args) throws IOException {
        System.in.read();
    }
}
```

read是为了保持程序的执行，因为接下来要获取该程序的pid来进行代理，运行该类。

第三个类为注入类，用于控制被代理类

```java
public class AttachMain {
    public static void main(String[] args) {
        try {
            VirtualMachine vm = VirtualMachine.attach("27924");
            vm.loadAgent("E:\\test\\JavaTest\\premainTest\\attachmain.jar", "aa");
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
}
```

其中27924为被代理类运行时的pid，在命令行控制台使用jps获取

路径则为代理行为类打成的jar包

运行注入类后可在被代理类的运行窗口中看到如下内容

```
----------哈哈，我是agentmain
----------agentArgs = aa
```

