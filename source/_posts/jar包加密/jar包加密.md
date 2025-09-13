---
title: jar包加密
date: 2023-08-23 12:50:30
updated: 2023-08-24 16:50:30
tags:
  - java
categories:
  - 经验
---

# 工具

[core-lib/xjar: Spring Boot JAR 安全加密运行工具，支持的原生JAR。 (github.com)](https://github.com/core-lib/xjar)

# 手动加密

// 能加密class吗？不能

报错：java.util.zip.ZipException: error in opening zip file

## 加密

```java
public class Enc {
    public static void main(String[] args) throws Exception {
        System.out.println(new File("./").getAbsolutePath());
        XCryptos.encryption()
                // 需要加密的jar包
                .from("./encryptJar/target/encryptJar-1.0-SNAPSHOT.jar")
                // 包括
//                .include("/io/xjar/**/*.class")
//                .include("/mapper/**/*Mapper.xml")
                // 排除
//                .exclude("/static/**/*")
//                .exclude("/conf/*")
                .to("./encryptJar/encrypted.jar");
    }
}
```

- include 和 exclude 同时使用时即加密在include的范围内且排除了exclude的资源
- 没有include加密jar包中全部文件

## 生成加密器

调用加密方法后，会在to文件夹（与encrypted.jar同级）生成一个xjar.go文件，执行：

```go
go build xjar.go
```

会生成名叫xjar（linux）或xjar.exe（Windows）的文件

## 运行

```bash
xjar java -jar encrypted.jar
```

# 插件加密

## 导入插件和插件配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>encryptJar</artifactId>
    <version>1.0-SNAPSHOT</version>


    <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
    </properties>
    <repositories>
        <repository>
            <id>jitpack.io</id>
            <url>https://jitpack.io</url>
        </repository>
    </repositories>
    <pluginRepositories>
        <pluginRepository>
            <id>jitpack.io</id>
            <url>https://jitpack.io</url>
        </pluginRepository>
    </pluginRepositories>
    <!-- 添加 XJar 依赖 -->
    <dependencies>
        <dependency>
            <groupId>com.github.core-lib</groupId>
            <artifactId>xjar</artifactId>
            <version>4.0.2</version>
            <!-- <scope>test</scope> -->
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>2.3</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <transformers>
                                <transformer
                                        implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                    <mainClass>com.boranget.Main</mainClass>
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>com.github.core-lib</groupId>
                <artifactId>xjar-maven-plugin</artifactId>
                <version>4.0.2</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>build</goal>
                        </goals>
                        <phase>package</phase>
                        <!-- 或使用
                        <phase>install</phase>
                        -->
                        <configuration>
                            <!--注意这里的相对路径应该是以mvn命令的目录为基-->
                            <sourceDir>./target/</sourceDir>
                            <sourceJar>encryptJar-1.0-SNAPSHOT.jar</sourceJar>
                            <targetDir>./</targetDir>
                            <targetJar>/encrypted.jar</targetJar>

                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

## 在项目根目录执行

```shell
mvn clean package -Dxjar.password=io.xjar
```