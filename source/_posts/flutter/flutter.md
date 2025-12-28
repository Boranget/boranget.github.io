---
title: flutter
date: 2024-02-27 10:35:19
updated: 2024-02-27 16:35:19
tags:
  - flutter
categories:
  - 经验
---

# Android tool chain问题

使用AS下载完SDK和相关工具后，使用`flutter config --android-sdk SDK路径`设置一下SDK即可

# 安装

## 下载

下载VSCODE，并安装flutter和dart的插件，

Control + Shift + P，输入flutter，选择创建新项目，此时会弹出安装sdk的提示，安装即可

但如果网络不好，会下载失败，此时可以手动下载，然后在vscode 中选择locate sdk

[Install Flutter manually](https://docs.flutter.dev/install/manual#install-flutter)

## 配置

需要在系统环境变量中添加如下两个变量

`PUB_HOSTED_URL="https://pub.flutter-io.cn"`

`FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"`

## 验证

`flutter --version`

## doctor检查

`flutter doctor -v`

# 墙内gradle依赖相关问题

build.gradle中配置镜像

```js
buildscript {
    repositories {
        maven { setUrl("https://maven.aliyun.com/repository/central") }
        maven { setUrl("https://maven.aliyun.com/repository/jcenter") }
        maven { setUrl("https://maven.aliyun.com/repository/google") }
        maven { setUrl("https://maven.aliyun.com/repository/gradle-plugin") }
        maven { setUrl("https://maven.aliyun.com/repository/public") }
        maven { setUrl("https://jitpack.io") }
        maven { setUrl("https://maven.aliyun.com/nexus/content/groups/public/") }
        maven { setUrl("https://maven.aliyun.com/nexus/content/repositories/jcenter") }
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        maven { setUrl("https://maven.aliyun.com/repository/central") }
        maven { setUrl("https://maven.aliyun.com/repository/jcenter") }
        maven { setUrl("https://maven.aliyun.com/repository/google") }
        maven { setUrl("https://maven.aliyun.com/repository/gradle-plugin") }
        maven { setUrl("https://maven.aliyun.com/repository/public") }
        maven { setUrl("https://jitpack.io") }
        maven { setUrl("https://maven.aliyun.com/nexus/content/groups/public/") }
        maven { setUrl("https://maven.aliyun.com/nexus/content/repositories/jcenter") }
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}
```

gradle-wrapper.properties中配置镜像

```
distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-8.3-all.zip
```

flutterSDK\flutter\packages\flutter_tools\gradle\flutter.gradle中添加

但似乎作用不大

```js
buildscript {
    repositories {
        //google()
        //mavenCentral()
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
        maven { url 'https://maven.aliyun.com/repository/public' }
    }
}
```

flutterSDK\flutter\packages\flutter_tools\gradle\resolve_dependencies.gradle中添加镜像，似乎作用不大

```js

repositories {
    maven {
        url "$storageUrl/${engineRealm}download.flutter.io"
    }
    maven { url 'https://maven.aliyun.com/repository/google' }
    maven { url 'https://maven.aliyun.com/repository/jcenter' }
    maven { url 'https://maven.aliyun.com/repository/public' }
}
```



# 声明式UI

[声明式 UI | Flutter 中文文档 - Flutter 中文开发者网站 - Flutter](https://docs.flutter.cn/get-started/flutter-for/declarative)

runApp函数是Flutter内部提供的一个函数,启动一个Flutter应用就是从调用这个函数开始的
Widget表示控件、组件、部件的含义,Flutter中万物皆Widget

# 新建项目

`flutter create --platforms web 项目名 `

# 目录结构

Flutter/Dart 项目核心文件 / 目录说明

1. **.dart_tool**：Dart 工具生成的文件和缓存
2. **.idea**：IntelliJ IDEA 的配置文件
3. **build**：构建产物目录，存放编译生成的文件
4. **lib：项目主要源代码目录（核心代码区）**
   1. **main.dart：应用程序的入口文件**
5. **test**：测试文件存放目录
6. **web**：Web 平台专用的配置、资源文件
7. **.gitignore**：Git 版本控制的忽略文件配置
8. **metadata**：Flutter 项目自动生成的标识文件
9. **analysis_options.yaml**：配置静态代码分析工具的文件
10. **flutter_core.iml**：存储模块（Module）特定设置的文件
11. **pubspec.lock**：项目依赖的锁定文件（固定依赖版本）
12. **pubspec.yaml：项目依赖、配置的核心文件（需手动维护）**
13. **README.md**：项目说明文档

# HelloWorld

`MaterialApp` 是 Flutter 基于 **Material Design 设计规范** 提供的「顶层应用容器」

`Scaffold` 是 Material Design 风格的「页面容器」，负责单个页面的基础布局结构

| 组件          | 作用范围 | 核心职责                                   | 通俗比喻                     |
| ------------- | -------- | ------------------------------------------ | ---------------------------- |
| `MaterialApp` | 整个 App | 全局配置（主题、路由）、App 顶层容器       | 房子的 “整体框架 + 装修风格” |
| `Scaffold`    | 单个页面 | 页面布局结构（导航栏、主体内容）、页面容器 | 单个房间的 “墙体 + 门窗位置” |

```dart
// 导入Flutter核心UI库，提供构建界面所需的所有基础组件（如Widget、Color、Text等）
import 'package:flutter/material.dart';

// 程序入口函数：Dart语言规定main函数为应用程序的起点
// List<String> args 是命令行参数列表，Flutter应用中通常无需手动处理
void main(List<String> args) {
  // 启动Flutter应用的核心方法，接收一个Widget作为应用的根组件
  runApp(
    // MaterialApp：Material Design风格的应用容器，封装了应用的基础配置
    // 是开发Flutter应用的标准入口组件，提供主题、路由、标题等核心功能
    MaterialApp(
      // 应用标题：主要用于任务管理器中显示的应用名称，而非界面标题
      title: "My App",
      // 应用主题配置：统一管理应用的颜色、字体、控件样式等
      // scaffoldBackgroundColor：设置所有Scaffold组件的默认背景色为红色
      theme: ThemeData(scaffoldBackgroundColor: Colors.red),
      // home：应用的首页组件，即启动后首先显示的界面
      home: Scaffold(
        // AppBar：应用顶部的导航栏组件，包含标题、返回按钮等
        appBar: AppBar(
          // Text组件：显示文本内容，是最基础的UI组件之一
          title: Text("My App") // 导航栏标题文字
        ),
        // body：Scaffold的主体内容区域，占满导航栏和底部组件之间的空间
        body: Center(
          // Center组件：将子组件居中显示（水平+垂直居中）
          child: Text("Hello World") // 主体内容：居中显示"Hello World"文本
        ),
        // bottomNavigationBar：底部导航栏区域，通常用于页面切换
        // 这里用Container自定义了一个简单的底部组件（实际开发中常用BottomNavigationBar组件）
        bottomNavigationBar: Container(
          height: 50, // 容器高度设置为50逻辑像素
          color: Colors.blue, // 容器背景色为蓝色
          child: Center(
            child: Text("Bottom Navigation Bar") // 底部区域居中显示的文本
          ),
        ),
      ),
    ),
  );
}
```

| 特性     | StatelessWidget (无状态)           | StatefulWidget (有状态)                      |
| -------- | ---------------------------------- | -------------------------------------------- |
| 核心特征 | 一旦创建，内部状态不可变           | 持有可在其生命周期内改变的状态               |
| 使用场景 | 静态内容展示，外观仅由配置参数决定 | 交互式组件，如计数器、可切换开关、表单输入框 |
| 生命周期 | 相对简单，主要是构建（build）      | 更为复杂，包含状态创建、更新和销毁           |
| 代码结构 | 单个类                             | 两个关联的类：Widget 本身和单独的 State 类   |

# 生命周期

有状态组件（StatefulWidget）

生命周期分 3 个阶段：

- 创建阶段
  - `createState()`：初始化 Widget，创建 State 对象
  - `initState()`：State 插入 Widget 树时执行，仅 1 次（初始化数据 / 监听）
  - `didChangeDependencies()`：`initState`后立即执行；依赖的`InheritedWidget`更新时会多次调用
- 构建与更新阶段
  - `build()`：构建 UI，初始化 / 更新时多次调用
  - `didUpdateWidget()`：父组件传新配置时调用，用于对比新旧配置
- 销毁阶段
  - `deactivate()`：State 临时从树中移除时调用
  - `dispose()`：State 永久移除时调用，释放资源，仅 1 次

无状态组件（StatelessWidget）

无 “生命周期阶段”，仅一个核心方法：

- `build()`：接收父组件传参后构建 UI，每次父组件更新 / 自身依赖变化时调用（无状态意味着自身数据不可变，仅依赖外部传入的`widget`参数）

# 点击事件

| 组件类别     | 核心组件示例                  | 特点 & 使用场景                                              |
| ------------ | ----------------------------- | ------------------------------------------------------------ |
| 专用按钮组件 | ElevatedButton、TextButton 等 | 内置点击动画 + 样式，通过`onPressed`参数处理点击逻辑         |
| 视觉反馈组件 | InkWell                       | 提供`onTap`事件，自带 Material Design 水纹扩散效果（需包裹其他组件） |
| 功能交互组件 | IconButton、Switch、Checkbox  | 特定功能控件，通过`onPressed`绑定点击逻辑                    |
| 通用手势组件 | GestureDetector               | 功能最丰富的手势检测组件，通过`onTap`（点击）等参数绑定逻辑，可包裹任意元素 |

```dart
import 'package:flutter/material.dart';

// 程序入口点，main函数接收命令行参数
void main(List<String> args) {
  // 运行Count应用程序
  runApp(Count());
}

// Count是一个有状态的Widget，用于创建计数器应用
class Count extends StatefulWidget {
  // 构造函数，使用super.key调用父类构造函数
  const Count({super.key});

  // 覆盖createState方法，返回状态管理对象
  @override
  State<Count> createState() => _CountState();
}

// _CountState是Count widget的状态管理类
class _CountState extends State<Count> {
  // 定义计数变量，初始值为0
  int count = 0;

  // 覆盖build方法，构建UI界面
  @override
  Widget build(BuildContext context) {
    // 返回MaterialApp组件，这是Material Design风格的应用根组件
    return MaterialApp(
      // 设置主页
      home: Scaffold(
        // 设置应用栏，显示标题"Count"
        appBar: AppBar(title: Text('Count')),
        // 设置页面主体内容，居中显示
        body: Center(
          // 使用Row布局横向排列子元素
          child: Row(
            // 主轴对齐方式：居中对齐
            mainAxisAlignment: MainAxisAlignment.center,
            // 交叉轴对齐方式：居中对齐
            // crossAxisAlignment: CrossAxisAlignment.center,
            // 子元素列表
            children: [
              // 减少计数的图标按钮
              IconButton(
                // 设置图标大小为48
                iconSize: 48,
                // 按钮点击回调函数，调用decrement方法减少计数
                onPressed: () {
                  decrement();
                },
                // 设置按钮图标为减号图标
                icon: Icon(Icons.remove),
              ),
              // 添加间距，宽度为20像素
              SizedBox(width: 20),
              // 显示当前计数值的文本，字体大小为48
              Text('$count', style: TextStyle(fontSize: 48)),
              // 添加间距，宽度为20像素
              SizedBox(width: 20),
              // 增加计数的图标按钮
              IconButton(
                // 设置图标大小为48
                iconSize: 48,
                // 按钮点击回调函数，调用increment方法增加计数
                onPressed: () {
                  increment();
                },
                // 设置按钮图标为加号图标
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 增加计数的方法
  void increment() {
    // 使用setState更新界面状态，计数加1
    setState(() {
      count++;
    });
  }

  // 减少计数的方法
  void decrement() {
    // 使用setState更新界面状态，计数减1
    setState(() {
      count--;
    });
  }
}

```



# decoration

复杂样式

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          // 用Container演示decoration
          child: Container(
            width: 200,
            height: 200,
            // decoration：容器的装饰（背景、边框、圆角等）
            decoration: BoxDecoration(
              // 背景色
              color: Colors.lightBlue[100],
              // 圆角（所有角统一设置）
              borderRadius: BorderRadius.circular(16),
              // 边框（宽度+颜色）
              border: Border.all(
                width: 3,
                color: Colors.blue,
              ),
              // 阴影（可选，增强视觉效果）
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            // 容器内的文字
            child: const Center(
              child: Text(
                "Decoration示例",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

# 布局

## Container

- 功能：基础容器，可设置宽高、背景、内边距、外边距、装饰（边框 / 阴影）等
- 场景：包裹单个子组件并自定义样式
- 长宽设置为double.infinity可以占满父元素

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: 200, // 宽度
          height: 200, // 高度
          color: Colors.blue[300], // 背景色
          padding: const EdgeInsets.all(20), // 内边距
          margin: const EdgeInsets.symmetric(horizontal: 50), // 外边距
          child: const Text("Container 示例"),
        ),
      ),
    );
  }
}
```



## Center

- 功能：将子组件居中对齐（水平 + 垂直）
- 场景：快速让内容居中，是`Align(alignment: Alignment.center)`的简化版

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          // 子组件自动居中
          child: Container(color: Colors.green[300], child: const Text("居中显示")),
        ),
      ),
    );
  }
}
```



## Align

与其他容器alignment属性的区别是，可以控制容器内单独一个组件的对齐方式

- 功能：控制子组件在父容器内的对齐方式（如左上`topLeft`、右下`bottomRight`等）

- 场景：需要精准控制子组件位置时使用

  ```
  import 'package:flutter/material.dart';
  
  void main() => runApp(const MyApp());
  
  class MyApp extends StatelessWidget {
    const MyApp({super.key});
  
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomRight, // 右下对齐（可选：topLeft/centerRight等）
            child: Container(
              width: 150,
              height: 150,
              color: Colors.orange[300],
              child: const Text("右下对齐"),
            ),
          ),
        ),
      );
    }
  }
  ```

  

## Padding

- 功能：给子组件添加内边距（上下左右间距）

- 场景：避免子组件与容器边缘紧贴

  ```dart
  import 'package:flutter/material.dart';
  
  void main() => runApp(const MyApp());
  
  class MyApp extends StatelessWidget {
    const MyApp({super.key});
  
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 30, top: 50), // 左30+上50内边距
            child: Container(color: Colors.purple[300], child: const Text("带内边距的组件")),
          ),
        ),
      );
    }
  }
  ```

  

## Column

- 功能：垂直方向排列子组件（从上到下）

- 场景：纵向布局（如表单、列表项）

  ```dart
  import 'package:flutter/material.dart';
  
  void main() => runApp(const MyApp());
  
  class MyApp extends StatelessWidget {
    const MyApp({super.key});
  
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 垂直方向居中（可选：start/end等）
            children: [
              Container(color: Colors.red[300], child: const Text("垂直项1")),
              const SizedBox(height: 20), // 间距
              Container(color: Colors.red[400], child: const Text("垂直项2")),
              const SizedBox(height: 20),
              Container(color: Colors.red[500], child: const Text("垂直项3")),
            ],
          ),
        ),
      );
    }
  }
  ```

  

## Row

- 功能：水平方向排列子组件（从左到右）

- 场景：横向布局（如导航栏、按钮组）

  ```dart
  import 'package:flutter/material.dart';
  
  void main() => runApp(const MyApp());
  
  class MyApp extends StatelessWidget {
    const MyApp({super.key});
  
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // 水平均匀分布
            children: [
              Container(color: Colors.cyan[300], child: const Text("水平项1")),
              Container(color: Colors.cyan[400], child: const Text("水平项2")),
              Container(color: Colors.cyan[500], child: const Text("水平项3")),
            ],
          ),
        ),
      );
    }
  }
  ```

  

## Flex + Expanded

- **Flex**：基础弹性布局容器，可设置`direction`（水平 / 垂直）

- **Expanded**：包裹子组件，使其占满 Flex 容器的剩余空间

- 场景：实现 “自适应占比” 的布局（如 Row 内两个组件按比例分配宽度）

  ```dart
  import 'package:flutter/material.dart';
  
  void main() => runApp(const MyApp());
  
  class MyApp extends StatelessWidget {
    const MyApp({super.key});
  
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Flex(
            direction: Axis.horizontal, // 水平方向（可选：vertical垂直）
            children: [
              Expanded( // 占1份宽度
                flex: 1,
                child: Container(color: Colors.yellow[300], child: const Text("1份")),
              ),
              Expanded( // 占2份宽度
                flex: 2,
                child: Container(color: Colors.yellow[400], child: const Text("2份")),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

  

## Wrap

- 功能：自动换行的布局容器（子组件超出父容器宽度 / 高度时自动换行）

- 场景：标签流、多按钮等需要自动换行的场景

  ```dart
  import 'package:flutter/material.dart';
  
  void main() => runApp(const MyApp());
  
  class MyApp extends StatelessWidget {
    const MyApp({super.key});
  
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Wrap(
            spacing: 10, // 水平间距
            runSpacing: 10, // 垂直间距
            children: List.generate(8, (index) { // 生成8个标签
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Colors.indigo[300],
                child: Text("标签${index+1}"),
              );
            }),
          ),
        ),
      );
    }
  }
  ```

  

## Stack + Positioned

- **Stack**：层叠布局容器（子组件按顺序堆叠）

- **Positioned**：控制 Stack 内子组件的绝对位置（可设置`left/right/top/bottom`）

- 场景：实现 “悬浮组件”（如图片上的文字标签、弹窗遮罩）

  ```dart
  import 'package:flutter/material.dart';
  
  void main() => runApp(const MyApp());
  
  class MyApp extends StatelessWidget {
    const MyApp({super.key});
  
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              // 底层组件（背景图/容器）
              Container(width: double.infinity, height: 300, color: Colors.grey[300]),
              // 上层组件（绝对定位）
              Positioned(
                left: 20,
                top: 50,
                child: Container(color: Colors.pink[300], child: const Text("左上角悬浮")),
              ),
              Positioned(
                right: 20,
                bottom: 50,
                child: Container(color: Colors.pink[400], child: const Text("右下角悬浮")),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

# 组件

## Text 组件

**作用**：显示文本内容的基础组件，支持丰富的样式配置。

核心特性

- 可设置字体大小、颜色、粗细、字重
- 支持文本对齐、换行方式、溢出处理
- 可添加文本装饰（下划线、删除线等）

示例代码

```dart
Text(
  "Flutter Text 组件示例",
  style: TextStyle(
    fontSize: 18, // 字体大小
    color: Colors.blueAccent, // 字体颜色
    fontWeight: FontWeight.bold, // 字体粗细
    fontStyle: FontStyle.italic, // 斜体
    decoration: TextDecoration.underline, // 下划线
    decorationColor: Colors.grey, // 装饰线颜色
  ),
  textAlign: TextAlign.center, // 文本对齐方式
  maxLines: 2, // 最大显示行数
  overflow: TextOverflow.ellipsis, // 溢出处理（省略号）
  softWrap: true, // 是否自动换行
)
```

## Image 组件

**作用**：加载并显示本地、网络等多种来源的图片。

核心特性

- 支持本地资源图片、网络图片、文件图片
- 可设置图片宽高、缩放模式、占位图
- 支持图片缓存（网络图片）

本地图片配置（关键步骤）

1. 在项目根目录创建资源文件夹（如 `lib/images/`），放入图片文件
2. 在 `pubspec.yaml` 中配置资源路径：

```yaml
flutter:
  assets:
    - lib/images/ # 配置整个文件夹
    # 或指定单个图片：- lib/images/avatar.png
```

```dart
// 1. 本地资源图片
Image.asset(
  "lib/images/logo.png", // 相对于 pubspec.yaml 配置的路径
  width: 100,
  height: 100,
  fit: BoxFit.cover, // 图片缩放模式
  placeholder: (context, url) => CircularProgressIndicator(), // 加载中占位图
  errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // 加载失败占位图
),

// 2. 网络图片
Image.network(
  "https://picsum.photos/200/200", // 网络图片地址
  width: 200,
  height: 200,
  fit: BoxFit.contain,
  cacheWidth: 400, // 缓存图片宽度（优化性能）
  cacheHeight: 400,
),
```

## TextField 组件

**作用**：文本输入框，支持普通输入、密码输入、带图标的输入等场景。

核心特性

- 通过 `controller` 控制输入内容（获取 / 设置 / 清空）
- 支持密码隐藏、输入类型限制（数字、邮箱等）
- 可设置提示文本、输入回调、样式自定义

示例代码

```dart
// 1. 普通文本输入框（带控制器）
final TextEditingController _textController = TextEditingController();

TextField(
  controller: _textController, // 绑定控制器
  decoration: InputDecoration(
    labelText: "请输入用户名", // 标签文本
    hintText: "用户名/手机号", // 提示文本
    prefixIcon: Icon(Icons.person), // 左侧图标
    border: OutlineInputBorder(), // 边框样式
    filled: true,
    fillColor: Colors.grey[100], // 背景色
  ),
  keyboardType: TextInputType.text, // 输入类型（文本）
  onChanged: (value) {
    // 输入内容变化时回调
    print("输入内容：$value");
  },
  onSubmitted: (value) {
    // 提交（回车）时回调
    print("提交内容：$value");
  },
);

// 2. 密码输入框
TextField(
  obscureText: true, // 隐藏输入内容（密码模式）
  decoration: InputDecoration(
    labelText: "请输入密码",
    hintText: "不少于6位字符",
    prefixIcon: Icon(Icons.lock),
    suffixIcon: Icon(Icons.visibility), // 右侧图标（显示/隐藏密码）
    border: OutlineInputBorder(),
  ),
  obscureText: true, // 密码隐藏
  enableSuggestions: false, // 禁用输入建议
  autocorrect: false, // 禁用自动纠正
);

// 控制器常用操作
// 获取输入值：_textController.text
// 设置输入值：_textController.text = "默认值"
// 清空输入：_textController.clear()
```

## SingleChildScrollView 组件

**作用**：单个子组件的滚动容器，适用于少量内容的滚动场景。

核心特性

- 支持垂直 / 水平滚动
- 可快速实现 “回到顶部” 功能
- 局限性：一次性加载所有子组件，不适合大量数据（如长列表）

示例代码

```dart
// 垂直滚动（默认）
SingleChildScrollView(
  // 关键：添加滚动控制器，用于回到顶部
  controller: _scrollController,
  padding: EdgeInsets.all(16),
  physics: BouncingScrollPhysics(), // 滚动物理效果（iOS回弹/Android滚动）
  child: Column(
    children: [
      // 子组件（可多个，总高度超过屏幕时滚动）
      Container(height: 200, color: Colors.red),
      SizedBox(height: 16),
      Container(height: 300, color: Colors.blue),
      SizedBox(height: 16),
      Container(height: 400, color: Colors.green),
    ],
  ),
);

// 回到顶部功能实现
final ScrollController _scrollController = ScrollController();

// 触发回到顶部的方法
void _scrollToTop() {
  _scrollController.animateTo(
    0, // 滚动到顶部位置
    duration: Duration(milliseconds: 300), // 动画时长
    curve: Curves.easeInOut, // 动画曲线
  );
}

// 调用方式（如按钮点击）
ElevatedButton(
  onPressed: _scrollToTop,
  child: Text("回到顶部"),
);

// 水平滚动
SingleChildScrollView(
  scrollDirection: Axis.horizontal, // 水平方向
  child: Row(
    children: [
      Container(width: 200, height: 100, color: Colors.orange),
      SizedBox(width: 16),
      Container(width: 200, height: 100, color: Colors.purple),
      SizedBox(width: 16),
      Container(width: 200, height: 100, color: Colors.yellow),
    ],
  ),
);
```

## ListView 组件

**作用**：列表滚动组件，支持按需加载 / 销毁子组件，适用于大量数据展示（性能优于 SingleChildScrollView）。

核心特性

- 懒加载：只构建当前可见区域的子组件
- 支持水平 / 垂直列表、分割线、下拉刷新 / 上拉加载
- 两种构建方式：`ListView()`（直接子组件）、`ListView.builder()`（按需构建）

示例代码

```dart
// 1. 基础列表（直接子组件，适用于少量列表项）
ListView(
  padding: EdgeInsets.all(16),
  children: [
    ListTile(
      leading: Icon(Icons.message),
      title: Text("消息通知"),
      subtitle: Text("您有3条未读消息"),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {}, // 点击事件
    ),
    Divider(height: 1), // 分割线
    ListTile(
      leading: Icon(Icons.settings),
      title: Text("设置中心"),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {},
    ),
  ],
);

// 2. 动态列表（ListView.builder，适用于大量数据）
ListView.builder(
  itemCount: 100, // 列表项总数（必填）
  itemExtent: 60, // 每个列表项的高度（优化性能）
  padding: EdgeInsets.all(8),
  itemBuilder: (context, index) {
    // 按需构建列表项（只构建可见区域）
    return ListTile(
      leading: CircleAvatar(child: Text("${index + 1}")),
      title: Text("列表项 ${index + 1}"),
      subtitle: Text("这是第 ${index + 1} 个列表项"),
      onTap: () {
        print("点击了第 ${index + 1} 个列表项");
      },
    );
  },
);

// 3. 带分割线的列表
ListView.separated(
  itemCount: 50,
  // 列表项构建
  itemBuilder: (context, index) {
    return ListTile(
      title: Text("带分割线的列表项 ${index + 1}"),
    );
  },
  // 分割线构建
  separatorBuilder: (context, index) {
    return Divider(
      height: 1,
      color: Colors.grey[300],
      indent: 16, // 左侧缩进
      endIndent: 16, // 右侧缩进
    );
  },
);
```

## GridView 组件

**作用**：网格布局组件，用于多列排列的内容展示（如图片墙、应用图标）。

核心特性

- 支持固定列数、自适应列数
- 可设置网格间距、宽高比
- 支持懒加载（`GridView.builder`）

示例代码

```dart
// 1. 固定列数的网格（GridView.count）
GridView.count(
  crossAxisCount: 3, // 列数（关键）
  crossAxisSpacing: 10, // 列之间的间距
  mainAxisSpacing: 10, // 行之间的间距
  padding: EdgeInsets.all(16),
  childAspectRatio: 1.0, // 子组件宽高比（1:1 为正方形）
  children: List.generate(9, (index) {
    return Container(
      color: Colors.primaries[index % Colors.primaries.length],
      child: Center(child: Text("${index + 1}")),
    );
  }),
);

// 2. 自适应列数的网格（GridView.extent）
GridView.extent(
  maxCrossAxisExtent: 120, // 每列最大宽度（自动计算列数）
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  padding: EdgeInsets.all(16),
  childAspectRatio: 0.8, // 宽高比（宽>高）
  children: List.generate(12, (index) {
    return Image.network(
      "https://picsum.photos/200/300?random=$index",
      fit: BoxFit.cover,
    );
  }),
);

// 3. 懒加载网格（GridView.builder）
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // 列数
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 1.5,
  ),
  itemCount: 20, // 总数量
  itemBuilder: (context, index) {
    return Card(
      child: Center(child: Text("网格项 ${index + 1}")),
    );
  },
);
```

## CustomScrollView 组件

**作用**：自定义滚动组件，可组合多个 Sliver 组件（如 SliverAppBar、SliverList），实现复杂滚动效果。

核心特性

- 支持 “吸顶”、“折叠导航栏” 等效果
- 统一滚动手势，多个滚动区域联动
- 性能优化：只加载可见区域的 Sliver 组件

示例代码

```dart
CustomScrollView(
  slivers: [
    // 1. 折叠导航栏（SliverAppBar）
    SliverAppBar(
      title: Text("CustomScrollView 示例"),
      expandedHeight: 200, // 展开高度
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          "https://picsum.photos/800/400",
          fit: BoxFit.cover,
        ),
      ),
      pinned: true, // 导航栏是否固定在顶部
      floating: true, // 滑动时是否快速显示导航栏
      snap: true, // 滑动到一定位置时自动展开/收起
    ),

    // 2. 网格列表（SliverGrid）
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            color: Colors.blue[100],
            child: Center(child: Icon(Icons.apps)),
          );
        },
        childCount: 8,
      ),
    ),

    // 3. 普通列表（SliverList）
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ListTile(
            title: Text("SliverList 项 ${index + 1}"),
            leading: Icon(Icons.list),
          );
        },
        childCount: 15,
      ),
    ),
  ],
);
```

## PageView 组件

**作用**：页面切换组件，支持左右滑动切换页面，常用于引导页、轮播图、tab 页面。

核心特性

- 支持无限滚动（轮播图）
- 可设置页面指示器、自动切换
- 支持垂直 / 水平方向切换

示例代码

```dart
// 1. 基础页面切换
final PageController _pageController = PageController(initialPage: 0);

PageView(
  controller: _pageController,
  scrollDirection: Axis.horizontal, // 水平切换（默认）
  onPageChanged: (index) {
    // 页面切换时回调
    print("当前页面索引：$index");
  },
  children: [
    Container(
      color: Colors.red,
      child: Center(child: Text("页面 1")),
    ),
    Container(
      color: Colors.blue,
      child: Center(child: Text("页面 2")),
    ),
    Container(
      color: Colors.green,
      child: Center(child: Text("页面 3")),
    ),
  ],
);

// 页面切换控制（如按钮点击）
ElevatedButton(
  onPressed: () {
    _pageController.jumpToPage(2); // 直接跳转到第3页（索引2）
    // 或带动画跳转：_pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.ease);
  },
  child: Text("跳转到第3页"),
);

// 2. 轮播图（无限滚动）
PageView.builder(
  controller: PageController(viewportFraction: 0.8), // 视图占比（实现卡片堆叠效果）
  itemCount: 1000, // 模拟无限滚动（实际数据取模）
  onPageChanged: (index) {
    // 实际索引：index % 真实数据长度
  },
  itemBuilder: (context, index) {
    final realIndex = index % 5; // 真实数据长度为5
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Image.network(
        "https://picsum.photos/600/400?random=$realIndex",
        fit: BoxFit.cover,
      ),
    );
  },
);
```

# 组件通信

## 无状态子组件通信父传子

子组件接受信息的变量必须为final，避免子组件更改

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(), // 父组件
    );
  }
}

