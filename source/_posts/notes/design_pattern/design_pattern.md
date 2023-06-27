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

饿汉式、懒汉式等，其中懒汉式在多线程的情况下的双重验证机制，可提高获取已存在对象的效率

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

# Abstract Factory

易于增加具体的工厂，难以增加新的零件

## 相关角色

- AbstractProduct

  复制定义AbstractFactory角色所生成的抽象零件和产品的接口（API）

- AbstractFactory

  负责定义用于生成抽象产品的接口，其中固定了生产的产品类型

- Client 248 16 

  会调用AbstractFactory角色和AbstractProduct角色的接口（API）来进行工作，对于具体的零件、产品、工厂并不了解

- ConcreteProduct

  负责具体实现AbstractProduct角色的接口。

- ConcreteFactory

  负责实现AbstractFactory角色的接口

# Bridge

分离类的功能层次和实现层次，方便路两侧分别扩展

通过父类的构造方法将实例存放到父类的impl中，impl即为桥梁

````java
// Display为功能层的父类
// CountDisplay 为 功能层的扩展，继承Display
// DisplayImpl 为实现层的父类，被作为参数传入Display的构造方法
// StringDIsplay继承于DisplayImpl
Display d = new CountDisplay(new StringDisplay(""));
````

## 相关角色

- Abstraction

  该角色位于 “类的功能层次结构”最上层，使用Implementor角色的方法定义了基本的功能。Abstraction中有字段impl，用于保存Implementor角色的实例

- RefindedAbstraction

  在Abstraction的功能基础上新增了新的功能

- Implementor

  该角色位于 “类的实现层次结构的最上层”，定义了需要实现的API，同时该API会被Abstraction角色调用

- ConcreteImplemetnor

  该角色负责实现在Implementor角色中定义的接口

## 其他

- 感觉类似于枪和子弹的关系，枪为功能，子弹为具体实现，两侧都可以各自升级，枪可以增加功能或者威力，子弹可以采用不同的材质，但子弹的口径和枪的口径不变。总归是适配的。

- 继承是强关联，委托是若关联

# Strategy 模式

整体替换算法，算法可插拔

## 相关角色

- Strategy

  定义具体策略所需实现的功能

- ConcreteStrategy

  实现Strategy定义的接口，负责实现具体的策略

- Context

  负责使用不同的Strategy

## 其他

- 需要修改实现算法时，无需修改接口，只需新增具体的实现
- 通过委托关联可以很方便的替换整体算法
- 且由于算法以对象的形式存在，在程序运行时也可以很方便的替换算法

# Composite 模式

容器与内容的一致性，递归包含：文件夹

## 相关角色

- Component

  Leaf与Composite的父类，使其具有一致性

- Composite

  表示容器，其中可以存放Component角色

- Leaf

  表示内容，该角色中不能存放其他对象

- Client

  使用Composite的角色

## 其他

- 在文件夹逻辑的编写中，文件夹的add方法如果放在父类的中，方便的地方在于可以直接调用父类的add方法而不需要强制转型，但带来的需要处理的问题便是，文件中的add方法如何处理，或者说父类中的默认实现如何处理：

  - 父类中直接抛出异常
  - 父类中不做任何处理
  - 父类为抽象类，不实现该方法

  或者定义在文件夹类型中

# Decorator 模式

装饰边框与被装饰物的一致性：被装饰的对象还可以继续被装饰

## 相关角色

- Component

  增加功能的核心角色，定义了角色的API

- ConcreteComponent

  实现了Component定义的功能

- Decorator

  同样继承了Component，并且其内部保存了一个需要被装饰的Component角色

- ConcreteDecorator

  具体的Decorator角色

## 其他

- 接口的透明性

  由于被装饰物同时也是别的对象的装饰物，且被装饰物和装饰物拥有同样的接口，被装饰物的api并没有因为被包装而隐藏。

- 不改变装饰物，只需加一层便可增加功能
- 常见应用：java中的io数据流

# Visitor 模式

例如访问文件夹中的内容

## 相关角色

- Visitor

  对数据结构中每一个元素声明一个访问的visit方法

- ConcreteVisitor

  负责实现Visitor角色定义的接口，随着visit处理的进行，其内部的状态也会不断变化，比如当前的访问路径

- Element

  表示Visitor访问的对象，声明了接受访问的accept方法，accept方法接收的参数是Visitor角色

- ConcreteElement

  负责实现Element角色定义的接口

- ObjectStructure

  负责处理Element角色的集合

## 其他

至于为什么需要在被访问者中添加accept方法：如果直接使用visit方法而不使用accept

方法，会导致访问者对象与被访问对象紧密耦合，访问者对象必须知道被访问对象的节点类型。

- 双重分发

  ```java
  element.accept(visitor);
  visitor.visit(element)
  ```

  互相调用，共同决定实际的处理

- 易于增加ConcreteVisitor，但不易增加ConcreteElement角色，因为增加 了Element之后，需要在Visitor中新增处理方法visit(NewVisitor nv)
- accept 方法还可以挑选指定的信息进行暴露

# Chain of Responsibility

