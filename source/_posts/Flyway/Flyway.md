---
title: Flyway
date: 2025-09-21 12:35:19
updated: 2025-09-21 12:35:19
tags:
  - Flyway
categories:
  - 笔记
---

# 参考资料

# 简述

Flyway 是一款数据库版本管理工具，可对数据库变更（建表、加字段、初始化数据等）进行版本化管理，确保开发、测试、生产等多环境数据库结构一致。

# 相关概念

## 数据库变更

指对数据库结构或数据的任何修改，分为两类：

- **结构变更**：建表、删表、加字段、改字段类型、建索引、加外键等；
- **数据变更**：初始化基础数据（如管理员账号）、批量修复错误数据等。

### 数据库升级脚本

记录数据库变更的可执行 SQL 文件，例如：
`V1__create_user_table.sql`：创建用户表；
`V2__add_age_column.sql`：给用户表加年龄字段；
`V3__init_admin_user.sql`：初始化管理员数据。

注意升级脚本不可在部署后二次修改，否则flyway会报错

# spring使用flyway

```xml
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>
```

脚本需放在固定目录：`src/main/resources/db/migration`；
命名必须遵循规则：`V<版本号>__<描述>.sql`。

启动应用时，Fly会自动执行之前没有执行过的脚本，且按版本号执行

# 无需使用Flyway

- 极小项目 / 原型开发：数据库结构基本不变，手动改 1-2 次即可；
- 单人开发项目：无协作同步问题，手动管理脚本成本更低；

# 回滚

付费版功能

编辑脚本，执行相关的逻辑，在命名上对应之前的升级脚本，内容上需要自己手动编辑对应的逻辑