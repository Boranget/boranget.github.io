---
title: Java百科（八股文）
date: 2023-06-05 16:50:30
updated: 2023-06-12 10:35:19
tags:
  - Java
categories:
  - notes
---

# 说点什么

”八股文“为大众所知是一种明清时代的考试题目格式，一种为应试而生的文体。而 Java八股文之所以叫也叫八股文，很大原因是因为其同样是为了应试而生的。

从来以为技术性的岗位面试中，应当是交流彼此的开发思想，谈论各自学习方法以及问题解决能力等，但现如今的Java面试，自从Java八股文出现之后，便成为了招聘者与应聘者的题库，招聘者从其中挑选出问题，而应聘者不管真实能力如何，只需要熟背Java八股文，便可以获得一份不错的工作。招聘方迅速从庞大的应聘者群体中筛选需要的人才，应聘者也需要在短时间的交流中展现自己的能力，这也是招聘方与应聘者都无可奈何的一件事。

我从来喜欢的学习方法为：先使用，再学习。这是因为在使用的过程中，可以碰到各种问题，这个时候再去找相关资料阅读，会对这个点有很深的印象。而如果先学习的话，很多时候都会不明就里，即使记住了，也不知道这个概念会在哪里用到，过不了一周便会忘记。故如果是为了应试而去背诵Java八股文，里面的很多知识点就算记住了，其实也不会对开发能力有多少提升。

然而，如果Java八股文褪去其”应试“的这层外衣，其本质上是一本很不错的Java百科。并且在开发者们源源不断的的补充下，知识愈发全面。在Java开发过程中如有突然想了解某一部分机制的原理时，也可以尝试翻阅所谓的”Java八股文“。因此比起所谓的”Java八股文“，我在此称呼其为”Java百科“。

笔者在参加校招时，并没有为了应聘而去背诵Java八股文。由于并没有在开发过程中碰到过”八股文“中的那些机制原理，以至于我在阅读时无法理解，而缺失理解的背诵，也就是死记硬背，于我来说是一种很痛苦的事情。而终于参加工作一年后的现在，在我开发能力达到一定程度的情况下，我决定开始对其进行整理。

# 资料来源

本部分为笔者在整理时主要参照的资料来源，本文会在参照的基础上，加入自己的经验和理解，并对其中一些错误进行修改。

[进大厂必备的Java八股文大全（2022最强精简易懂版，八股文中的八股文）备战秋招，赶快转发收藏起来吧~ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/550628155)

[说说双重检查加锁单例模式为什么两次判断？ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/402303950)

# 一、所谓Java基础

## 接口和抽象类的区别

1. 抽象类可以有构造方法，接口不可以

   在Java中，抽象类可以拥有构造方法，但并不能使用该构造方法来实例化抽象类的实例，正确的使用方法为在其子类实例化时去调用父类的构造方法。

   ```java
   class Person extends Animal{
       public Person(boolean isVirus) {
           super(isVirus);
       }
   }
   abstract class Animal{
       boolean isVirus;
       public Animal(boolean isVirus){
           this.isVirus = isVirus;
       }
   }
   ```

   这里涉及一个知识点：当一个类中没有声明构造函数时，系统会自动生成一个无参构造函数。而当类中声明了构造函数，不管有参无参，系统都将不会为其自动生成无参构造函数，所以当一个类中只声明了有参构造函数后，该类便会失去无参构造器。而在子类继承父类时，若父类中没有有参构造器，则子类必须声明一个构造器，并在其中调用父类的有参构造器。

   ```java
   class Person extends Animal{
       public Person() {
           super(false);
       }
   }
   abstract class Animal{
       boolean isVirus;
       public Animal(boolean isVirus){
           this.isVirus = isVirus;
       }
   }
   ```

   这是因为，系统在实例化一个对象时，会先调用其父类的构造器来初始化父类属性，默认是空参构造器。而当父类没有无参构造器时，系统不知道该调用哪个构造器，所以必须显式指定。

2. 抽象类可以有抽象方法和各种具体方法，可以理解为添加了抽象方法、无法实例化的类，接口可以有抽象方法和默认实现（1.8 default）方法。java 1.9接口中可以定义私有方法，可供default调用

   抽象类和接口都可以有静态方法。

3. 接口中只能存在类常量属性（public static final）

## 重载和重写的区别

重载就是同一个类中的同名不同参，修饰符，返回值等无关

重写就是父子类的同参同名覆盖，且子类权限要大于或等于父类，抛出的异常范围要小于父类方法，final和private方法不可被重写，其中final方法重写代码编译会报错，private方法由于是在父类中私有的，故子类中定义同名的私有方法是允许的，但不被视作重写。静态方法就没有重写这么一个概念，因为静态方法是和类绑定在一起的。

## ==和equals的区别

== 的作用是比较基本类型的值和引用类型的地址

而equals在不重写的情况下，是object中的定义