// 父组件（无状态）
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("父组件")),
      body: Column(
        children: [
          // 传递参数给子组件：这里传了 "Hello 子组件"
          Child(message: "Hello 子组件"),
        ],
      ),
    );
  }
}

// 子组件（无状态）
class Child extends StatelessWidget {
  // 1. 定义接收属性（必须用final）
  final String? message;

  // 2. 构造函数接收参数
  const Child({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // 3. 使用父组件传递的属性
      child: Text(
        "子组件显示：$message",
        style: const TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }
}
```

## 有状态子组件通信父传子

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(), // 父组件
    );
  }
}

// 父组件（无状态）
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("父组件（传递参数）")),
      body: Column(
        children: [
          // 传递参数给有状态子组件
          Child(message: "父组件传给我的内容"),
        ],
      ),
    );
  }
}

// 有状态子组件（对外的Widget类）
class Child extends StatefulWidget {
  // 1. 定义接收属性（final修饰）
  final String message;

  // 2. 构造函数接收参数（required表示必传）
  const Child({super.key, required this.message});

  @override
  State<Child> createState() => _ChildState();
}

// 有状态子组件（对内的State类）
class _ChildState extends State<Child> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // 3. 通过widget.属性名获取父组件传递的值
      child: Text(
        "有状态子组件显示：${widget.message}",
        style: const TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }
}
```

## 子传父回调函数

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainPage());
  }
}

