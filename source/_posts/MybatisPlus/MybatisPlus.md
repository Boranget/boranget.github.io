---
title: MybatisPlus
date: 2023-12-09 10:35:19
updated: 2024-02-22 10:35:19
tags:
  - MybatisPlus
categories:
  - 笔记
---

# 通用mapper

可将自定义的mapper接口继承BaseMapper接口，其中封装了一些常用操作

# 通用Service

```cml
//自己写的service接口继承Iservice接口
public interface SysMenuService extends IService<SysMenu> {
}

//自己写的实现类继承Iservice接口的实现类
public class SysMenuServiceImpl extends ServiceImpl<SysMenuMapper,SysMenu> implements SysMenuService {}
```

# 主键生成

```java
@TableId(type = IdType.ASSIGN_ID) //默认是雪花算法
type = IdType.AUTO //数据库Id自增
```

# 日志配置

```yaml
//yml文件进行如下配置即可
mybatis-plus:
  configuration:
    # 打印mybatis-plus上的sql语句
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
```

# 报错Has been loaded by xml..

带plus的项目启动时报错：

![image-20231208151338761](MybatisPlus/image-20231208151338761.png)

原因：mapper映射文件出现了和mabatis-plus中自带的方法重名了，导致报错，修改名称即可。

# 实体类中添加数据库中不存在的字段

字段上添加@TableField(exist = false)注解

# 使用lamda表达式

```java
public UserEntity getUserByName(String username) {
    QueryWrapper<UserEntity> queryWrapper = new QueryWrapper<UserEntity>();
    queryWrapper.lambda().eq(x -> x.getUsername(), username);
    return this.getOne(queryWrapper);
}
```

# MapperScan

可在启动类或者其他配置类上添加mapperscan注解标明mapper扫描范围，或者直接在mapper接口上标注mapper注解

# mapper-location不能与mabytis共用

mybatis plus不能使用yml文件中mybatis的mapperlocation配置，但是mybatis可以使用mybatis plus的location配置。

# spring boot 使用mybatisplus

需要使用starter依赖，不能直接使用mybatisplus依赖，否则会报错绑定异常

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.5.3.1</version>
</dependency>
```

> org.apache.ibatis.binding.BindingException: Invalid bound statement (not found): com.example.springweb.mapper.RoleMapper.selectList

# Table注解

使用@TableName("dir_table")注解，将实体类绑定到数据库中的具体表上，不指定默认使用实体类名称去寻找表

```java
@Data
@Builder
@TableName("dir_table")
public class Directory {
    String id;
    String dirName;
    String dirType;
    String montID;
}
```

# mapper xml文件格式错误引起的报错

```
Caused by: org.xml.sax.SAXParseException; lineNumber: 2; columnNumber: 59; 文档根元素 "mapper" 必须匹配 DOCTYPE 根 "null"。
```

原因是xml中没有加约束

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
```

# 绑定异常

org.apache.ibatis.binding.BindingException: Invalid bound statement (not found):

检查是否在yaml文件中配置了mapper xml文件的位置，默认为resources下面的mapper文件夹，若不同则需手动指定

```yaml
# 配置mybatis规则
mybatis-plus:
  mapper-locations:  classpath:/mybatis/mapper/*.xml
```

同时检查是否配置了mapperscan或者在mapper类上加了@mapper注解

# UpdateWapper

mybatis-plus进行更新操作时可构造updateWapper，wapper上可指定查询条件以及更新动作

```java
LambdaUpdateWrapper<PrintProduct> registeredWrapper = new LambdaUpdateWrapper<>();
registeredWrapper.eq(PrintProduct::getWbsNumber,printRegisterSaveReqVo.getWbsNumber())
    .set(PrintProduct::getRegistered,true);
printProductMapper.update(registeredWrapper);
```

