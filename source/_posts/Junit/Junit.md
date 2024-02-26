---
title: Junit
date: 2023-11-08 15:27:19
updated: 2023-11-25 10:35:19
tags:
  - Junit
categories:
  - 笔记
---

# 注解

- @Test
    - @Test(expected=XX.class) 预期出现的异常
    - @Test(timeout=) 设置超时时间
- @Ignore 修饰的测试方法会被测试运行器忽略
- @RunWith 更改测试运行器
- @BeforeClass 在@Test之前执行一次
- @BeforeMethod 在每次@Test之前都执行一次

# 测试API

- Assertions.assertEquals(表达式1，表达式2)，判断两个表达式的结果是否相同