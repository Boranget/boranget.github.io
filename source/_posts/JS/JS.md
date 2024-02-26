---
title: JS
date: 2022-12-08 16:50:30
updated: 2023-11-06 10:35:19
tags:
  - web基础
categories:
  - 笔记
---

也叫ES ECMAScript

前身是网景公司开发的livescript

# 引入方式

- 内嵌式 script标签内编写
- 外部引用 script src属性，需要有开始和结束标签

# 事件监听

## 常用事件

- 鼠标事件
    - onclick 单击事件 常用于按钮的点击相应操作
    - ondbclick 双击
    - onmouseover 鼠标悬停
    - onmousemove 鼠标移动
    - onmouseleave 鼠标离开
- 键盘事件
    - onkeydown
    - onkeyup
- 表单事件
    - onfocus 获得焦点事件 
    - onblur 失去焦点事件 常用于输入框失去焦点后验证内容
    - onchange 内容发生改变事件 比如输入框中内容改变后失去焦点或者下拉列表输入框内容改变
        - 可传参数 (this.value) 将改变后的值传到响应函数
    - onsubmit 表单提交事件 用于表单提交前,验证所有表单项是否合法
        - 在方法中可阻止表单的默认行为 
            - event.preventDefault()
            - 事件中return false且绑定事件时方法名前加return关键字
    - onreset 表单重置
- 其他事件 
    - onload 加载完成事件 页面加载完成之后自动执行，此时所有元素阅读完毕，可以开始绑定事件
        - window.onload=function(){}

## 特点

- 一个事件可以绑定多个函数
- 一个元素可以监听多个事件
- 可以用元素的属性绑定方法

# 打印

- 控制台打印 console.log()
- 窗口打印 document.write()

# 窗口操作

## 打开新窗口

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

## 关闭窗口

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

  

# HTML元素操作

## 通过ID获取元素

```js
document.getElementById("id")
```

## innerHTML属性

```js
object.innerHTML
```

用于获取html标签内部的内容,不包括标签本身

## 更改html元素样式

```html
<p id = "pid">样式修改测试</p>
<script>
    var pid = document.getElementById("pid")
    pid.style.color="red"
</script>
```

通过style.display可以设置元素是否显示

## 控制类名

```js
object.className = classname
```

# 变量

js变量为弱类型但不是没有类型，通过var关键字赋值

## 数据类型

可通过typeof(i) 判断i的类型

- 数值类型 number
- 字符串类型 string
- 布尔类型 boolean
- 引用类型 Object，可赋值为null
- function类型 function
- undefind 未定义 没有赋值的变量值为undefined，且类型也为undefind

## 赋值关键字

### var

- 弱类型变量可统一声明成var
- var声明的变量可再次声明
- 变量可使用不同的数据类型多次赋值
- JS的语句可以以";"结尾也可以不用";"结尾
- 变量标识符严格区分大小写
- 命名规则参照JAVA
- 如果使用未声明变量，会报错 ** is not defined
- 如果变量只声明没赋值，其值为undefind

### let

### const

# 数组

同样与别的语言不同: js中的数组是非定长的，可以在程序的运行过程中改变数组的长度，其长度取决于最后一个存储了有效值的位置。

例如：

```js
var x = []
x[2] = 1 // 此时数组长度会变为3去存储1
// 静态初始化方式为写在中括号中
var arr = ["a","b","c"]
```

- 可通过arr.length=n将数组长度设为n

**创建**

- new Array() 创建一个数组
- new Array(5) 返回一个长度为5的数组
- new Array("张三",2,3) 创建一个数组，并定义其中数据

**其他API**

- arr1.concat(arr2) 创建一个数组为arr1和arr2拼接的结果且不影响原数组
- pop push
- indexOf lastIndexOf
- reverse 反转
- join 连接符
- slice 截取，两个index，包左不包右
- splice 添加且删除元素

# 运算符

## 算术运算符

+, -, *, /, %

- 除0，其值为Infinity

- 模0，其值为NaN

## 复合算数

++, --, +=...

- 除等0，其值为Infinity

- 模等0，其值为NaN

## 关系运算符

\>, <, >=, <=, !=, ==, ===

- == 字面值的比较，如果类型不一致，会将两端转换为number
    - '123' -> 123
    - true -> 1,false -> 0

