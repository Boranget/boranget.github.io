---
title: JavaWeb
date: 2022-12-08 16:50:30
tags:
  - web基础
categories:
  - 笔记
---

# 一些经验

- vscode liveserver插件需要在文件夹中打开文件
- shift + 刷新 强制刷新

# HTML

## 语义

标签的默认效果不重要，语义最重要

1. 代码的可读性
2. 利于SEO 
3. 方便盲人阅读器等设备解析

## 文档声明

```html
H5：
<!DOCTYPE html>
不声明可能会触发怪异模式
```

## 编码

决定了浏览器打开文档的编码

```html
<head>
    <meta charset="UTF-8">
</head>
```

## 语言

可提供给浏览器的翻译功能使用

```html
<html lang = "en">
    
</html>
```

## 图标

图标放到根目录命名为favicon.ico

## 注释

```html
<!-- annotation -->
注释不可嵌套，可多行
```

## 排版标签

- h：标题

- p：段落

  段落中不能嵌套标题或div甚至p

- div：无语义

```html
<!-- 默认占满一行 -->
<div>div1</div>
<div>div2</div>
<!--span标签的长度取决于其内容-->
<span>span1</span>
<span>span2</span>
<!--p标签会上下各空一行，如果已有空行则不空-->
<p>p1</p>
<p>p2</p>
```

- br 换行
- hr 分割线
- pre 按照源代码排版显示

## 块级标签和行内标签

块级元素会独占一行

- 块级元素中可以嵌套块级元素和行内元素
  - h元素不能互相嵌套
  - p标签中不能写块元素

行内元素中可以写行内元素，当不能写块级元素 

## 文本标签

- em 着重内容
- strong 比em重
- span 无语义
- i 多用于呈现字体图标 

## 超链接  

- herf 打开链接
- target 在哪打开

```html
<a href="http://www.baidu.com">baidu</a>
<a href="http://www.baidu.com" target="_self">baidu self</a>
<a href="http://www.baidu.com" target="_blank">baidu blank</a>
<a href="http://www.baidu.com" target="_parent">baidu parent</a>
<a href="http://www.baidu.com" target="_top">baidu top</a>
```

超链中不可嵌套超链接，可嵌套除超链接以外的任何元素

- download 属性可以触发下载，而不是直接展示

### 锚点

```html
# 定义
<a name = "htl"></a>
<p id = "atm"></p>
# 跳转
<a href = "#htl"></a>
<a href = "#atm"></a>
<a href = "#">回到顶部</a>
<a href = "">刷新当前页面</a>
```

### 执行js

```html
<a href = "javascript:alert("666");"></a>
```

### 唤醒应用

```html
<a href = "mailto:123@qq.com"></a>
<a href = "tel:10086"></a>
<a href = "sms:10086"></a>
```



## 列表

- 有序 ul li
- 无序 ol li
- 自定义 dl dt dd

```html
<ul>
    <li>
        zhaosi
    </li>
    <li>
        liuneng
    </li>
    <li>
        <a href="baidu.com"></a>
    </li>
    <li>
        <ol>
            <li>
                huwen
            </li>
            <li>
                anshang
            </li>
        </ol>
    </li>
    <li>
        abaaba
    </li>
</ul>
<!--有序列表ol-->
<ol>
    <li>
        xiaoshenyang
    </li>
    <li>
        songxiaobao
    </li>
</ol>

<dl>
<dt>列表标题</dt>
<dd>列表内容</dd>
<dd>列表内容</dd>
</dl>

```

```html
<ul type="none">
    <!--无序列表，type为none没有前面的点-->
    <li>ahahahah</li>
    <li>dsdsdsd</li>
    
</ul>
```



##  内联框架

```html
<!--内联框架，name取名-->
<iframe src="formtest.html", width="500", height="500", name = "framtest"></iframe>
<!--在name属性为“framtest”的框架中打开链接-->
<ul>
    <li><a href = "formtest.html", target="framtest">点我</a></li>
</ul>
```

## 图片

```html
<!--alt为图片加载不出来时显示的文字，src为图片地址-->
<img alt="图片已失效" border="1" weight="200" ,height="300"
    src="https://scpic.chinaz.net/files/pic/pic9/201311/apic2098.jpg" />
```

**防盗链**

图片地址可以直接访问，且可显示图片，但不能放入图片标签的src中

**格式**

- webp 谷歌推出的图片格式，可透明可动态占用空间小保留细节多，但是只有谷歌浏览器内核支持
- base64格式，src属性直接填图片的base64编码

## 表格

```html
<!--border为边框，align为位置，cellspacing为表格间距-->
<table border="10" width="500" height="500" align="center" cellspacing="5">
    <caption>表格标题</caption>
    <thead>
    	<tr>
        	<th></th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <!--
                rowspan，colspan为一个表格合并的方向与大小
                colspan为横向
                rowspan为纵向
            -->

            <td rowspan="2">1.1</td>
            <td>1.2</td>
            <td>1.3</td>
            <td colspan="2" ,rowspan="2">1.2</td>
        </tr>
        <tr>
            <td>1.2</td>
            <td>1.3</td>
            <td colspan="2">1.4</td>
        </tr>
        <tr>
            <td>1.1</td>
            <td>1.2</td>
            <td>1.3</td>
            <td>1.4</td>
            <td>1.5</td>
        </tr>
        <tr>
            <th colspan="3">
                1.4
            </th>
            <td>1.2</td>
            <td>1.3</td>
        </tr>
    </tbody>
    <tfoot></tfoot>
</table>
```