责任分派

## 相关角色

- Handler

  定义了处理请求的接口，Handler角色需要保存next指针指向下一个处理者，如果本身无法处理请求，则会将请求传递给下一个处理者

- ConcreteHandler

  具体的处理者

- Client

  请求者，发起请求的角色

## 其他

过滤器链比较类似于这个模式

# Facade 模式

窗口模式，屏蔽底层

- Facade

  向外暴露的窗口，屏蔽了底层的处理过程

- 构成系统的其他角色

  由Facade进行调用

- Client

  Client角色负责调用窗口

# Mediator 模式

使得各个组件之间可以互相通信，比如按钮和文本框之间的通信

集中处理，避免过多的通信路线

## 相关角色

- Mediator

  负责定义与Colleague进行通信和做出决定的接口

- ConcreteMediator

  负责实现Mediator接口，收集具体信息，做出实际决定

- Colleague

  负责定义与Mediator角色进行通信的接口

- ConcreteColleague

  负责实现Colleague角色的接口

# Observer 模式

观察者模式，观察对象的状态发生变化时会通知给观察者

## 相关角色

- Subject

  表示被观察对象，其中定义了注册观察者和删除观察者的方法，此外还声明了”获取当前状态“的方法

- ConcreteSubject

  具体实现被观察对象

- Observer

  负责接收来自Subject角色状态变化的通知，声明了update方法

- ConcreteObserver

  具体的观察者，当他的update方法被调用，会获取要观察的对象的最新状态

## 其他

有点反直觉的是，按理来说，应该是观察者主动去获取别的对象的状态，这样的话实现方式可能就是不断轮询。但实际上，是被观察者发生事件后主动去通知观察者的，类似于图形编程中的监听器。

比起观察者模式，发布-订阅模式这个名字更合适。

# Memento 模式

记录快照，撤销-重做-.....

## 相关角色

- Originator

  生成者，被拍照者。该角色会将自己当前状态生成为Memento角色。同时可以通过传入之前的Memento角色来恢复之前的状态

- Memento

  该角色会将Originator角色的内部信息保存。作为快照
  - wide interface

    用于恢复对象信息的方法，会暴露Memento角色的所有信息

  - narrow interface

    为外部角色提供的，用于获取少量必须信息的接口

- Caretaker

  负责通知Originator使其生成状态，同时保存该状态

# State 模式

当不同的状态下所执行的操作不同时，不是通过if来判断状态进行不同的操作，而是调用不同状态类下的方法。也就是说不同的操作是定义在不同的状态类中，而不是当前类的if块中。

若不想在当前类中判断状态，可以在各个状态类中去判断当前应该是什么状态，接着调用管理者的修改状态方法来切换状态。这样做的缺点是每个状态都需要知道其他的状态。可以通过状态迁移表来控制状态的流动

## 相关角色

- State

  表示状态，不同的状态要定义不同的接口，其中进行不同的处理

- ConcreteState

  表示各个具体的状态，它实现了State接口

- Context

  持有表示当前状态的ConcreteState角色，并使用不同状态类中的方法实现

# Flyweight 模式

将已经生成的实例保存并复用，避免产生重复实例

## 相关角色

- Flyweight

  实例会被复用的类

- FlyweightFactory

  创建并保存Flyweight的实例，同时在接收到获取实例请求时判断是否已经存在该实例并返回该实例。

- Client

  通过调用FlyweightFactory的方法来获取Flyweight角色

## 其他

类似于单例模式，或者枚举类型

# Proxy 模式

代理

## 相关角色

- Subject

  定义了接口，使Proxy角色和RealSubject角色具有一致性

- Proxy

  实现了Subject接口。会尽量处理来自Client的请求，当自身无法处理时，会调用RealSubject的方法来处理

- RealSubject

  实现罗Subject接口，会在Proxy无法完成任务时被Proxy创建并调用

- Client

  请求者

## 其他

作者说是为了提升处理速度，原因是将耗时操作在需要的时候再执行，但我认为完全可以通过懒加载来实现。

不过确实类似于HTTP代理，由于代理服务器会保存一份缓存，当代理服务器上有缓存时，代理服务器并不会取向目标服务器请求数据，而是会直接返回本地数据，当代理服务器上没有需要的缓存数据时，则会向目标服务器请求数据。

同时存在有很多代理模式

- Virtual Proxy

  当真正需要实例时才会创建和初始化实例

- Remote Proxy

  比如远程方法调用，调用者感觉不到调用的对象是否在本地

- Access Proxy

  在访问源实例时代理会判断是否有该权限

# Command 模式

将之前的操作作为command对象记录下来，便于撤销或重做

## 相关角色

- Command

  负责定义命令的接口，所有实现了本接口的类都会作为命令

- ConcreteCommand

  实现了Command接口

- Receiver
- Client
- Invoker

# Interpreter 模式

迷你语言，程序解析并运行

## 相关角色

- AbstractExpression

  定义了表达式共同的接口

- TerminalExpression

  终结符表达式

- NonterminalExpression

  非终结符表达式

- Context

  上下文

- Client

  调用表达式

