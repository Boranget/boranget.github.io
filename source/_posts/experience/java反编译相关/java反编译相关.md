---
title: java反编译相关
date: 2023-06-27 16:50:30
tags:
  - java反编译
categories:
  - 经验
---

# 字符串replace问题

起因是当时在做一个系统升级的需求，当时由于新系统并不是向下兼容的，故需要反编译新系统的源码来适配旧系统中自定义的调用，结果在某个类的反编译结果中出现了一个很奇怪的现象。该段代码通过jd-gui反编译的结果如下：

```java
String a = "12";
a.replace(false, '1');
```

开始还以为是String还有我没见过的replace方法，结果查了一下确实不存在这个方法。那就根据之前的经验，猜测应该是原字符转成数字之后，jd-gui又转成布尔值了，而表示成布尔值之后为false的数，按理来说是0。于是使用java的命令行反编译工具javap，反编译结果如下

```powershell
javap -c -v Trace.class > Trace.txt
```

```
4: iconst_0
5: bipush        49
7: invokevirtual #3    // Method java/lang/String.replace:(CC)Ljava/lang/String;
```

果然是iconst_0，说明这里确实是塞了一个0进去，由于java是用Unicode来编码字符的，那么能作为0保存的字符，按理来说就是 '\\0' 了。

于是自己写了一个代码测试了一下：

```java
public abstract class Test {
    public static void main(String[] args) {
        String a = "12";
        a.replace('\0','1');
    }
}
```

该方法字节码如下

```
 0 ldc #2 <12>
 2 astore_1
 3 aload_1
 4 iconst_0
 5 bipush 49
 7 invokevirtual #3 <java/lang/String.replace : (CC)Ljava/lang/String;>
10 pop
11 return
```

果然，接着再次使用jd-gui打开class文件

![image-20230627141817068](java反编译相关/image-20230627141817068.png)

成功复现，证明了源代码这里确实应该是 '\\0'

# 编译jar包中的一个类

基本思路为将该类脱出来进行反编译后，再塞回jar包

那在编译该类时，便需要依赖该jar包，编译设置依赖的方法如下

```powershell
java -classpath ./test.jar Test.java
```

其中test.jar便是Test.class所属的jar包

若需要配置多个位置的类路径，中间用冒号分隔

```powershell
java -classpath ./lib:./test.jar Test.java
```