// 父组件：维护菜品列表，传递删除函数给子组件
class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 菜品列表数据
  List<String> foodList = ["鱼香肉丝", "宫保鸡丁", "京酱肉丝", "溜肉片"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("菜品列表")),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 一行显示2个
          childAspectRatio: 1.5, // 宽高比
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: foodList.length,
        itemBuilder: (context, index) {
          // 传递：菜品名称、索引、删除函数
          return Child(
            foodName: foodList[index],
            index: index,
            delFood: (int index) {
              setState(() {
                foodList.removeAt(index); // 从列表中移除对应项
              });
            },
          );
        },
      ),
    );
  }
}

// 子组件：接收父组件的参数，点击删除按钮触发父组件函数
class Child extends StatefulWidget {
  // 接收父组件的参数
  final String foodName;
  final int index;
  final Function(int) delFood;

  const Child({
    super.key,
    required this.foodName,
    required this.index,
    required this.delFood,
  });

  @override
  State<Child> createState() => _ChildState();
}

class _ChildState extends State<Child> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight, // Stack内的组件默认右上角对齐
      children: [
        // 菜品容器
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: Text(
            widget.foodName,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        // 删除按钮（点击时调用父组件的delFood函数）
        IconButton(
          color: Colors.red,
          onPressed: () {
            widget.delFood(widget.index); // 触发父组件的删除逻辑
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}

```

# 网络请求DIO

安装`flutter pub add dio`

```dart
import 'package:dio/dio.dart';

void main(List<String> args) {
  Dio()
      .get("https://geek.itheima.net/v1_0/channels")
      .then((res) {
        print(res);
      })
      .catchError((e) {
        print(e);
      });
}
```

## 开发环境跨域问题

默认情况下，Flutter 运行 Web 端时加载网络资源，会因浏览器的同源策略限制，出现跨域请求错误。 
1. 修改 Chrome 启动配置   找到 Flutter 工具包中的 `chrome.dart` 文件：   路径：`flutter/packages/flutter_tools/lib/src/web/chrome.dart`   在该文件的 Chrome 启动参数列表中，添加 `'--disable-web-security'`（关闭浏览器的跨域安全校验）。  
2. 清除缓件   删除 Flutter 缓存目录下的两个文件，让修改后的配置生效：   路径：`flutter/bin/cache/`   需删除的文件：   `flutter_tools.snapshot`    `flutter_tools.stamp`  
3. 此方法仅适用于开发调试阶段（关闭浏览器安全校验存在风险，不能用于生产环境）。 生产环境的跨域问题，需通过后端配置 CORS 策略（如服务端设置 `Access-Control-Allow-Origin` 等响应头）来解决。  

# 路由

## 基础路由



```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListPage(), // 启动页为列表页
    );
  }
}

