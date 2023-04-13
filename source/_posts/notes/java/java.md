---
title: java
date: 2023-2-23 16:50:30
tags:
---

# 内部类相关

- 静态内部类可以在外部类外部实例化
- 非静态的内部类只能在外部类中实例化

需要外部实例化的需求比如Builder模式

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