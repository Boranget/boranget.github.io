---
title: design_pattern
date: 2022-12-27 16:50:30
tags:
  - 设计模式
categories:
  - 笔记
---

# 参考资料

资料来自于《图解设计模式》

# UML

![image-20221213223551413](design_pattern/image-20221213223551413.png)

# Iterator模式

Interator对象中引用了容器对象，最基本的实现为next和hasNext

- next

  获取当前对象并将指针向后移动

- hasNext

  判断当前指针是否越界，通常用于循环的结束条件判断

q: 为何要引入iterator模式，如果只是数组，明明直接使用for循环语句遍历

a：引入itreator模式后可以将遍历与实现分离

## 相关角色

- Iterator

  负责定义按顺序逐个遍历元素的接口，定义了next与hasNext方法

- ConcreteIterator

  迭代器具体的实现，实现了next和hasNext方法

- Aggregate

  定义容器API，定义了iterator方法用于获取迭代器

- ConcerteAggregate

  容器具体的实现，实现了iterator方法

# Adapter模式

又被称为Wrapper模式

现有程序无法使用，需要做适当的变换之后才能使用的情况，构造一个类，用于填补现有程序与目标程序之间的差异的设计模式

## 类适配器模式（继承）

继承提供功能的类并实现目标接口，通过调用父类中的方法来实现接口中的功能。

## 对象适配器模式（委托）

不通过继承来调用功能提供类的方法，而是通过在类中维护一个功能提供类的实例，通过实例去调用

## 相关角色

- Target

  目标功能的定义

- Client

  只能使用Target中方法的调用者

- Adaptee

  提供原始功能的角色

- Adapter

  通过继承或引用Adaptee来实现Target定义的功能的角色

# Template Method模式

通过抽象类的定义，在父类中定义处理流程的框架，在子类中实现具体处理的模式

## 相关角色

- AbstractClass

  实现模板方法，并声明模板方法中使用到的抽象方法。这些方法由子类ConcreteClass进行具体的实现

- ConcreteClass

  实现父类中定义的抽象方法，以交由模板方法使用

# Factory Method模式

使用Template Method模式

## 相关角色

- Product

  产品，抽象类，定义接口

- Creator

  创建者，抽象类

- ConcreteProduct

  具体的产品，实现了Product中的抽象方法

- ConcreteCreator

  具体的创建者，负责生成具体的产品

# Singleton模式

只能生成一个实例

- 将构造函数私有化
- 静态方法提供当前类的实例

## 相关角色

- Singleton

  该角色中有一个返回唯一实例的静态方法，该方法每次调用都会返回同一个实例

## 其他

饿汉式、懒汉式等，懒汉式在多线程的情况下的双重验证机制

# Prototype模式

根据现有实例来生成新的实例

实现Cloneable接口，调用Object的clone方法克隆一个实例

## 相关角色

- Prototype

  定义复制实例的方法

- ConcretePrototype

  实现Prototype接口中的复制方法

- Client

  负责使用复制方法复制新的实例

## 其他

注意Object类中的clone方法是浅复制

# Builder模式

## 相关角色

- Builder

  负责定义生成实例的接口

- ConcreteBuilder

  实现Builder中定义的接口

- Director

  负责使用Builder来创建产品，具体的Builder通过参数传入

- Client

  使用Director来创建产品

## 其他

链式调用的builder：

```java
builder.name("jeck").age(13).build()
```





