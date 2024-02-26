---
title: Lombok
date: 2023-11-07 20:35:19
updated: 2024-02-19 10:35:19
tags:
  - Lombok
categories:
  - 笔记
---

# 安装

- 在idea插件市场找到lombok插件进行安装：Lombok

    新版idea会默认安装

- 在idea的设置中启用 enable annotation processing

    Build, Execution, Deployment > Compuler > Annoation Processors

    ![image-20231107202940311](Lombok/image-20231107202940311.png)

- 导入LomBok依赖

    ```xml
    <!-- https://mvnrepository.com/artifact/org.projectlombok/lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.18.30</version>
        <scope>provided</scope>
    </dependency>
    ```

    

# 构造器相关

- @AllArgsConstructor 全参数构造器
- @NoArgsConstructor 全参数构造器

# Getter与Setter

- @Getter
- @Setter

# equals

- @EqualsAndHashCode

# toString

- @ToString

## Data

相当于标记了Getter与Setter、equals以及toString

# Builder

Builder会生成一个内部类用于使用Builder模式，此时若当前类没有构造器，会自动生成一个全参数构造器，若已经指定了无参构造器，则需要手动通过编码或者lombok注解的方式添加一个全参构造器，建议同时添加全参和无参构造器

```java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("dir_table")
public class Directory {
    String id;
    String dirName;
    String dirType;
    String montID;
}
```

