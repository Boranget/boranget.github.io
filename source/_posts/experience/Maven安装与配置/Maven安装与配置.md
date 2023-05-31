---
title: Maven安装与配置
date: 2023-05-27 16:50:30
tags:
  - maven
categories:
  - 经验
---

# 下载

[Maven – Download Apache Maven](https://maven.apache.org/download.cgi)

下载apache-maven-***-bin.zip

# 解压

将压缩包中的内容解压到文件夹，这里解压到D:\tools\maven

# 环境变量

用户变量中配置M2_HOME为D:\tools\maven\apache-maven-3.9.2

系统变量配置Path添加%M2_HOME%\bin

# 配置

打开maven根目录下的conf目录下的settings.xml

## 本地仓库

```xml
<localRepository>D:\tools\maven\mvnr</localRepository>
```

## 阿里云镜像

```xml
 <mirrors>
		<mirror>
            <id>alimaven</id>
            <mirrorOf>central</mirrorOf>
            <name>aliyun maven</name>
            <url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
        </mirror>
  </mirrors>
```

## jdk版本

```xml
<profiles>
  <!-- java版本编译 --> 
		<profile>
		<!-- 告诉maven我们用jdk1.8 --> 
			  <id>jdk-1.8</id>
			  <!-- 开启jdk的使用 --> 
			  <activation>
				<activeByDefault>true</activeByDefault>
				<jdk>1.8</jdk>
			  </activation>
			
			  <properties>
			  <!-- 配置编译器信息 -->
				<maven.compiler.source>1.8</maven.compiler.source>
				<maven.compiler.target>1.8</maven.compiler.target>
				<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
			  </properties>
		</profile>
</profiles>
```

# 测试

执行 mvn help:system

# idea配置

新创建项目使用配置的maven

![image-20230530214033126](Maven安装与配置/image-20230530214033126.png)

创建项目的时候不从网络下载archetype-catalog.xml模板，加快创建maven项目的速度

![image-20230530214240740](Maven安装与配置/image-20230530214240740.png)

# 历史版本下载

[Index of /dist/maven/maven-3 (apache.org)](https://archive.apache.org/dist/maven/maven-3/)