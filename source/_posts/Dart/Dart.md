---
title: Dart
date: 2025-12-20 10:35:19
updated: 2025-12-20 10:35:19
tags:
  - Dart
categories:
  - 笔记
---

# 参考资料

[踩坑(已解决)：Windows系统Dart SDK下载安装与使用_安装 dart 提示连接服务器失败-CSDN博客](https://blog.csdn.net/weixin_49256675/article/details/113817934)

[Dart SDK archive](https://dart.dev/get-dart/archive)

# 配置环境

flutter自带dart环境

# 基础

## 语法

使用var进行变量声明

使用const进行常量声明（编译时常量）

使用final进行常量声明（运行时常量）

### 基本类型：

String，且可使用反引号定义模板字符串

```dart
String a = "a";
String b = `a${name}or${1+1}`
```

数值

```
int
// 可整可浮
num
double
三者之间可通过各自的方法转换
```

布尔

```
bool a = true
```

列表

```
List students = ["a","b"]
有各种方法可当作容器使用
在尾部添加 - add (内容)
在尾部添加一个列表 - addAll (列表)
删除满足内容的第一个 - remove (内容)
删除最后一个 - removeLast ()
删除索引范围内数据 - removeRange (start,end)
注意:end 不包含在删除范围内
循环 - forEach ((item){});
是否都满足条件 - every ((item){return 布尔值});
筛选出满足条件的数据 - where ((item){return 布尔值});
列表的长度 (属性)-length
最后一个元素 (属性)-last
第一个元素 (属性)-first
是否为空 (属性)-isEmpty
```

Map

```
Map zd = {"a":"av","b":"bv"}
var x = zd["a"]
循环-forEach
在添加一个字典-addAll
是否包含某个key-containskey
删除某个key-remove
清空-clear
```

Dynamic

```
dynamic a = 1;
a = "test";
可用于声明变量，类似于var，但是变量的类型可在下一次赋值时随意变化
```

### 空安全机制

![image-20251220155006636](Dart/image-20251220155006636.png)

### 运算符

| 运算符 | 作用   |
| ------ | ------ |
| +      | 加     |
| -      | 减     |
| *      | 乘     |
| /      | 除     |
| ~/     | 整除   |
| %      | 取余数 |

布尔运算符和比较运算符与java中完全相同

if，switch，while，for与java中完全相同

### 方法/函数

分类:函数返回值分为有返回值和无返回值
有返回值:具体类型函数名称(){}
无返回值:void函数名称(){}
注意:返回值类型可省略,Dart会自动推断类型为dynamic

```dart
int test(int a, int b){
    return a+b;
}
```

可选参数

```dart
// 合并字符串
String combine(String a, [String? b = "b", String? c = "c"]) {
  return a + (b ?? "") + (c ?? "");
}
```

指定名称参数

```dart
void main(List<String> args) {
  // 调用showPerson函数，仅传必填参数username
  showPerson("老高");
  // 调用时指定可选参数（年龄、性别）
  showPerson("小丽", age: 20, sex: "女");
}

// 定义showPerson函数：含必填参数+可选命名参数
void showPerson(String username, {int? age = 18, String? sex = "男"}) {
  print('姓名: $username, 年龄: $age, 性别: $sex');
}
```

匿名函数

```dart
void main(List<String> args) {
  // 1. 定义匿名函数并赋值给test变量
  Function test = () {
    print("测试数据");
  };

  // 2. 调用高阶函数onTest，传入test作为回调
  onTest(test);

  // 3. 调用箭头函数add，打印结果
  int result = add(1, 2);
  print("1 + 2 = $result");
}

// 高阶函数：接收Function类型的回调参数
void onTest(Function callback) {
  callback(); // 执行传入的回调函数
}

// 箭头函数（简化写法，替代传统带return的函数）
int add(int a, int b) => a + b;
```

类

```dart
void main(List<String> args) {
  // 1. 使用默认构造函数创建对象
  Person p1 = Person(name: '老高', age: 20, sex: '男');
  p1.study();

  // 2. 使用命名构造函数创建对象
  Person p2 = Person.createPerson(name: '新同学', age: 30, sex: '女');
  p2.study();
}

class Person {
  String? name = ""; // 姓名
  int? age = 0; // 年龄
  String? sex = "男";

  // 1. 默认构造函数（带可选参数）
  Person({String? name, int? age, String? sex}) {
    this.name = name;
    this.age = age;
    this.sex = sex;
  }

  // 2. 命名构造函数（通过类名.方法名定义）
  Person.createPerson({String? name, int? age, String? sex}) {
    this.name = name;
    this.age = age;
    this.sex = sex;
  }

  // 类方法
  void study() {
    print("${name}（${age}岁，${sex}）在学习");
  }
}
```

语法糖写法

```dart
// 1. 默认构造函数的语法糖写法（直接用this.参数名简写赋值）
  Person({this.age, this.name, this.sex}); // 替代手动写this.xx = xx

  // 2. 命名构造函数的语法糖写法
  Person.createPerson({this.age, this.name, this.sex}); // 同理简化赋值逻辑
```

### 私有属性

以下划线开头的变量或方法只能在当前类访问

### 继承

定义：继承是拥有父类的属性和方法
特点：dart 属于单继承，一个类只能拥有一个直接父类，子类拥有父类所有的属性和方法
语法：class 类名 extends 父类
重写：子类可通过 @override 注解重写父类方法，扩展其行为
注意：子类不会继承父类构造函数，子类必须通过 super 关键字调用父类构造函数确保父类正确初始化
super 语法：子类构造函数 (可选命名参数):super ({参数})

```dart
void main(List<String> args) {
  // 创建子类对象并测试
  Child child = Child(name: "小明", age: 10);
  child.study(); // 调用父类方法
}

// 父类
class Parent {
  String? name;
  int? age;

  // 父类构造方法（修复原错误写法）
  Parent({this.name, this.age});

  // 父类方法
  void study() {
    print('父类-$name在学习');
  }
}

// 子类继承父类
class Child extends Parent {
  // 子类构造方法（通过super调用父类构造）
  Child({String? name, int? age}) : super(name: name, age: age);
}
```

```dart
void main(List<String> args) {
  // 测试微信支付
  WxPay wxPay = WxPay();
  wxPay.pay();

  // 测试支付宝支付
  AliPay aliPay = AliPay();
  aliPay.pay();
}

// 支付基类（抽象父类）
abstract class PayBase {
  // 抽象支付方法（子类必须实现）
  void pay();
}

// 微信支付类（继承并实现PayBase）
class WxPay extends PayBase {
  @override
  void pay() {
    // 实现微信支付逻辑
    print("微信支付✅");
  }
}

// 支付宝支付类（继承并实现PayBase）
class AliPay implements PayBase {
  @override
  void pay() {
    // 实现支付宝支付逻辑
    print("支付宝支付");
  }
}
```

- `extends`：表示「is-a」关系（子类是父类的一种），子类会继承父类的非私有属性 / 方法，只需实现抽象方法。
- `implements`：表示「has-a」关系（子类实现父类的接口），**必须重写父类的所有方法（包括具体方法）**，本质是「接口实现」（Dart 中没有 `interface` 关键字，抽象类可兼作接口）。

### 混入

定义:Dart允许在不使用传统继承的情况下,向类中添加新的功能能
方式:使用mixin关键字定义一个对象
方式:使用with关键字将定义的对象混入到当前对象
特点:一个类支持with多个mixin,调用优先级遵循"后来居上"原则,即后混入的会覆盖先混入的同名方法

```dart
void main(List<String> args) {
  // 测试学生类（位置参数构造）
  Student student = Student("小明", 18);
  student.song(student.name); // 调用混入的唱歌方法
  student.study(); // 学生特有方法

  print("----------------");

  // 测试老师类（命名参数构造）
  Teacher teacher = Teacher(name: "老高老师", age: 35);
  teacher.song(teacher.name); // 调用混入的唱歌方法
  teacher.teach(); // 老师特有方法
}

// 定义mixin（混入对象，提供通用方法）
mixin Singable {
  // 唱歌方法（通用功能，学生和老师都能复用）
  void song(String name) {
    print("$name正在唱歌🎤");
  }
}

// 学生类：混入Singable，拥有唱歌功能 + 自身特有功能
class Student with Singable {
  String name;
  int age;

  // 位置参数构造（必填参数，无需空安全顾虑）
  Student(this.name, this.age);

  // 学生特有方法
  void study() {
    print("$name（$age岁）正在认真学习📚");
  }
}

// 老师类：混入Singable，拥有唱歌功能 + 自身特有功能
class Teacher with Singable {
  String name;
  int age;

  // 命名参数构造（可选参数，这里强制必填，避免空值）
  Teacher({required this.name, required this.age});

  // 老师特有方法
  void teach() {
    print("$name（$age岁）正在授课📖");
  }
}
```

### 泛型

```dart
void main(List<String> args) {
  // 1. 泛型Map示例
  Map<String, int> scoreMap = {};
  scoreMap["数学"] = 95;
  scoreMap["英语"] = 88;
  print("成绩Map：$scoreMap");

  // 2. 泛型函数：获取值（返回类型与入参一致）
  String strValue = getValue<String>("Dart泛型");
  int numValue = getValue<int>(100);
  print("泛型函数返回字符串：$strValue");
  print("泛型函数返回数字：$numValue");

  // 3. 泛型函数：遍历打印List
  print("\n打印字符串List：");
  printList<String>(["1", "2", "3"]);
  
  print("\n打印整数List：");
  printList<int>([10, 20, 30]);

  // 4. 泛型类：Student类（name的类型由泛型指定）
  Student<int> intNameStudent = Student();
  intNameStudent.name = 2025; // name是int类型
  print("\n泛型类Student（name为int）：${intNameStudent.name}");

  Student<String> strNameStudent = Student();
  strNameStudent.name = "小明"; // name是String类型
  print("泛型类Student（name为String）：${strNameStudent.name}");
}

// 泛型函数：返回与入参同类型的值
T getValue<T>(T value) {
  return value;
}

// 泛型函数：遍历打印泛型List
void printList<T>(List<T> list) {
  for (int i = 0; i < list.length; i++) {
    print("第${i+1}个元素：${list[i]}");
  }
}

// 泛型类：Student（name的类型由泛型I指定）
class Student<I> {
  I? name; // name的类型由外部传入的泛型决定
}
```

## 异步编程

![image-20251220181533091](Dart/image-20251220181533091.png)

```dart
void main(List<String> args) {
  Future f = Future(() {
    throw Exception("模拟出错");
  });

  f.then((value) {
    print("成功: $value");
  }).catchError((error) {
    print("失败: $error");
  }).whenComplete(() {
    print("Future任务结束（无论成败）");
  });
}
```

```dart
void main(List<String> args) {
  // 第一个Future（初始异步任务）
  Future f = Future(() {
    return "Hello World"; // 第一个任务的返回值，会传递给下一个then
  });

  // 链式调用：按顺序执行3个异步任务，前一个任务的结果会传递给后一个
  f
      .then((value) {
        // 第一个then：接收初始Future的结果
        print("第一个任务接收的参数: $value");
        return Future(() => "task1"); // 返回新的Future，传递给下一个then
      })
      .then((value) {
        // 第二个then：接收上一个then返回的"task1"
        print("第二个任务接收的参数: $value");
        return Future(() => "$value-task2"); // 拼接结果，传递给下一个then
      })
      .then((value) {
        // 第三个then：接收上一个then返回的"task1-task2"
        print("第三个任务接收的参数: $value");
        return Future(() => "$value-task3"); // 拼接结果，传递给下一个then
      })
      .then((value) {
        // 第四个then：接收最终拼接结果，然后主动抛异常
        print("最终拼接结果: $value");
        throw Exception("模拟链式调用中出现异常"); // 抛异常，会被后续catchError捕获
      })
      .catchError((error) {
        // 统一捕获整个链式调用中任意环节的异常
        print("捕获到异常: $error");
      });
}

```

```dart
void main(List<String> args) {
  // 调用test函数（注意：test是异步函数，这里直接调用会“Fire and Forget”，不会等待其执行完成）
  test(); 
}

// 定义异步函数：必须用async修饰，内部才能用await
void test() async { // 🔴 注意：异步函数需要加async关键字
  try {
    // 用await等待Future执行：会阻塞当前函数（但不阻塞主线程），直到Future完成
    await Future(() {
      // 这里模拟异步任务执行失败：主动抛出异常
      throw Exception("模拟异步任务出错"); 
      // 如果这里return数据（比如return "测试"），则Future执行成功，await会拿到这个返回值
    });

    // 📌 注意：await下方的代码，只有当上面的Future“执行成功”时才会运行
    // （此例中Future抛了异常，所以这行不会执行）
    print("执行成功逻辑");

  } catch (e) { // 捕获try块中（包括await的Future）抛出的异常
    // 当Future抛异常时，会进入catch分支处理错误
    print("异步请求出现异常，异常信息：$e");
  }
}
```