- === 字面值加类型的比较



## 逻辑运算符

|| &&

- 0, null, undefinde, ""空串都认为是false值
- 非空字符串，非空对象，非0数字为true

与其他语言不同的是，js中的逻辑运算并不是返回true或false，而是返回做逻辑运算中的值，返回哪个值取决于在哪个值可以决定的当前表达式的真假性，根据与短路运算：

&& 运算

当表达式全为真，只有到最后一个值才能决定当前表达式的值，所以返回最后一个表达式的值：1&&2&&3&&4返回4

当表达式的值为假，则返回第一个假值：null&&true 会返回null

|| 运算

当表达式全为假，返回最后一个表达式的值：null||false||0 会返回0

当表达式中有一个真，则返回第一个真值：false||1||2 会返回1

## 条件运算符

表达式?值:值

## 位运算符

|, &, ^, <<, >>, >>>

# 流程控制

## 分支结构

```js
if(){
   
}else if(){
            
}else{
    
}
switch(){
       case 1:
       break;
       default:
}
```

## 循环结构

**for**

```js
for(var i = 1; i <=9; i ++){
    
}
```



**foreach**

把冒号换成in，且i不会赋值为数组中的元素，而是被赋值为数组中元素的索引

```js
for(var i in arr){
   var a = arr[i];
}
```

# 函数

## 特点

- 没有访问修饰符
- 没有返回值类型也没有void，有值返回直接return
- 没有异常列表 
- 调用时实参和形参数量可以不一致
- 函数可以作为参数传递给其他函数

## 函数定义

```js
/*1.*/
function functionname(a,b){
    return res;
}
/*2.*/
var functionname = function(a,b){
    return res;
}
// 新增的箭头函数
var functionname = ()=>{}
```

## 隐形参数

```js
function fun(){
    // 可以查看完整的参数列表
    alert(arguments.length)
}
```

# 对象

## 创建对象

```js
// 方式1
var obj = new Object();
obj.name = "slh"
obj.age  = 18
obj.eat = function(a){
    
}
// 方式2
var name = {
    name:"slh",
    age:18,
    eat:function(a){
        
    }
}
```

## 调用

```js
alert(obj.name)
```

# JSON

 用于前后端数据交互 

```js
// 最外层可用单引号
var str = '"a":"aname","b":"bname"';
// 字符串转换为对象   
var obj = JSON.parse(str)
console.log(obj.a);
// 对象转为JSON字符串
JSON.stringify(obj)
```

# 常用对象

- var date = new Date()

    date.getHours().....

    date.setFullYear(2022)

- Math. 

# BOM编程

浏览器对象模型

window的属性：

- history 历史
- location 地址栏
- document 浏览器打开的网页文档
- console 控制台
- screen 屏幕
- navigator 浏览器本身
- sessionStorage 会话级存储
- localStorage 持久级存储

## 弹窗

window.alert，但window.可以省略

- alert(字符串或变量)

    ```html
    <script type="text/javascript">
        var mynum = 30
        alert("hello")
        alert(mynum)
    </script>
    ```

- confirm(字符串或变量)

    用户点击确定返回true,点击取消返回false

    ```html
    <script type="text/javascript">
    var mynum = 20
    var one = confirm("hello:"+mynum)
    confirm(one)
    </script>
    ```

- prompt(标题,内容)

    点击确定会返回内容,内容为空返回空字符串

    点击取消返回null

    ```html
    <script type="text/javascript">
        var mynum = 20
        var str = prompt("aa",mynum)
        alert(str)
    </script>
    ```


## 定时任务

```js
window.setTimeout(function(){
    // 只能执行一次，两秒后执行
},2000)
```

```js
 window.setInterval(() => {
    window.setTimeout(function () {
      var source = lines[l].source;
      var target = lines[l].target;
      var sourceItem = items[source];
      var targetItem = items[target];
      sourceItem.symbolSize = 30;
      targetItem.symbolSize = 30;
      lines[l] = {
        source: lines[l].source,
        target: lines[l].target,
        lineStyle: {
          color: '#f00',
          width: 5
        }
      };
      // sourceItem.label.show = true;
      // targetItem.label.show = true;
      myChart.setOption(option);
      sourceItem.symbolSize = 10;
      targetItem.symbolSize = 10;
      // sourceItem.label.show = false;
      // targetItem.label.show = false;
      lines[l] = {
        source: lines[l].source,
        target: lines[l].target,
        lineStyle: {
          color: 'blue',
          width: 1
        }
      };
      l = (l + 1) % linesSize;
    }, 0);
  }, 1000);
```

