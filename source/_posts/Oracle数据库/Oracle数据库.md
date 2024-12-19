---
title: Oracle数据库
date: 2024-12-2 16:35:19
updated: 2024-12-2 16:35:19
tags:
  - Oracle数据库
categories:
  - notes
---

# 参考资料

# 模式

在oracle中，数据库名称作模式名，又称为表的拥有者

# 查找某个模式下所有的表

查找模式`SAPSR3DB`下名称中包含`LOG`的表

```
SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'SAPSR3DB' AND TABLE_NAME LIKE '%LOG%';
```

# 创建用户

1. 创建用户

    ` create user username identified by password;`

2. 授权connect

    `grant connect to username`

3. 授权特定表的select权限

    `GRANT SELECT ON SCHEMA_A.TABLE_NAME TO USER_A; `

# 分页

oracle中查出的数据会有一个序号，可通过该序号来进行分页，oracle中没有limit

```sql
# 取第一条
SELECT * FROM BC_MSG_LOG where rownum = 1
```