// 列表页（StatefulWidget，可扩展状态）
class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("列表页")),
      // 列表构建器（懒加载）
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 20, // 列表项数量
        itemBuilder: (context, index) {
          // 每个列表项（可点击）
          return GestureDetector(
            onTap: () {
              // 点击跳转到详情页，并传递参数
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(itemIndex: index + 1),
                ),
              );
            },
            // 列表项样式（蓝色背景+文字）
            child: Container(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 20),
              margin: const EdgeInsets.only(bottom: 5),
              child: Center(
                child: Text(
                  "列表项${index + 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 详情页（接收列表项参数）
class DetailPage extends StatelessWidget {
  final int itemIndex; // 接收的参数

  const DetailPage({super.key, required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("详情页")),
      body: Center(
        child: Text("你点击了 列表项$itemIndex", style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}

```

## 命名路由

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/list", // 初始路由：启动页为列表页
      routes: {
        // 路由表：配置路径与页面的映射
        "/list": (context) => const ListPage(),
        "/detail": (context) => const DetailPage(),
      },
    );
  }
}

// 列表页：负责传递参数
class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("列表页")),
      body: ListView.builder(
        itemCount: 10, // 列表项数量
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // 命名路由跳转 + 传递参数
            // arguments：通过该参数传递数据（通常是Map格式，方便多参数）
            Navigator.pushNamed(
              context,
              "/detail", // 目标路由路径
              arguments: {"id": index + 1}, // 传递的参数：id=当前列表项序号
            );
          },
          child: Container(
            color: Colors.blue,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(20),
            child: Text(
              "列表项${index + 1}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// 详情页：负责接收参数
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _id = ""; // 存储接收的参数

  @override
  void initState() {
    super.initState();
    // 注意：initState中直接获取路由参数会失败（此时context还未关联路由）
    // 需放在Future.microtask（异步微任务）中，等页面初始化完成后再获取
    Future.microtask(() {
      // ModalRoute.of(context)：获取当前页面的路由信息
      if (ModalRoute.of(context) != null) {
        // 从settings.arguments中取出参数，并断言为Map类型
        Map<String, dynamic> params =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        // 提取参数中的id，并更新状态
        setState(() {
          _id = params["id"].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("详情页")),
      body: Center(child: Text("当前详情页ID：$_id")), // 展示接收的参数
    );
  }
}

```

| 方法名                    | 核心作用             | 路由栈变化示例      | 使用场景                           |
| ------------------------- | -------------------- | ------------------- | ---------------------------------- |
| `pushNamed`               | 进入新页面           | `[A,B] → [A,B,C]`   | 常规页面跳转（如列表→详情）        |
| `pushReplacementNamed`    | 替换当前页面         | `[A,B] → [A,C]`     | 登录成功后跳主页（无法返回登录页） |
| `pushNamedAndRemoveUntil` | 跳转新页并清理栈     | `[A,B,C,D] → [A,E]` | 退出登录后跳登录页（清空历史）     |
| `popAndPushNamed`         | 返回并立即跳新页     | `[A,B,C] → [A,B,D]` | 购物车结算后→返回列表 + 跳订单页   |
| `popUntil`                | 连续返回直到满足条件 | `[A,B,C,D] → [A,B]` | 从设置深层级一键返回主设置页       |