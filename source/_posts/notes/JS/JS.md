---
title: JS
date: 2022-12-08 16:50:30
tags:
  - web基础
categories:
  - 笔记
---

# JS

## javaScrip t警告/弹窗

### alert(字符串或变量)

```html
<script type="text/javascript">
    var mynum = 30
    alert("hello")
    alert(mynum)
</script>
```

### confirm(字符串或变量)

用户点击确定返回true,点击取消返回false

```html
<script type="text/javascript">
        var mynum = 20
        var one = confirm("hello:"+mynum)
        confirm(one)
    </script>
```

### prompt(标题,内容)

点击确定会返回内容,内容为空返回空字符串

点击取消返回null

```html
<script type="text/javascript">
    var mynum = 20
    var str = prompt("aa",mynum)
    alert(str)
</script>
```

## 窗口操作

### 打开新窗口

open()方法

window.open([URL],[窗口名称],[参数字符串])

其中:

- URL: 可选参数, 在窗口中要显示的网页地址或路径,如果忽略此参数,窗口不显示任何文档

- 窗口名称

  由字母数字下划线组成,不能含有其他字符

  

  - 自定名称
  - _top 框架网页中在上部窗口显示目标网页
  - _self 当前窗口显示目标网页
  - _blank 在新窗口显示目标网页

- 参数列表
	| 参数| 解释      |
	| ------------------------- | ------------------------------------------------------------ |
	| channelmode=yes\|no\|1\|0 | 是否要在影院模式显示 window。默认是没有的。仅限IE浏览器      |
	| directories=yes\|no\|1\|0 | 是否添加目录按钮。默认是肯定的。仅限IE浏览器                 |
	| fullscreen=yes\|no\|1\|0  | 浏览器是否显示全屏模式。默认是没有的。在全屏模式下的 window，还必须在影院模式。仅限IE浏览器 |
	| height=pixels             | 窗口的高度。最小.值为100                                     |
	| left=pixels               | 该窗口的左侧位置                                             |
	| location=yes\|no\|1\|0    | 是否显示地址字段.默认值是yes                                 |
	| menubar=yes\|no\|1\|0     | 是否显示菜单栏.默认值是yes                                   |
	| resizable=yes\|no\|1\|0   | 是否可调整窗口大小.默认值是yes                               |
	| scrollbars=yes\|no\|1\|0  | 是否显示滚动条.默认值是yes                                   |
	| status=yes\|no\|1\|0      | 是否要添加一个状态栏.默认值是yes                             |
	| titlebar=yes\|no\|1\|0    | 是否显示标题栏.被忽略，除非调用HTML应用程序或一个值得信赖的对话框.默认值是yes |
	| toolbar=yes\|no\|1\|0     | 是否显示浏览器工具栏.默认值是yes                             |
	| top=pixels                | 窗口顶部的位置.仅限IE浏览器                                  |
	| width=pixels              | 窗口的宽度.最小.值为100                                      |

### 关闭窗口

- 关闭本窗口

  - window.close();

- 关闭指定窗口

  - 窗口对象.close();

  ```html
  <script>
  	var a = window.open("www.baidu.com")
      a.close()
  </script>
  ```

  

## HTML元素操作

### 通过ID获取元素

```js
document.getElementById("id")
```

### innerHTML属性

```js
object.innerHTML
```

用于获取html标签内部的内容,不包括标签本身

### 更改html元素样式

```html
<p id = "pid">样式修改测试</p>
<script>
    var pid = document.getElementById("pid")
    pid.style.color="red"
</script>
```

通过style.display可以设置元素是否显示

### 控制类名

```js
object.className = classname
```

## 变量

没有赋值的变量值为undefined

undefined是一种数据类型

== 字面值的比较

=== 字面值加类型的比较

如：

var a = “12”

var b = 12

a==b : true

a===b : false

在做逻辑运算时，0, null, undefinde, ""空串都认为是false值，其余为true

## 逻辑运算

与其他语言不同的是，js中的逻辑运算并不是返回true或false，而是返回做逻辑运算中的值，返回哪个值取决于在哪个值可以决定的当前表达式的真假性，根据与短路运算：

&& 运算

当表达式全为真，只有到最后一个值才能决定当前表达式的值，所以返回最后一个表达式的值

当表达式的值为假，则返回第一个假值

|| 运算

当表达式全为假，返回最后一个表达式的值

当表达式中有一个真，则返回第一个真值

## 数组

同样与别的语言不同: js中的数组是非定长的，可以在程序的运行过程中改变数组的长度，其长度取决于最后一个存储了有效值的位置。

例如：

```js
var x = []
x[2] = 1 // 此时数组长度会变为3去存储1
```

## 函数

### 函数定义

```js
function fname(a,b){
    return res;
}
var fname = function(a,b){
    return res;
}
// 新增的箭头函数
var fname = ()=>{}
```

### 隐形参数列表

```js
function fun(){
    alert(arguments.length)
}
```

## 对象

### 定义一个对象

```js
var obj = new Object();
obj.name = "slh"
obj.name = 18
obj.func = functiom(){
    
}
```

### 调用

```js
alert(obj.name)
```

### 使用大括号定义对象

```js
var obj = {
    name:"slh",
    age:18,
    func:function(){
        
    }
}
```

## 事件监听

### 常用事件

> onload 加载完成事件 页面加载完成之后
>
> onclick 单击事件 常用于按钮的点击相应操作
>
> onblur 失去焦点事件 常用于输入框失去焦点后验证内容
>
> onchange 内容发生改变事件 下拉列表输入框内容改变
>
> onsubmit 表单提交事件 用于表单提交前,验证所有表单项是否合法

## DOM模型

## 正则表达式

判断用户名和密码是否符合格式

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <title>Title</title>
    <link rel="stylesheet" href="..
                /font-awesome-4.7.0/css/font-awesome.min.css" />
    <script type="text/javascript">
        window.onload = function () {
            var form1 = document.getElementById("form1");
            var username = document.getElementById("username");
            var password = document.getElementById("password");
            var usernametrue = document.getElementById("username-true");
            var passwordtrue = document.getElementById("password-true");
            username.onchange = function () {
                vartest1 = /^\w{6,12}$/;
                var usernamevalue = username.value;
                var bool1 = test1.test(usernamevalue);
                if (!bool1) {
                    usernametrue.innerHTML = "<i class=\"fafa-times\"aria-hidden=\"true\"></i>";
                } else {
                    usernametrue.innerHTML = "<i class=\"fafa-check\"aria-hidden=\"true\"></i>";
                }
            }
            password.onchange = function () {
                var test1 = /^\w{6,12}$/;
                var passwordvalue = password.value;
                var bool2 = test1.test(passwordvalue);

                if (!bool2) {
                    passwordtrue.innerHTML = "<i class=\"fafa-times\"aria-hidden=\"true\"></i>";
                } else {
                    passwordtrue.innerHTML = "<i class=\"fafa-check\"aria-hidden=\"true\"></i>";
                }
            }
        }
    </script>
</head>

<body>
    <form action="www.baidu.com" method="post" id="form1">
        <input type="text" id="username">
        <span id="username-true"></span><br>
        <input type="password" id="password">
        <span id="password-true"></span><br>
        <input type="submit"><br>
    </form>
</body>

</html>
```