```java
    public boolean equals(Object obj) {
        return (this == obj);
    }
```

可以看出equals在不重写的情况下，功能与==是相同的。

**字符串错觉**

我自己瞎编的概念，指的是当给两个字符串用==比较时会出现true的情况，这时因为Java底层的字符串常量池的原因：Java字符串常量池为了减小字符串内存占用会有一个相同内容的字符串默认不会重复创建对象的机制，故他们的地址确实是相同的。

```java
 String a = "a";
 String b = "a";
 // true
 System.out.println(a==b);
 String c = new String("a");
 // false
 System.out.println(a==c);
```

## 异常处理机制

1. try 检测范围，catch 异常处理，finally 收尾工作 
2. throws 声明本方法可能会抛出的异常
3. throw 手动生成一个异常

## HashMap原理

高效率的HashMap自然是线程不安全的

- 1.8之前，HashMap底层是采取数组+链表的方式存储节点，在调用狗寒函数实例化hashMap的过程中，底层会创建一个长度为16的一维数组Entry[] table，在put的操作中，首先会调用key的类型的hashCode方法计算key的hash值，将该值进行移位处理，得到在entry数组中存放的下标，若该位置无数据，则插入成功，若该位置有数据
  - 若已存在数据与插入数据的hash值不同，则添加到链表上
  - 若hash值相同，则比较equals，若equals不同，则添加到列表是，若equals相同，说明是同一个key，将原来的值替换为新值。

- 1.8开始，采用数组+链表+红黑树的方式存储节点，此外：

  - 在new HashMap时，底层不会主动创建数组
  - 数组元素改为Node类，而非Entry类
  - 首次调用put时，会进行数组的初始化
  - 当数组某一索引位置上的元素以链表形式存在的数据个数>8且当前数组长度>64，此时会将该索引上的数据改为红黑树存储

  

扩容方式默认为扩容到原来的2倍，并将原有数据复制过来，会根据扩容因子和当前数组长度计算数组承载力，超过承载能力则会提前扩容，不会等到数组已满，扩容因子默认为0.75

## 线程安全HashMap

- ConcurrentHashMap
- HashTable
- Collections.synchronizedMap(map)

## ConcurrentHashMap保证线程安全

- 1.7 使用分段锁，将一个Map分为16段，每次操作只对其中一段加锁

- 1.8使用CAS和synchronized

  - CAS：compare and swap，是一个在UnSafe类中的本地方法。第一个参数是数据结构，第二个参数为下标，第三个为旧值，第四个为新值

    ```
    public final native boolean compareAndSwapObject(Object var1, long var2, Object var4, Object var5);
    ```

## HashTable与HashMap区别

- HashTable是线程安全的
- HashTable的Key不允许为null
- HashTable底层使用数组加链表

## ArrayList与LinkedList区别

ArrayList底层使用数组存放，linkedList底层使用链表

故其有着数组和链表的优缺点：

数组：由于下标的存在，方便查找，但不方便插入删除。且数组大小是固定的，所以需要扩容机制。

链表：链表无需扩容，方便插入和删除，但是不方便查找。

## 保证ArrayList线程安全

- Collections.synchronizedList(list)
- 使用Vector，Vector底层与ArrayLIst相同但是每个方法都被synchronized修饰
- 使用CopyOnWriteArrayList，读时不加锁，写时将源List复制一份（添加的话会将数组大小+1），将新数据写入，然后将List指针指向副本。这样的操作是不会影响读操作

## String，StringBuilder，StringBuffer

都是使用数组实现，区别在于，每次使用String进行运算时，都会创建新的String对象，而使用StringBuilder或StringBuffer只是会向数组中添加内容，数组不够会扩容。所以如果有对字符串进行大量拼接时适合用StringBuilder或StringBuffer。

至于StringBuilder和StringBuffer的区别：StringBuffer是线程安全的，其中使用了synchronized关键字。

# 二、Java多线程

## 进程和线程

进程：系统运行的基本单位，可包含多个线程，掌握程序运行所需要的资源。

线程：系统运行的最小单位，只拥有很少的资源，同一进程的多个线程共享该进程的资源。

## 线程的上下文切换

当切换到另一个线程运行时，需要恢复该线程的运行环境

## 死锁

多个线程由于持有对方所需的资源但又不放弃而造成的永久等待

## 死锁的必要条件

- 互斥条件：某资源同时只能被一个线程获取
- 不可抢占：一个线程不能强行剥夺另一个线程的资源
- 请求和保持：吃着碗里的看着锅里的（请求其他资源的同时不放弃手中的资源）
- 循环等待条件：形成等待资源的闭环

只要其中一个条件不满足，就无法形成死锁

## synchronized 与 lock 的区别

- synchronized是关键字，lock是Lock类的方法

- synchronized在发生异常时会自动释放锁，lock不会，所以建议在finally块中执行unlock释放锁

