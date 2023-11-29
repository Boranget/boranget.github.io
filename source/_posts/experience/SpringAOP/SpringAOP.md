---
title: SpringAOP
date: 2023-04-22 10:35:19
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