## 前后翻页

```js
history.back() // 向前
history.forward() // 向后
history.go()//1...向前翻几页
```

## 跳转

```js
location。href="http://www.ffff.com"
```

## 存储

```js
sessionStorage.setItem("key","v")// 浏览器重启消失
localStorage.setItem("key","v")
sessionStorage.getItem("key")
localStorage.getItem("key")
sessionStorage.removeItem("key")
localStorage.removeItem("key")
```



# DOM编程

文档对象模型，可修改页面内容

document本质是个树状对象 

dom树上的节点类型

- node节点
    - 元素节点 element 标签
    - 属性节点 attribute 属性
    - 文本节点 text 双标签中的文字 

![image-20231102192015382](JS/image-20231102192015382.png)



## 获取dom树

window.document，window.可省略

## 从document中获取要操作的元素

- 直接获取

    - document.getElementById(“”) // 根据id获取唯一元素

    - document.getElementsByTagName(“”) // 根据标签名获取多个元素，获取到一个collection，可通过方括号+下标获取

    - document.getElementsByName(“”) // 根据Name属性获取多个元素 

    - document.getElementsByClassName(“”) // 根据ClassName属性获取多个元素 

- 间接获取

    - document.getElementBy..().children // 通过父元素获取全部子元素

        document.getElementBy..().firstElementChild // 通过父元素获取第一个子元素

        document.getElementBy..().lastElementChild // 通过父元素获取最后一个子元素

    - document.getElementBy..().parentElement // 通过子元素获取父元素

    - document.getElementBy..().previousElementSibling // 通过当前元素获取兄弟元素

        document.getElementBy..().nextElementSibling // 通过当前元素获取兄弟元素

## 对元素操作

- 操作元素的属性

    获取：元素名.属性名

    修改：元素名.属性名=""

- 操作元素的样式

    元素名.style.样式名=“”

    注意原始样式名中的中划线命名要变成小驼峰

- 操作元素的文本

    元素名.innerText

    或 元素名.innerHTML(可解析标签)

- 增元素

    ```js
    // 创建一个新元素
    var newElement = document.createElement("div");
    // 设置元素的属性、文本、样式
    newElement.id = "newElement";
    newElement.style.color = "red";
    newElement.innerText = "I am New";
    // 将子元素放入父元素
    var parent = document.getElemenstByTagName("body");
    // 追加到父元素中最后
    parent[0].appendChild(newElement);
    // 指定插到谁前
    parent[0].insertBefore(newElement,参照元素);
    // 指定替换谁
    parent[0].replaceChild(newElement,被替换元素);
    ```

- 删元素

    ```
    needRemoveElement.remove()
    // 删除父元素中所有元素
    var fc = parent.firstChild;
    while(fc!=null){
    	fc.remove;
    	fc = parent.firstChild;
    }
    // or
    parent,innerHTML = "";
    ```

    

# 正则表达式

描述字符串格式

## 定义

```js
var reg = /正则表达式/
var reg = /正则表达式/g		全文匹配
var reg = /正则表达式/i		忽略大小写
```

## 校验

```js
reg.test(str)
```

## 匹配

```js
var res = str.match(reg)
```

## 替换

```js
var after = str.replace(reg,'用于替换的文本')
```

## 一些规则

- 开头^ 结尾$ 方便控制长度
    - ^java$ 只能匹配java不能匹配javajava，因为正则表达式中只控制了四个字符，没有允许四个外字符的出现
- [] 表示一位的规则，一个方括号表示一位
- \- 从哪个字符到哪个字符 
    - [a-zA-Z0-9_] 字母数字下划线
- {}前一位的规则可以重复多少次
    - {5,9}重复5到9次
    - 简化写法（不需写在大括号里）：+前一位规则出现1到多次，*出现零到多次
- ()包裹住某个规则便于重复

## 常用

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



