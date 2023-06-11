---
title: JavaWebSession空指针异常
date: 2021-02-23 16:50:30
tags:
  - java入门
categories:
  - 经验
---

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210223184549743.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDgzMjkwOA==,size_16,color_FFFFFF,t_70)

单独调试的时候数据库可以连接，表也可以成功创建，但通过servelet访问时就会发生找不到数据库驱动类以及session空指针的问题，经过一下午调试，终于明白原来需要将jdbc驱动导入webinf中的lib中，而不是说仅仅导入项目就行。




# 遇到的其他问题：
	1. hibernate核心配置文件中，访问数据库的链接需要针对不同的数据库驱动
	sqlserver的数据库链接配置为：
	<property name="hibernate.connection.url">jdbc:sqlserver://localhost:1433;DatabaseName=webtest1</property>
	2. jsp中action填写servlet的url，而不是name