- synchronized是可重入锁、非公平锁、不可中断锁；lock是可重入锁、可中断锁、可以是公平锁

  公平锁是指获取锁的顺序为申请锁的顺序。非公平锁会尝试抢占锁

  可中断锁是指在尝试获取的过程中可以放弃获取

## sleep和wait的区别

- wait是Object的方法，sleep是Thread的方法
- wait会释放锁，sleep不会释放锁
- wait要在同步方法或者同步代码块中执行，sleep没有限制
- wait要调用notify或notifyAll唤醒，sleep自动唤醒

## yield和join区别

yield调用后线程进入就绪状态（只要获取时间片就可继续执行）

A线程调用B线程的join，则B执行完前A进入阻塞状态

## 线程池参数

核心线程数：线程池中的常驻线程数量

阻塞队列：当核心线程满后，后面来的任务都进入阻塞队列

最大线程数：当阻塞队列满了之后，将会逐个增长线程数量，直到达到最大线程数

最大线程存活时间：当阻塞队列的任务执行完后，最大线程的存活时间。超时回收

最大线程的存活时间单位：顾名思义

线程工程：用于生产线程

## 任务拒绝策略

阻塞队列满后，拒绝任务策略

- 抛异常
- 丢弃任务不抛异常
- 打回任务
- 尝试与最老的线程竞争

## 保证并发安全的三大特性

- 原子性：线程执行是连续的
- 可见性：一个线程修改的变量其他线程会立刻知道
- 有序性：jvm对指令的优化会让指令执行顺序改变，有序性禁止重排

## Volatile

不能用来修饰局部变量，可保证变量的可见性和有序性，在变量修改后会立即同步到主存中，且每次使用这个变量前先回从主存中获取最新值

双重校验锁会使用到volatile关键字来禁止指令重排，至于为什么会用双重校验来实现单例模式，是为了提高效率

```java
public class Singleton {
    private static volatile Singleton instance;

    private Singleton() {}
	// 进入get方法无需竞争锁
    public static Singleton getInstance() {
        if (instance == null) {
            // 只有实例未初始化才需要
            synchronized (Singleton.class) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

singleton = new Singleton() 这句话可以分为三步：

1. 为 singleton 分配内存空间；
2. 初始化 singleton；
3. 将 singleton 指向分配的内存空间。

但是由于JVM具有指令重排的特性，执行顺序有可能变成 1-3-2。指令重排在单线程下不会出现问题，但是在多线程下会导致一个线程获得一个未初始化的实例。例如：线程T1执行了1和3，此时T2调用 getInstance() 后发现 singleton 不为空，因此返回 singleton， 但是此时的 singleton 还没有被初始化。

使用 volatile 会禁止JVM指令重排，从而保证在多线程下也能正常执行。

## 线程构造方式

- 继承Thread类
- 实现Runnable接口
- 使用Callable接口，可以抛出异常和返回值

## ThreadLocal

注意内存泄漏问题

## CAS

Compare And Swap

更新时会先比较和之前记录的值是否相同，相同则更改，否则放弃修改

- ABA 问题：如果一个线程t1正修改共享变量的值A，但还没修改，此时另一个线程t2获取到CPU时间片，将共享变量的值A修改为B，然后又修改为A，此时线程t1检查发现共享变量的值没有发生变化，但是实际上却变化了。
  **解决办法：** 使用版本号，在变量前面追加上版本号，每次变量更新的时候把版本号加1，那么A－B－A 就会变成1A-2B-3A。

## 偏向级锁-重量级锁

synchronize通过对象头的markword来表明监视器的，监视器本质是依赖操作系统的互斥锁实现的。操作系统实现线程切换要从用户态切换为核心态，成本很高，此时这种锁叫重量级锁。

在JDK1.6以后引入了偏向锁、轻量级锁、重量级锁

- 当只有一个线程访问某一同步代码块时，此时该锁为偏向级锁，只是为了线程多次执行某一代码块的效率，避免重复申请锁
- 当两个线程竞争同一个锁时，偏向级锁会升级为轻量级锁，此时当一个线程成功获取锁时，另一个线程会尝试通过自旋来获取锁，但不会阻塞
- 当自旋获取锁失败时，轻量级锁会升级成为重量级锁，此时会使用操作系统底层的实现，此时所有来竞争锁的线程都会被阻塞

## JUC常用辅助类

- CountDownLatch：设定一个数，当调用CountDown时数量减一，调用await时会判断计数器是否清零，若清零则向下执行，否则继续阻塞。
- CyclicBarrier：设定一个数,当调用await() 时判断计数器是否达到目标值，未达到就阻塞，直到计数器达到目标值
- Semaphore：设定一个信号量，当调用acquire()时判断是否还有信号，有就信号量减一线程继续执行，没有就阻塞等待其他线程释放信号量，当调用release()时释放信号量，唤醒阻塞线程