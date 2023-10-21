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

## meta

- 编码

    决定了浏览器打开文档的编码

    ```html
    <head>
        <meta charset="UTF-8">
    </head>
    ```

- ie兼容配置

    针对ie浏览器的兼容性配置

    ```html
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    ```

- 移动端适配

    ```html
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    ```

- 关键词和描述

    ```html
    <meta name="keywords" content="博客,boranget,技术">
    <meta name="description" content="boranget的博客"
    ```

- 爬虫设置

    ```html
    <meta name="robots" content="...">
    ```

- 自动刷新/跳转

    ```html
    <meta http-equiv="refresh" content="3;url=http://baidu.com">
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

- 除了网页还可以嵌入比如图片视频等其他内容
- name可作为a的target

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

- action 地址 method请求方式 target 打开方式

- radio name相同会划分进同一组，只能选一个
- type="hidden"
- intput type="reset" 相当于 button type="reset"
- button 默认为submit，若需要无功能，type为button 
- disabled 禁用
- label 比直接用文子做标签的好处在于，点击label可以为其for属性的对象获取焦点，或者用label标签将两个对象框在一起
- 预选类的组件要设置value，用于提交的值

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
            <option value="china" selected>chaina</option>
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

### fieldset

可以分栏表单

```html
<fieldset>
    <legend>
        主要信息
    </legend>
     用户名称：<input type="text" name="name" /><br>
     用户邮箱：<input type="text" name="name" /><br>
</fieldset>
<fieldset>
    <legend>
       次要信息
    </legend>
     qq：<input type="text" name="name" /><br>
</fieldset>
```

## 字符实体

- \&nbsp; 空格（包含分号）
- \&lt; 小于
- \&gt; 大于
- \&amp; &

## 全局属性

各种标签都有

- id
- class
- style
- dir
- title

# CSS

cascading style sheet

## 行内样式

标签的style属性中，又称内联样式

```html
<h1 style="color: aliceblue;font-size: 60px;"
```

## 内部样式

定义在html内部

```html
 <style>
     h1{
         color:green;
     }
     h2{
         color:green;
     }
</style>
```

## 外部样式

在HTML文件中引入

```html
<link rel = "stylesheet" href="./xxx.css">
```

实际开发中常用，结构清晰

css文件

```css
h1{
    color:green;
}
h2{
    color:green;
}
```

## 优先级

行内样式最优先，内外部相同，谁后定义的用谁

## 元素间关系

- 父元素：**直接**包裹某个元素的元素称为其父元素
- 子元素：被父元素**直接**包含的元素

## 选择器

### 种类

- 通配选择

    ```css
    * {
    	border: red 1px solid;
    }
    ```

    

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

    一个标签只能有一个class属性，但class属性中可包含多个class，多个class的顺序不影响覆盖顺序，覆盖顺序还是由class选择器的声明顺序决定。

    ```html
    <h1 class = "class1 class2">标题</h1>
    ```

- 组合选择器
  
    ```html
    <style>
        /* 交集，中间无间隔：类为a 并且 id为id1 */
        .a#id1{
            border: red 1px solid;
        }
        /* 并集，逗号分隔：类为a 或者 id为id1 */
        .a,#id1{
            border: red 1px solid;
        }
    </style>
    ```

- 后代选择器（包括子代）

    ```css
    /*ul中的li元素*/
    ul li{
        ...
    }
    ```

- 子代选择器（直接子代）

    ```css
    /*ul下的直接li元素*/
    ul>li{
        ...
    }
    ```

- 后邻居（直接后兄弟）

    ```css
    /*ul后紧挨着的ul*/
    ul+ul{
        ...
    }
    ```

- 全部后兄弟

    ```css
    /*ul后所有兄弟中的ul*/
    ul~ul{
        ...
    }
    ```

- 属性选择器

    ```css
    /*选中具有title属性的元素*/
    [title]{
        ...
    }
    /*选中具有title属性且值为hello的元素*/
    [title="hello"]{
        ...
    }
    /*正则？选中具有title属性且值为h开头的元素*/
    [title^="h"]{
        ...
    }
    /*正则？选中具有title属性且值为o结尾的元素*/
    [title$="o"]{
        ...
    }
    /*正则？选中具有title属性且值包含o的元素*/
    [title*="o"]{
        ...
    }
    ```

### 伪类选择器

根据元素状态的分类，与class属性无关

格式为冒号加选择器名

- 动态伪类

    注意这个声明顺序会影响具体的表现
    
    ```css
