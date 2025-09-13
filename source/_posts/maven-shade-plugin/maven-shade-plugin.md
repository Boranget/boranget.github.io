---
title: maven-shade-plugin
date: 2023-12-03 18:35:19
updated: 2023-12-03 10:35:19
tags:
  - maven插件
categories:
  - 笔记
---

# 参考资料

[maven-plugin-shade 详解 - 六开箱 - 博客园 (cnblogs.com)](https://www.cnblogs.com/lkxed/p/maven-plugin-shade.html)

# 介绍

Maven Shade Plugin主要是为了将一个自启动JAR项目的依赖打包到一个大的JAR中，从而不用担心依赖问题。它还可以通过设置MainClass，创建一个可以执行的JAR包，同时若其他项目引用此jar包，可以解决第三方JAR包冲突问题。

- 可以将项目包含的依赖打包人一个jar中
- 可以通过重命名的方式将依赖的package重定向

# 使用方式

maven-shade-plugin需要与maven生命周期中的package阶段绑定，在执行mvn package动作时会自动执行本插件。

```xml
 <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>3.2.4</version>
                <configuration>
                    <!--指定jar包运行主类-->
                    <transformers>
                        <transformer
                                implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                            <mainClass>com.boranget.oexsd.Oexsder</mainClass>
                        </transformer>
                    </transformers>
                </configuration>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
```

# 排除依赖

```xml
<configuration>
    <artifactSet>
        <excludes>
            <exclude>classworlds:classworlds</exclude>
            <exclude>junit:junit</exclude>
            <exclude>jmock:*</exclude>
            <exclude>*:xml-apis</exclude>
            <exclude>org.apache.maven:lib:tests</exclude>
            <exclude>log4j:log4j:jar:</exclude>
        </excludes>
    </artifactSet>
</configuration>
```

# filter包含和排除

```xml
<configuration>
    <filters>
        <filter>
            <artifact>junit:junit</artifact>
            <includes>
                <include>junit/framework/**</include>
                <include>org/junit/**</include>
            </includes>
            <excludes>
                <exclude>org/junit/experimental/**</exclude>
                <exclude>org/junit/runners/**</exclude>
            </excludes>
        </filter>
        <filter>
            <artifact>*:*</artifact>
            <excludes>
                <exclude>META-INF/*.SF</exclude>
                <exclude>META-INF/*.DSA</exclude>
                <exclude>META-INF/*.RSA</exclude>
            </excludes>
        </filter>
    </filters>
</configuration>

```

# 自动排除依赖

慎用，实际使用中发现会去掉依赖中的一些配置文件，但效果确实好，直接减了一半的大小

```xml
<configuration>
    <minimizeJar>true</minimizeJar>
</configuration>
```

# 重定位依赖

shade的原理是将jar包中的内容脱出来作为文件夹加入jar包中，如果最终的jar包被其他单独项目所依赖，直接引用此jar包可能会导致依赖冲突，shade可以通过重定位，将指定依赖移动到新的package中

```xml
<configuration>
    <relocations>
        <relocation>
            <!--原始包名-->
            <pattern>org.codehaus.plexus.util</pattern>
			<!--shade之后的包名-->
            <shadedPattern>org.shaded.plexus.util</shadedPattern>
            <!--原始包中不需要重定向的类-->
            <excludes>
                <exclude>org.codehaus.plexus.util.xml.Xpp3Dom</exclude>
                <exclude>org.codehaus.plexus.util.xml.pull.*</exclude>
            </excludes>
        </relocation>
    </relocations>
</configuration>
```

也可以通过include直接指定

```xml
<project>
    ...
    <relocation>
        <pattern>org.codehaus.plexus.util</pattern>
        <shadedPattern>org.shaded.plexus.util</shadedPattern>
        <includes>
            <include>org.codehaud.plexus.util.io.*</include>
        </includes>
    </relocation>
    ...
</project>
```

# 生成可执行jar

```xml
<project>
    ...
    <configuration>
        <transformers>
            <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                <!--指定主类-->
                <mainClass>org.sonatype.haven.HavenCli</mainClass>
            </transformer>
        </transformers>
    </configuration>
    ...
</project>
```

# 只是要打包所有依赖但不要求为可执行

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-shade-plugin</artifactId>
            <version>3.2.4</version>
            <configuration>
            </configuration>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>shade</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