![image-20221102133334436](JavaWeb/image-20221102133334436.png)

## 元数据

```html
<meta charset="UTF-8">
```

## 表单

```html
 <form action="https://www.baidu.com" method="get">
        <!--
        发送格式为：
        https://www.baidu.com/?
        name=admin&
        password=ammins&
        passwordc=admins&
        sex=man&
        interest=1&interest=2&interest=3&
        country=japanesessssssssssss&
        self_ass=%E8%87%AA%E6%88%91%E8%AF%84%E4%BB%B7%E5%86%85%E5%AE%B9
        -->
        <!--
            表单项需要有name属性才能组合到请求参数
            单选/多选/下拉列表框需要value值
            下拉框option若无value值会使用标签内容提交
            若下拉框option有value值会使用value值
            get方法能看到参数
            post方法看不到参数
        -->

        用户名称：<input type="text" name="name" /><br>
        用户密码：<input type="password" name="password" /><br>
        确认密码：<input type="password" name="passwordc" /><br>
        性别：<input type="radio" value="man" name="sex" checked="checked" />man<input type="radio" value="woman"
            name="sex" />woman<br>
        兴趣爱好：
        <input type="checkbox" value="1" name="interest">1
        <input type="checkbox" value="2" name="interest">2
        <input type="checkbox" value="3" name="interest">3<br>
        国籍：
        <select name = "country">
            <option value="none">--please select--</option>
            <option value="china">chaina</option>
            <option>americanaaaa</option>
            <option value="japanesessssssssssss">japanese</option>
        </select><br>
        自我评价：<textarea rows="10" name="self_ass" cols="20"></textarea><br>
        <input type="reset" , value="reset" />
        <input type="submit" , value="submet" />
        <input type="button" , value="button" />
        <input type="button" , value="button" />
        <input type="file" ,value="file" />
        <input type="hidden">
    </form>
```

![image-20221102140935231](JavaWeb/image-20221102140935231.png)

# CSS

cascading style sheet

## 选择器

- 标签名选择器

```css
table{
	border: red 1px solid;
}
```

- id选择器
```css
#idname{
	border: red 1px solid;
}
```
- class选择器
```css
.classname{
	border: red 1px solid;
}
```
- 组合选择器
```html
<style>
    /* 类为a 并且 id为id1 */
    .a#id1{
        border: red 1px solid;
    }
    /* 类为a 或者 id为id1 */
    .a,#id1{
        border: red 1px solid;
    }
</style>
```

# JS

## javaScript警告/弹窗

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



# session

## 获取

可通过request的getSession方法来使用session

通过setAttribute方法注入值

通过getAttribute方法获取session中的值

通过removeAttribute()移除某个值

## 意义

客户端与服务端之间的会话是无状态的, 无状态:会话之间无关联性,无法识别该用户曾经访问过

session可以将关键数据存放在服务器端. 与cookie不同,cookie是将数据存放在客户端的浏览器中

## 生命周期

session存储在服务器的内存中for高速存取

### 何时生效

session在用户第一次访问时创建,需要注意只有访问jsp,servlet时才会创建,而访问html,image等静态资源并不会创建session, 可以调用request.getSession(true)强制创建

### 何时失效

服务器会把长时间没有活动的session从服务器内存中清除,此时session失效, tomcat中的session默认失效时间为20分钟

一旦session被访问,计时清零

或者可以调用sessioin的incalidate方法可以主动清除

### 设置失效时间

web.xml方式:

```xml
<session-config>
    <session-timeout>30</session-timeout>
</session-config>
```



动态设置

```java
request.getSession().setMaxInactiveInterval(多少秒);
//永不过期
request.getSession().setMaxInactiveInterval(-1);
```

tomcat server.xml中设置

```xml
<Context path="/livsorder" 
docBase="/home/httpd/html/livsorder" 　　defaultSessionTimeOut="3600" 
isWARExpanded="true" 　　
isWARValidated="false" isInvokerEnabled="true" 　　isWorkDirPersistent="false"/>
```

## 原理

在客户端浏览器cookie保存sessionID,客户端发送请求时会携带

该cookie值一般为服务器自动生成,仅在当前浏览器有效,各浏览器之间不共享,关闭整个浏览器就会失效,但是由浏览器内的链接,脚本等打开的新窗口会共享父窗口的cookie,也就是会共享一个session

## 不支持解决

如果客户端浏览器将Cookie功能禁用，或者不支持Cookie怎么办？例如，绝大多数的手机浏览器都不支持Cookie。Java Web提供了另一种解决方案：URL地址重写。

URL地址重写是对客户端不支持Cookie的解决方案。URL地址重写的原理是将该用户Session的id信息重写到URL地址中。服务器能够解析重写后的URL获取Session的id。这样即使客户端不支持Cookie，也可以使用Session来记录用户状态。HttpServletResponse类提供了encodeURL(String url)实现URL地址重写，该方法会自动判断客户端是否支持Cookie。如果客户端支持Cookie，会将URL原封不动地输出来。如果客户端不支持Cookie，则会将用户Session的id重写到URL中。

TOMCAT判断客户端浏览器是否支持Cookie的依据是请求中是否含有Cookie。尽管客户端可能会支持Cookie，但是由于第一次请求时不会携带任何Cookie（因为并无任何Cookie可以携带），URL地址重写后的地址中仍然会带有jsessionid。当第二次访问时服务器已经在浏览器中写入Cookie了，因此URL地址重写后的地址中就不会带有jsessionid了。