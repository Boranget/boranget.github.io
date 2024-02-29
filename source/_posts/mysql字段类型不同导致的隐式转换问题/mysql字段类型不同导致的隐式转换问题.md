---
title: mysql字段类型不同导致的隐式转换问题
date: 2024-02-28 09:35:19
updated: 2024-2-28 16:35:19
tags:
  - mysql
  - 隐式转换
categories:
  - notes
---

# 参考资料

[MySQL :: MySQL 8.0 Reference Manual :: 14.3 Type Conversion in Expression Evaluation](https://dev.mysql.com/doc/refman/8.0/en/type-conversion.html)

[MySQL 避坑指南之隐式数据类型转换_mysql隐式转换整数转浮点数-CSDN博客](https://blog.csdn.net/horses/article/details/118120395)

[MySQL隐式转化整理 - Rollen Holt - 博客园 (cnblogs.com)](https://www.cnblogs.com/rollenholt/p/5442825.html)

# 场景

当两个字段类型不同，但要对他们进行运算，则会隐式的对其进行转换

文档原文：

- If one or both arguments are `NULL`, the result of the comparison is `NULL`, except for the `NULL`-safe [`<=>`](https://dev.mysql.com/doc/refman/8.0/en/comparison-operators.html#operator_equal-to) equality comparison operator. For `NULL <=> NULL`, the result is true. No conversion is needed.

    有一方类型为NULL，结果即为NULL，除非是太空船运算，NULL \<=\> NULL结果为true

- If both arguments in a comparison operation are strings, they are compared as strings.

- If both arguments are integers, they are compared as integers.

- Hexadecimal values are treated as binary strings if not compared to a number.

    如果十六进制不与数字比较，则将其视为二进制字符串

- If one of the arguments is a [`TIMESTAMP`](https://dev.mysql.com/doc/refman/8.0/en/datetime.html) or [`DATETIME`](https://dev.mysql.com/doc/refman/8.0/en/datetime.html) column and the other argument is a constant, the constant is converted to a timestamp before the comparison is performed. This is done to be more ODBC-friendly. This is not done for the arguments to [`IN()`](https://dev.mysql.com/doc/refman/8.0/en/comparison-operators.html#operator_in). To be safe, always use complete datetime, date, or time strings when doing comparisons. For example, to achieve best results when using [`BETWEEN`](https://dev.mysql.com/doc/refman/8.0/en/comparison-operators.html#operator_between) with date or time values, use [`CAST()`](https://dev.mysql.com/doc/refman/8.0/en/cast-functions.html#function_cast) to explicitly convert the values to the desired data type.

    A single-row subquery from a table or tables is not considered a constant. For example, if a subquery returns an integer to be compared to a [`DATETIME`](https://dev.mysql.com/doc/refman/8.0/en/datetime.html) value, the comparison is done as two integers. The integer is not converted to a temporal value. To compare the operands as [`DATETIME`](https://dev.mysql.com/doc/refman/8.0/en/datetime.html) values, use [`CAST()`](https://dev.mysql.com/doc/refman/8.0/en/cast-functions.html#function_cast) to explicitly convert the subquery value to [`DATETIME`](https://dev.mysql.com/doc/refman/8.0/en/datetime.html).

    当datetime与一个常量比较，会将该常量转为时间戳比较，当datetime与一个子查询结果进行比较，则会将datetime转为数值型

- If one of the arguments is a decimal value, comparison depends on the other argument. The arguments are compared as decimal values if the other argument is a decimal or integer value, or as floating-point values if the other argument is a floating-point value.

    如果一个参数为精确数字类型（decimal），比较的方法取决于另一个参数的类型。如果另一个参数是精确数字或者整数类型，使用精确数字比较；如果另一个参数是浮点数类型，使用浮点数比较。

- In all other cases, the arguments are compared as floating-point (double-precision) numbers. For example, a comparison of string and numeric operands takes place as a comparison of floating-point numbers.

    其他情况都转为浮点数进行比较

# 案例

开发中碰到的问题是，一个表a的id是使用bigint类型，关联表b的外键id使用了varchar类型，在进行连接时，出现了b表中的多条记录都可以与a表中的一条记录匹配。状况好似b表中多条记录的id都相同。其实原因是当在使用a表中的bigint与b表中的varchar进行对比时，会将双方都转为浮点类型，而转为浮点类型后精度会有缺失，多条记录中的id前几位都是一样的，所以在精度缺失的浮点数作比较时，比较结果为相等。