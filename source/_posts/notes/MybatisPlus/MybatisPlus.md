---
title: MybatisPlus
date: 2023-12-09 10:35:19
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

# MapperScan注解非必须

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