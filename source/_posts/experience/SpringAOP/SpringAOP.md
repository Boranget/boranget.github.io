---
title: SpringAOP
date: 2023-11-29 13:35:19
tags:
  - SpringAOP
categories:
  - 经验
---

# SpringAOP的原理

根据需要代理的目标对象的类型，SpringAOP会选择不同的代理方式生成代理类。

如果目标对象是一个Java接口，Spring会使用Java动态代理（反射）来生产代理类，如果目标对象是一个普通的java类，而不是接口，Spring会使用CGLib代理来生成代理类，CGLib是一种基于字节码的代理模式。

spring创建代理类后，会替换掉原先的对象引用，这样在调用目标增强方法时就会被增强。

# SpringAOP调用本类中增强方法不生效

如果某个类中，一个方法A是增强方法，同样在本类中的另一个方法B在调用A的时候并不会触发增强，因为增强的原理是替换掉对象引用，但在同一个类中的直接引用是通过this指针调用的，不会调用到被增强的代理类中的A方法。

解决方法：

使用当前类的被代理类执行A方法

-  AopContext.currentProxy()

    ```java
    public void B() {
        System.out.println("method B");
        ((Son) AopContext.currentProxy()).A();
    }
    ```

- applicationContext.getBean()

    ```java
    @Autowired
    private ApplicationContext applicationContext;
    ((Son) applicationContext.getBean(Son.class)).A();
    ```

# 代理对象注入实现类而不是接口对象报错

这是因为在spring代理一个类A时，如果发现该类实现了某个接口AI，则会创建一个代理类C去实现那个接口AI，创建出的这个代理类C与原类A没有继承关系，故在使用时，如果是注入给一个A的对象，由于C和A没有继承关系，就会报错。

解决办法：

1. 将接收的对象由A类型转为AI类型，AI类型与C是有继承关系的
2. 或者去掉A对AI的实现关系，这样spring在代理A类时，就不会去创建一个实现了AI的代理类，而是会创建一个A的子类

