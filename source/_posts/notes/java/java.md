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

# Optional

身为一个容器，将对象引用存入其中，用于缓解该引用为null时的报错，减少空指针异常产生的情况。

# 函数式接口

仅有一个抽象方法的接口，通常会添加@FunctionalInterface的注解

一般是供lambda表达式使用

```java
public class Test {
    public static void main(String[] args) {
        final int res = getRes((a, b) -> {
            return a * b;
        });
        System.out.println(res);
        final int res2 = getRes((a, b) -> {
            return a + b;
        });
        System.out.println(res2);

    }
    static int getRes(Fun f){
        int a = 2,b=3;
        return f.getRes(a,b);
    }
}
@FunctionalInterface
interface Fun{
    int getRes(int a, int b);
}
```

# 流式编程

将数据包装到stream中后使用Stream的一系列操作进行编程，优点是编程很丝滑，缺点是后期不方便阅读

## filter

进行数据筛选

```java
public static void main(String[] args) {
    List<String> l = new ArrayList();
    l.add("a");
    l.add("b");
    l.add("v");
    l.add("df");
    l.add("df");
    l.add("r");
    System.out.println(l);
    final List<String> a1 = l.stream().filter(a -> !a.equals("a")).collect(Collectors.toList());
    final Set<String> a2 = l.stream().filter(a -> !a.equals("a")).collect(Collectors.toSet());
    System.out.println(a1);
    System.out.println(a2);
}
```

## map

将一个集合映射成另一个集合

```java
 final List<String> collect = l.stream().map(a -> "[ " + a + " ]").collect(Collectors.toList());
```

## collect

流操作的结束操作，其结果为生成一个集合，生成list和set的方法如上，这里写一下生成map的方法。

```java
final Map<String, String> collect = l.stream().collect(Collectors.toMap(a -> a.substring(0,1), a -> a));
```

## match

同样的流操作的结束操作，结果为生成一个布尔值，判断原数据集是否满足某个要求

- anyMatch：判断的条件里，任意一个元素成功，返回true

- allMatch：判断条件里的元素，所有的都是，返回true

- noneMatch：与allMatch相反，判断条件里的元素，所有的都不是，返回true

```java
final boolean va = l.stream().anyMatch(a -> a.equals("va"));
```

## sort

使用流sort不会修改原集合，需要最后收集为一个新集合，如果使用Collections则会修改原集合。

```java
Collections.sort(l, (a, b) -> {
    if (a.length() != b.length()) {
        return a.length() - b.length();
    }
    for (int i = 0; i < Math.min(a.length(), b.length()); i++) {
        if (a.charAt(i) != b.charAt(i)) {
            return a.charAt(i) - b.charAt(i);
        }
    }
    return 0;
});
System.out.println(l);
final List<String> collect = l.stream().sorted((a, b) -> {
    if (a.length() != b.length()) {
        return a.length() - b.length();
    }
    for (int i = 0; i < Math.min(a.length(), b.length()); i++) {
        if (a.charAt(i) != b.charAt(i)) {
            return a.charAt(i) - b.charAt(i);
        }
    }
    return 0;
}).collect(Collectors.toList());
System.out.println(collect);
```

使用另一种lambda

```java
public static void main(String[] args) {
    List<String> l = new ArrayList();
    l.add("aa");
    l.add("ba");
    l.add("va");
    l.add("df");
    l.add("ra");
    System.out.println(l);
    Collections.sort(l,Test::sort);
    System.out.println(l);
    final List<String> collect = l.stream().sorted(Test::sort).collect(Collectors.toList());
    System.out.println(collect);
}
static int sort(String a, String b){
    if (a.length() != b.length()) {
        return a.length() - b.length();
    }
    for (int i = 0; i < Math.min(a.length(), b.length()); i++) {
        if (a.charAt(i) != b.charAt(i)) {
            return a.charAt(i) - b.charAt(i);
        }
    }
    return 0;
}
```

使用Comparator中带的比较器

```java
final List<String> collect = l.stream().sorted(Comparator.reverseOrder()).collect(Collectors.toList());
```

## findfirst...

寻找流中的第一个元素，返回一个Optional

## Collectors

收集器

- toList
- toMap
- 。。。
- join
    类似于js中数组的join

# Comparator

比较器

```java
Comparator.comparing(Student::getName); 
```

