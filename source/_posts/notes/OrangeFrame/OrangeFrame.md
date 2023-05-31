---
title: OrangeFrame
date: 2022-02-01 16:50:30
tags:
  - java frame
categories:
  - 笔记
---

# 系统结构

## parent

依赖版本管理

## auth

进行认证

- 用户名密码匹配
- 账户失效判断
- 将用户角色存入redis

## common

- 公用工具类
- 共用实体类

除此之外还有自动配置等

## gateway

网关，进行鉴权

## rbac

进行rbac信息的增删改查

# 数据结构设计

## RBAC

### user

- 数据库中字段
  - id
  - username
  - password
  - enabled
  - account_non_expired
  - account_non_locked
  - credentials_non_expired
- 实体类中字段
  - roleList 角色列表

### role

// 从redis中查看当前角色中有无当前api,若无,则查看有无parent,递归查找,都没有则返回false

**关于角色递归**

使用递归形式的角色保存可以减少后期查询次数，但如果派生角色和基础角色都为递归形式，则会出现无限递归的情况。

例如，b为a的派生角色，则a的派生列表中是有b的，但b的基础角色中又会存在a，如此便会形成递归,造成溢出. 故这两个列表中只能有一个是递归的形式。

经过考虑，将基础角色做递归处理，派生角色不做，因为基础角色也属于是当前角色的一个身份，是比较重要的，而派生角色的行为对当前角色并无影响，所以派生角色不做递归处理。

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybais.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.orange.mapper.OrangeRoleMapper">

    <resultMap id="RoleResultMap" type="com.orange.eneity.OrangeRole">
        <id column="id" property="id"/>
        <result column="name" property="name"/>
        <result column="desc" property="desc"/>
        <collection property="derivedRoleList"
                    ofType="com.orange.eneity.OrangeRole"
                    select="selectDerivedRoleList"
                    column="id"
        />
        <collection property="baseRoleList"
                    ofType="com.orange.eneity.OrangeRole"
                    select="selectBaseRoleList"
                    column="id"
        />
    </resultMap>
    <select id="selectRoleByRoleName" resultMap="RoleResultMap">
        select `id`, `name`, `desc`
        from role
        where name = #{roleName}
    </select>
    <!--这里使用type而不使用type是为了防止递归-->
    <select id="selectDerivedRoleList" resultType="com.orange.eneity.OrangeRole">
        select r2.*
        from role r1
                 LEFT JOIN role_role rr on r1.id = rr.base_role_id
                 LEFT JOIN role r2 on rr.derived_role_id = r2.id
        WHERE r1.id = #{id}
    </select>
    <!--这里使用map进行递归处理-->
    <select id="selectBaseRoleList" resultMap="RoleResultMap">
        select r1.*
        from role r1
                 LEFT JOIN role_role rr on r1.id = rr.base_role_id
                 LEFT JOIN role r2 on rr.derived_role_id = r2.id
        WHERE r2.id = #{id}
    </select>
</mapper>
```



- 数据库中字段
  - id
  - name
  - desc
- 实体类中字段
  - derivedRoleList 派生角色列表
  - BaseRoleList 基础角色列表
  - menuList 菜单列表,对多,表示当前角色可访问的menu
  - apiList 接口列表,对多,表示当前角色可访问的api



### menu

- 数据库字段
  - id
  - name
  - permission 权限标识
  - pattern 绑定的地址
  - parent 父级菜单
  - sort 排序字段
  - desc 描述
- 实体类字段
  - subMenuList 子菜单

### api

- 数据库字段
  - id
  - name
  - permission 权限标识
  - pattern 绑定的地址
  - desc 描述

### 一些关联表

user-role， role-role， role-menu， role-api

# 一些逻辑设计

## 用户登录

用户登录时，将用户信息存入redis，这里主要需要将role给封装进user中，包括role的基角色和派生角色

这里的基角色是递归的，便于查询其所有权限

将 api-role 对应关系存入redis，便于鉴权: {

​	当请求走到网关时, 根据请求所带的token查找该token所拥有的角色,

​	根据api-role对应关系列出访问该api所需的role

​	判断该用户有无所需role,若有则放行.

​	判断是深入判断其基角色

}

## 网关

**判断token是否合法**

- 存在
- 未过期