/*没有选择过的a标签*/
    /*冒号link和a是交集选择器的使用*/
    a:link{
    
    ```

}
    /*选择过的a标签*/
    a:visited{
    
}
    /*鼠标正在悬停的a标签*/
    a:hover{
    
}
    /*鼠标按下的a标签*/
    a:active{
    
    }
    ```
    
    ```css
    /*表单类元素获取焦点*/
    input:focus{
    
    }
    ```

- 结构伪类

    ```css
    /*父元素的第一个孩子*/
    :first-child{
        
    }
    /*父元素的最后一个孩子*/
    :first-child{
        
    }
    /*父元素的第3个孩子*/
    /*2n|even表示偶数个，2n+1|odd表示奇数个*/
    /*an+b*/
    :nth-child(3){
        
    }
    /*倒着*/
    :nth-last-child(3){
        
    }
    /*div的直接子类中元素为p且为父元素的第一个孩子*/
    div>p:first-child{
        
    }
    /*当前级同类型中的第一个孩子*/
    :first-of-type{
        
    }
    /*当前级同类型中的最后一个孩子*/
    :last-of-type{
        
    }
    /*当前级同类型中的第2个孩子*/
    :nth-of-type(2){
        
    }
    /*倒着*/
    :nth-last-type(3){
        
    }
    /*唯一的孩子*/
    :only-child(3){
        
    }
    /*根*/
    :root{
        
    }
    /*空*/
    :empty{
        
    }
    /*排除*/
    not(p){
        
    }
    ```

- UI伪类

    ```css
    /*被选中的复选框*/
    input:checked{
        
    }
    /*被禁用的*/
    input:disabled{
        
    }
    ```

- 目标伪类

    ```css
    /*地址栏锚点，a的#href*/
    :target{
        
    }
    ```

- 语言伪类

    ```css
    /*lang为en的*/
    :lang(en){
        
    }
    ```

- 伪元素选择器

    ```css
    /*第一个字符*/
    ::first-letter{
        
    }
    /*第一行*/
    ::first-line{
        
    }
    /*选中的内容*/
    ::selection{
        
    }
    /*input中的提示*/
    input::placeholder{
        
    }
    /*前缀*/
    p::before{
        content:"￥"
    }
    /*后缀*/
    p::after{
        content:".00"
    }
    ```

### 优先级

id选择器 > class选择器  >  元素选择器 > 通配选择器

组合选择器需要计算权重

 a->b->c依次比较如下选择器，相同则比较其他，不同则当前谁多谁优先

a: id选择器个数

b: 类、伪类、属性选择器个数

c: 元素、伪元素选择器个数

**css中属性后加空格！important可保证优先级最高**

## CSS特性

- 层叠性：解决样式冲突问题 
- 继承性：继承其父元素的某些样式，比如字体颜色等，优先继承离得近的父
- 优先级

## 像素px

 比较精细的长度单位，适合显示器显示内容的长度

## 颜 色

- 颜色名
- RGB （可带α通道0-1）
- HEX  16进制rgb，可带透明通道 ，00表0，ff表1
    - ie不支持透明度
- HSL：hsl（色相，饱和度，亮度）

## 字体

- font-size 字体大小
    - 浏览器可以调最小字号，小于该字号会展示最小字号
    - 由于字体大小可以继承，可以给body设置字体大小来设置全局字体大小
    
- font-family 字体族

    - 可以给某元素定义多个字体，统称为字体族，从前往后依次检查是否能使用该字体

    - 衬线字体与非衬线字体   
        - 衬线字体族最后可加 serif 告诉浏览器自适应
        - 非衬线体族最后可加 sans-serif

- font-style 字体样式/字体风格

    -  normal 正常字体
    - italic 寻找倾斜字体，没有则强制倾斜
    - oblique 强制倾斜

- font-weight

    - lighter
    - normal
    - bold
    - bolder

- font

    - \* \* 字体大小 字体族
    - 各个属性之间空格隔开
    - 字体大小字体族必写且顺序且必须在最后两位

## 文本

 - 文本颜色 直接定义标签color

    背景色是background-color

- 文本间距  letter-spacing 单位像素，可为负值
- 单词间距 word-spacing  单位像素，通过空格识别
- 文本修饰  text-decoration
    -  位置
        - overline
        - underline
        - line-through
        - none 可以去掉超链接的下划线 
    - 样式
        - dotted
        - wavy
    - 颜色
- 文本缩进
  
    - 首行缩进 text-indent
- 文本对齐 text-aline
  
- left right center
  
- 行高 line-height，不是行与行之间的距离，但会影响
    - 取值   
        - normal 浏览器决定
        - 像素
        - 数字（比例）建议
        - 百分比
    - 现象
        - 行高过小，文字会重叠
        - 行高可继承
        - 与height的关系
            - 没写height，随lineheight变化
            - 写了height，各自为值
    - 主要应用
        - 调整多行文字间距
- 垂直对齐 vertical-align 只能控制父元素中的子行内元素，不能直接控制文本（但可控制表格单元格内文本）
    - top
    - bottom
    - baseline
    - middle(与父元素中的小写X垂直居中)

## 列表

- list-style-type 列表样式（符号）
- list-style-position 位置
    - inside
    - outside
- list-style-image 列表符号改为图片
- 复合属性 list-style

## 表格

- 边框（除表格外，其余元素也能用）
    - 粗细 border-width
    - 颜色 border-color
    - 样式 border-style
    - 复合 borde
- 列宽 table-layout
    - auto
    - fixed
- 单元格间距 border-spacing
- 合并单元格边框 border-collapse（间距失效）
    - collapse
- 隐藏没有内容的单元格 empty-cells: hide

## 背景

- 背景颜色 background-color
- 背景图片 background-image
    - 重复方式 background repeat/repeat-x/repeat-y
        - no-repeat 不重复
    - 位置 background-position
        - left top right bottom center
        - x,y
- 复合属性 background

## 悬停鼠标

- cursor
    - wait
    - move
    - ....
    - url(图片地址)

## 盒子模型

### 长度单位

- px 像素
- em 当前元素或其父元素的fontsize值的倍数，适合用在字体缩进
- rem html的fontsize

### 显示模式

### 分类

- 块元素
    - 页面中独占一行 
    - 默认宽度是撑满父元素 
    - 默认高度由 内容撑开
    - 可通过css设置宽高
- 行内元素
    - 页面中不独占一行，从左到右排列，自动换行
    - 默认宽度由内容撑开
    - 默认高度由内容撑开
    - 无法通过css设置宽高
- 行内块元素/内联块元素
    - 页面中不独占一行，从左到右排列，自动换行
    - 默认宽度由内容撑开
    - 默认高度由内容撑开
    - 可通过css设置宽高

### 修改

- display: 
    - none 隐藏
    - block 块级元素
    - inline 行内/内联
    - inline-block 行内块

### 盒子模型组成部分

- 内容 cotent
- 边框 border
    - 背景色也会填充
- 内容和边框中间为内边距  padding
    - 背景色填充 
    - 大小会影响盒子大小
- 边框外面为外边距 margin 
    - 背景色不会影响
    - 大小不会影响盒子大小

### 盒子内容区

- 宽度 width

- 最小宽度 min-width

    上限随页面

- 最大宽度 max-width

    下限随页面

- 高度 height

- 最小高度 min-height

    最大跟随内容

- 最大高度 max-height

    最小跟随内容

- 内边距 padding

    - 不能为负数
    - 行内元素的上下内边距不能完美设置
    - 块级和行内块四个内边距都可以完美设置

- 边框 border

    四个属性分别可以不同方向控制

    - 宽度 border-width/border-left-width
    - 颜色 border-color/border-left-color
    - 样式 border-style/border-left-style

- 外边距 margin

    - margin-left/。。。
    - 子元素的margin是参考父元素对的content计算的
    - 上左margin影响自己的位置，下右margin影响后面兄弟的位置
    - 块级元素、行内块元素可完美设置四个方向的margin，行内元素上下margin无效
    - margin可以是auto，可用于居中
    - 可为负值
    - margin塌陷：第一个，最后一个子元素加margintop和bottom会发生到父元素上
        - 父元素设置边框
        - 父元素设置内边距
        - 父元素设置overflow: hidden (建议)
    - 上下margin会与兄弟的重叠，取最大值

## overflow

溢出元素的处理，可显示，隐藏，默认显示滚动条或者自动

## 隐藏

- display: none 不占位
- visiable: hidden 占位

## 样式继承

字体属性、文本属性（除了vertical-align）、文字颜色等

## 布局技巧

- 行内元素、行内块元素可以被父元素当作文本处理

    可以像处理文本对齐一样，处理行内或行内块元素在父元素中的对齐，例如tex-alogn、line-height、text-indent等

- 子元素在父元素中水平居中
    - 子元素为块元素，子元素加上margin: 0 auto
    - 子元素为行内/块元素，父元素添加 text-align: center
- 子元素在父元素中垂直居中
    - 子元素为块元素，子元素添加margin-top，值为父元素content-子元素盒子总高后再除2
    - 子元素为行内/块元素 父元素的height=line-height（不是减号），给每个子元素添加vertical-align: middle 若想设置绝对垂直居中，父元素font-size 设置为0
- 元素间由于代码中换行导致的空白问题
    - 去掉源码中的换行和空格
    - 给父元素设置字体大小为0（推荐）
- 行内块的幽灵空白
    - 原因，行内块与文本基线对齐，基线离文字底部有距离
    - 解决
        - 行内块设置vertical，值不为baseline
        - 设置图片为块显示
        - 设置字体大小为0

## 浮动

- 元素浮动后的特点

    - 感觉像是变成了行内块
    - 脱离文档流
    - 默认内容撑开，可设置宽高
    - 不会独占一行 
    - 可设置margin
    - 不会像行内块一样被当成文本处理
    - 后兄弟元素会占据浮动元素之前的位置，对前兄弟无影响
    - 不能撑起父元素高度，但父元素宽度依然束缚浮动的元素

- 解决浮动产生的影响

    - 给父元素指定高度

    - 给父元素设置浮动（带来其他影响）

    - 给父元素设置overflow: hidden

    - 在所有浮动元素后面添加一个块级元素，给块级元素设置clear: both

    - ```css
        parent::after{
            content: "";
            display: block;
            clear: both;
        }
        ```

    - 原则：兄弟元素要么全部浮动要么全都不浮动

- 浮动练习

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <style>
            /* 清除默认样式 */
            *{
                margin: 0;
                padding: 0;
            }
            /* 浮动公共类 */
            .leftfix{
                float: left;
            }
            .rightfix{
                float: right;
            }
            /* 清除浮动公共类 */
            .clearfix::after{
                content: "";
                display: block;
                clear: both;
            }
            .container{
                width: 960px;
                margin: 0 auto;
                text-align: center;
            }
            .logo{
                width: 200px;
            }
            .banner1{
                width: 540px;
                margin: 0 10px;
            }
            .banner2{
                width: 200px;
            }
            .logo,.banner1,.banner2{
                height: 80px;
                background-color: #ccc;
                line-height: 80px;
            }
            .menu{
                height: 30px;
                background-color: #ccc;
                margin-top: 10px;
                line-height: 30px;
            }
            .item1,.item2{
                width: 368px;
                height: 198px;
                border: 1px solid black;
                margin-right: 10px;
            }
            .content{
                margin-top: 10px;
            }
            .item3,.item4,.item5,.item6{
                width: 178px;
                height: 198px;
                border: 1px solid black;
                margin-right: 10px;
                line-height: 198px;
            }
            .bottom{
                margin-top: 10px;
            }
            .item7,.item8,.item9{
                width: 198px;
                height: 128px;
                border: 1px solid black;
                line-height: 198px;
            }
            .item8{
               margin: 10px 0;
            }
            .foot{
                height:  60px;
                line-height: 60px;
                background-color: #ccc;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="page-header clearfix">
                <div class="logo leftfix">logo</div>
                <div class="banner1 leftfix">banner1</div>
                <div class="banner2 leftfix">banner2</div>
            </div>
            <div class="menu">菜单</div>
            <div class="content clearfix">
                <div class="left leftfix">
                    <div class="top clearfix">
                        <div class="item1 leftfix">栏目一</div>
                        <div class="item2 leftfix">栏目二</div>
                    </div>
                    <div class="bottom clearfix">
                        <div class="item3 leftfix">栏目三</div>
                        <div class="item4 leftfix">栏目四</div>
                        <div class="item5 leftfix">栏目五</div>
                        <div class="item6 leftfix">栏目六</div>
                    </div>
                </div>
                <div class="right leftfix">
                    <div class="item7">栏目七</div>
                    <div class="item8">栏目八</div>
                    <div class="item9">栏目九</div>
                </div>
            </div>
            <div class="foot">页脚</div>
        </div>
    </body>
    </html>
    ```

    ![image-20231016092133377](JavaWeb/image-20231016092133377.png)

## 定位

- 相对定位 position: relative 
    - left:../right/top/bottom
    - 相对于自己原来的位置
    - 盒子模型多个一个position，但不影响其余元素位置
    - 定位元素层级最高，多个定位元素，后写的层级高
    - left和right不能一起设置，left生效
    - top bottom一起设置，top生效
    - 可与浮动，margin同时生效，但不建议使用
    - 多数时候与绝对定位一起使用
    
- 绝对定位 position: absolute 

    绝对定位参考的点是他的包含块（不考虑padding）

    - 包含块
        - 没有脱离文档流，父元素为包含块
        - 脱离文档流的，第一个开启定位的祖先元素，就是他的包含块 
    - 故一般会将父亲开启00的相对定位，以便子元素绝对定位
    - 绝对与浮动共存，浮动失效，绝对定位为主
    - 绝对定位后的元素称为定位元素，默认宽高由内容撑开，可设置宽高

- 固定定位 position: fixed 

    - 直接找视口（非网页）的坐标 ，会随着浏览器上下滚动条移动，而不会因为滚动条移到下方被隐藏
    - 同样，与浮动冲突，且优先级高于浮动
    - 固定定位后的元素称为定位元素，默认宽高由内容撑开，可设置宽高

- 粘性定位 position: sticky 

    - 相对于当前定位元素的最近的、有滚动条的祖先元素（即使不可滚动），且当当前元素的父元素滚动消失后，当前元素会跟随消失

- 图层 z-index

    - 定位元素都会比普通元素高

    - 会被父元素的z影响

- 定位的特殊用法

    - 未设置大小的元素绝对定位同时设置 left和rignt，可用于设置宽度，未设置大小的元素  绝对定位同时设置 top和bottom，可用于设置宽度。如果设置了大小，可用此方法加margin auto实现居中

## 布局

- 版心

    版心大小固定且水平居中，显示网页主要内容

    一般在960-1200之间 

- 响应式

    随屏幕大小变化

## 清除默认样式

- 通配符选择器*
- reset.css
- normalize.css

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