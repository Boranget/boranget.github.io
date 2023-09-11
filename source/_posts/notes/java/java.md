---
title: java
date: 2023-2-23 16:50:30
tags:
  - java基础
categories:
  - 笔记
---

# 内部类相关

- 静态内部类可以在除外部类以外的类中实例化，比如Builder模式
- 非静态的内部类只能在外部类中实例化，且只能在非静态方法中实例化
- 内部接口默认都是静态的且必须是静态的

## 匿名内部类和局部变量的关系

简单地说，匿名内部类可能会比它所在的方法的存活时间还长，这样的话，他想要调用的局部变量会因为方法的结束出栈而消失，则会出现问题，故如果需要使用局部变量，需要是final的（如果不是final，编译器在编译的时候会变为final，如果在匿名内部类使用之后对该变量做修改，则编译不通过），这样匿名内部类会复制一份改局部变量与自己共同存活。

# Builder模式

```java
public class OtherTest {
    public static void main(String[] args) {
        A.ABuilder aBuilder = new A.ABuilder();
        A jeck = aBuilder.age(11).name("jeck").build();
        System.out.println(jeck);
    }
}

class A {
    private int age;
    private String name;
    private A() {

    }
    private A(int age, String name) {
        this.age = age;
        this.name = name;
    }

    @Override
    public String toString() {
        return "A{" +
                "age=" + age +
                ", name='" + name + '\'' +
                '}';
    }

  
    public static final class ABuilder {
        private int age;
        private String name;

        public ABuilder age(int age) {
            this.age = age;
            return this;
        }

        public ABuilder name(String name) {
            this.name = name;
            return this;
        }

        public A build() {
            return new A(this.age, this.name);
        }

    }
}

```

# 反射相关

## 获取私有构造器生成实例

```java
/**
 * @author boranget
 * @date 2023/2/23
 * 注意私有的构造器需要通过 getDeclaredConstructor方法获取
 * 且需要设置访问权限之后才能生成实例
 */
public class OtherTest {
    public static void main(String[] args) {
        Class<A> aClass = A.class;
        A a = null;
        Constructor<A> constructor = null;
        try {
            constructor = aClass.getDeclaredConstructor(int.class, String.class);
            constructor.setAccessible(true);
            A jeck = constructor.newInstance(11, "jeck");
            System.out.println(jeck);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }


    }
}

class A {
    private int age;
    private String name;

    private A() {

    }

    private A(int age, String name) {
        this.age = age;
        this.name = name;
    }

    @Override
    public String toString() {
        return "A{" +
                "age=" + age +
                ", name='" + name + '\'' +
                '}';
    }
}
```

