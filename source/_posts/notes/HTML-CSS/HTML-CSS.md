---
title: HTML-CSS
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

![image-20221102133334436](HTML-CSS/image-20221102133334436.png)

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

![image-20221102140935231](HTML-CSS/image-20221102140935231.png)

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

    ![image-20231016092133377](HTML-CSS/image-20231016092133377.png)

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

    - 未设置大小的元素绝对定位同时设置 left和rignt，可用于设置宽度，未设置大小的元素  绝对定位同时设置 top和bottom，可用于设置高度。如果设置了大小，可用绝对定位（l,r,t,b=0）加margin auto实现居中

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

## 布局练习

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>尚品汇</title>
    <link rel="shortcut icon" href="./favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="./css/reset.css">
    <link rel="stylesheet" href="./css/index.css">
</head>

<body>
    <!-- 顶部导航条 -->
    <div class="topbar">
        <!-- 版心 -->
        <div class="container clearfix">
            <!-- 左侧欢迎区 -->
            <div class="welcome leftfix">
                <span class="hello">尚品汇欢迎您</span>
                <span>请</span>
                <a href="" class="login">登录</a>
                <a href="" class="register">免费注册</a>
            </div>
            <!-- 右侧导肮区 -->
            <div class="topbar-nav rightfix">
                <ul class="list clearfix">
                    <li><a href="#">我的订单</a></li>
                    <li><a href="#">我的购物车</a></li>
                </ul>
            </div>
        </div>
    </div>
    <!-- 头部 -->
    <div class="header">
        <div class="container clearfix">
            <div class="logo leftfix">
                <img src="./images/logo.png" alt="logo">
            </div>
            <div class="search rightfix">
                <form action="#">
                    <input type="text">
                    <button></button>
                </form>
            </div>
        </div>
    </div>
    <!-- 主导航区 -->
    <div class="main-nav">
        <div class="container clearfix">
            <div class="all-types leftfix">全部商品分类</div>
            <ul class="main-nav-list leftfix clearfix">
                <li><a href="#">尚品超市</a></li>
                <li><a href="#">优惠券</a></li>
                <li><a href="#">买啥</a></li>
            </ul>
        </div>
    </div>
    <!-- 主要内容 -->
    <div class="main-content">
        <div class="container clearfix">
            <ul class="slide-nav leftfix">
                <li>
                    <a href="#">手机/运营商/数码</a>
                    <div class="second-menu">
                       
                        <dl class="clearfix">
                            <dt><a href="#">电子书刊</a></dt>
                            <dd><a href="#">电子书</a></dd>
                            <dd><a href="#">电子</a></dd>
                            <dd><a href="#">网络原创</a></dd>
                            <dd><a href="#">数字杂志</a></dd>
                            <dd><a href="#">多媒体图书</a></dd>
                        </dl>
                        <dl class="clearfix">
                            <dt><a href="#">电子书刊</a></dt>
                            <dd><a href="#">电子书</a></dd>
                            <dd><a href="#">电子</a></dd>
                            <dd><a href="#">网络原创</a></dd>
                            <dd><a href="#">数字杂志</a></dd>
                            <dd><a href="#">多媒体图书</a></dd>
                        </dl>
                    </div>
                </li>
                <li><a href="#">电脑/办公</a><div class="second-menu">
                    <dl class="clearfix">
                        <dt><a href="#">电子书刊</a></dt>
                        <dd><a href="#">电子书</a></dd>
                        <dd><a href="#">电子</a></dd>
                        <dd><a href="#">网络原创</a></dd>
                        <dd><a href="#">数字杂志</a></dd>
                        <dd><a href="#">多媒体图书</a></dd>
                    </dl>
                    <dl class="clearfix">
                        <dt><a href="#">电子书刊</a></dt>
                        <dd><a href="#">电子书</a></dd>
                        <dd><a href="#">电子</a></dd>
                        <dd><a href="#">网络原创</a></dd>
                        <dd><a href="#">数字杂志</a></dd>
                        <dd><a href="#">多媒体图书</a></dd>
                    </dl>
                    </div>
                </li>
            </ul>
            <div class="banner leftfix">
                <img src="./images/banner主图.png" alt="banner">
            </div>
            <div class="slide-other leftfix">
                <div class="message">
                    <div class="title clearfix" >
                        <span class="leftfix">商品快报</span>
                        <a href="#" class="rightfix">更多&nbsp;&gt;</a>
                    </div>
                    <ul class="msg-list">
                        <li><a href="#">[特惠]&nbsp;毛衣+直筒裤</a></li>
                        <li><a href="#">[特惠]&nbsp;毛衣+直筒裤</a></li>
                        <li><a href="#">[特惠]&nbsp;毛衣+直筒裤</a></li>
                        <li><a href="#">[特惠]&nbsp;毛衣+直筒裤</a></li>
                    </ul>
                </div>
                <div class="other-nav">
                    <ul class="other-nav-list clearfix" >
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                    </ul>
                   
                    <ul class="other-nav-list clearfix" >
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                    </ul>
                   
                    <ul class="other-nav-list clearfix" >
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                        <li>
                            <div class="picture"></div>
                            <span>话费</span>
                        </li>
                    </ul>
                   
                </div>
            </div>
        </div>
    </div>
    <!-- 秒杀 -->
    <div class="seckill">
        <div class="container clearfix">
            <img src="./images/seckill.png" class="leftfix" alt="秒杀">
            <img src="./images/banner1.png" class="leftfix" alt="秒杀1">
            <img src="./images/banner2.png" class="leftfix" alt="秒杀2">
            <img src="./images/banner3.png" class="leftfix" alt="秒杀3">
            <img src="./images/baner4.png" class="leftfix" alt="秒杀4">
        </div>
    </div>
    <!-- 楼层 -->
    <div class="floor">
        <div class="container">
            <div class="floor-nav clearfix">
                <span class="floor-name leftfix">家用电器</span>
                <ul class="floor-nav-list rightfix clearfix">
                    <li><a href="#">热门</a></li>
                    <li><a href="#">大家电</a></li>
                    <li><a href="#">生活电器</a></li>
                    <li><a href="#">生活电器</a></li>
                    <li><a href="#">生活电器</a></li>
                    <li><a href="#">生活电器</a></li>
                    <li><a href="#">生活电器</a></li>
                </ul>
            </div>
            <div class="floor-info clearfix">
                <div class="item item1">
                    <ul class="item1-list clearfix">
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                    </ul>
                    <img src="./images/编组.png" alt="编组">
                </div>
                <div class="item item2">
                    <img src="./images/appliance_banner07.png" alt="">
                </div>
                <div class="item item3">
                    <img src="./images/微波炉.png" alt="">
                    <img src="./images/空气炸锅.png" alt="">
                </div>
                <div class="item item4">
                    <img src="./images/冰箱.png" alt="">
                </div>
                <div class="item item5">
                    <img src="./images/电饭煲.png" alt="">
                    <img src="./images/电饭煲2.png" alt="">
                </div>
            </div>
        </div>
        
    </div>
     <!-- 楼层 -->
     <div class="floor">
        <div class="container">
            <div class="floor-nav clearfix">
                <span class="floor-name leftfix">家用电器</span>
                <ul class="floor-nav-list rightfix clearfix">
                    <li><a href="#">热门</a></li>
                    <li><a href="#">大家电</a></li>
                    <li><a href="#">生活电器</a></li>
                    <li><a href="#">生活电器</a></li>
                    <li><a href="#">生活电器</a></li>
                    <li><a href="#">生活电器</a></li>
                    <li><a href="#">生活电器</a></li>
                </ul>
            </div>
            <div class="floor-info clearfix">
                <div class="item item1">
                    <ul class="item1-list clearfix">
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                        <li><a href="#">节能补贴</a></li>
                    </ul>
                    <img src="./images/编组.png" alt="编组">
                </div>
                <div class="item item2">
                    <img src="./images/appliance_banner07.png" alt="">
                </div>
                <div class="item item3">
                    <img src="./images/微波炉.png" alt="">
                    <img src="./images/空气炸锅.png" alt="">
                </div>
                <div class="item item4">
                    <img src="./images/冰箱.png" alt="">
                </div>
                <div class="item item5">
                    <img src="./images/电饭煲.png" alt="">
                    <img src="./images/电饭煲2.png" alt="">
                </div>
            </div>
        </div>
        
    </div>
    <!-- 页脚 -->
    <div class="footer">
        <div class="container">
            <div class="top-links clearfix">
                <ul class="links-list">
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                </ul>
                <ul class="links-list">
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                </ul>
                <ul class="links-list">
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                </ul>
                <ul class="links-list">
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                </ul>
                <ul class="links-list">
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                </ul>
                <ul class="links-list">
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">购物指南</a></li>
                </ul>
            </div>
            <div class="line"></div>
            <div class="bottom-links">
                <ul class="clearfix bottom-links-list">
                    <li><a href="#">关于我们</a></li>
                    <li><a href="#">关于我们</a></li>
                    <li><a href="#">关于我们</a></li>
                    <li><a href="#">关于我们</a></li>
                    <li><a href="#">关于我们</a></li>
                    <li><a href="#">关于我们</a></li>
                    <li><a href="#">关于我们</a></li>
                    <li><a href="#">关于我们</a></li>
                    <li><a href="#">关于我们</a></li>
                    <li><a href="#">关于我们</a></li>
                </ul>
            </div>
            <div class="copyright">京ICP备12345678901</div>
        </div>
    </div>
</body>

</html>
```

```css
/* 基础设置 */
.container{
    width: 1190px;
    margin: 0 auto;
}
/* #region顶部导航条 */
.topbar{
    height: 30px;
    background-color: #ECECEC;
}
.welcome{
    height: 30px;
    line-height: 30px;
    /* 去除文字之间间隔 */
    font-size: 0;
    color: #666;
}
.welcome span,.welcome a{
    /* 由于上面设置了字体0，这里需要重新设置字体大小 */
    font-size: 12px;
}
.welcome .hello{
    margin-right: 28px;
}
.welcome .login{
    padding-right: 10px;
    border-right: 1px solid #666;
}
.welcome .register{
    padding-left: 10px;
}
.topbar-nav .list{
    height: 30px;
    line-height: 30px;
}
.topbar-nav .list li{
    float: left;
}
.topbar-nav .list li a{
    padding: 0 15px;
    border-right: 1px solid #666;
}
.topbar-nav .list li:first-child a{
    padding-left: 0;
}
.topbar-nav .list li:last-child a{
    border: 0;
    padding-right: 0;
}
/* #endregion顶部导航条 */
/* #region头部 */
.header{
    height: 120px;
}
.header .search{
    margin-top: 46px;
    font-size: 0;
}
.header .search input{
    width: 508px;
    height: 34px;
    border: 1px solid #DD302D;
}
.header .search button{
    width: 80px;
    height: 36px;
    background-color: #DD302D;
    vertical-align: top;
    background-image: url('../images/serch_icon.png');
    background-repeat: no-repeat;
    background-position: 28px 6px;
}
/* #endregion头部 */
/* #region主导航区 */
.main-nav{
    height: 48px;
    border-bottom: 1px solid #DD302D;
}
.main-nav .all-types{
    width: 190px;
    height: 48px;
    background-color: #DD302D;
    line-height: 48px;
    font-size: 16px;
    color: #FFFFFF;
    text-align: center;
}
.main-nav .main-nav-list{
    height: 48px;
    line-height: 48px;
}
.main-nav .main-nav-list li{
    font-size: 16px;
    color: #333333;
    float: left;
    margin: 0px 10px;
}
/* #endregion主导航区 */
/* #region主要内容 */
.main-content{
    margin-top: 10px;
}
.main-content .slide-nav{
    width: 190px;
    height: 458px;
    background-color: #F4F4F4;
    /* 子元素定位需要 */
    position: relative;
}
.main-content .slide-nav li{
    font-size: 14px;
    height: 28px;
    line-height: 28px;
    padding-left: 16px;
}
.main-content .slide-nav li:hover{
    background-color: #DD302D;
}
.main-content .slide-nav li:hover>a{
    color: white;
}
/* 由于二级菜单也是在li里的，所以悬停二级菜单也算悬停在li上 */
.main-content .slide-nav li:hover .second-menu{
    display: block;
}

.second-menu{
    width: 700px;
    height: 458px;
    background-color: white;
    position: absolute;
    /* 定位 */
    top: 0;
    left: 190px;
    display: none;
}
.second-menu dl:first-of-type{
    margin-top: 10px;
}
.second-menu dl{
    height: 36px;
    line-height: 36px;
}
.second-menu dt{
    float: left;
    margin-left: 20px;
    margin-right: 10px;
    width: 70px;
    font-weight: bold;
}
.second-menu dd{
    float: left;
}
.second-menu dd a{
    padding: 0 10px;
    border-left: 1px solid #999999 ;
}
.main-content .banner{
    width: 690px;
    height: 458px;
    margin: 0 10px;
    background-color: skyblue;
}
.main-content .slide-other{
    width: 290px;
    height: 458px;
}
.main-content .slide-other .message{
    width: 260px;
    height: 156px;
    background-color: white;
    border: 1px solid #D9D9D9;
    padding: 0 14px;
}
.main-content .slide-other .message .title{
    height: 38px;
    line-height: 38px;
    border-bottom: 1px solid #D9D9D9;
    margin-bottom: 2px;
}
.main-content .slide-other .message .title span{
    font-size: 14px;
}
.main-content .slide-other .message .title a{
    font-size: 12px;
}
.main-content .slide-other .message .msg-list li{
    height: 26px;
    line-height: 26px;
}
.main-content .slide-other .other-nav{
    width: 290px;
    height: 290px;
    background-color: white;
    margin-top: 10px;
    overflow: hidden;
}
.main-content .slide-other .other-nav .other-nav-list li{
    width: 48px;
    height: 70px;
    margin: 0 11px;
    float: left;
    /* 话费span相当于是行内文字，所以要给父元素设置 */
    text-align: center;
    cursor: pointer;
}
.other-nav-list li div{
    height: 48px;
    width: 48px;
    background-image: url('../images/精灵图-侧边功能.png');
}
.other-nav-list:nth-child(1) li:nth-child(1) div{
    background-position: 0 0;
}
.other-nav-list:nth-child(1) li:nth-child(2) div{
    background-position: -48px 0;
}
.other-nav-list:nth-child(1) li:nth-child(3) div{
    background-position: -96px 0;
}
.other-nav-list:nth-child(1) li:nth-child(4) div{
    background-position: -144px 0;
}
.other-nav-list:nth-child(2) li:nth-child(1) div{
    background-position: 0 -48px;
}
.other-nav-list:nth-child(2) li:nth-child(2) div{
    background-position: -48px -48px;
}
.other-nav-list:nth-child(2) li:nth-child(3) div{
    background-position: -96px -48px;
}
.other-nav-list:nth-child(2) li:nth-child(4) div{
    background-position: -144px -48px;
}
.other-nav-list:nth-child(3) li:nth-child(1) div{
    background-position: 0 -96px
}
.other-nav-list:nth-child(3) li:nth-child(2) div{
    background-position: -48px -96px
}
.other-nav-list:nth-child(3) li:nth-child(3) div{
    background-position: -96px --96px
}
.other-nav-list:nth-child(3) li:nth-child(4) div{
    background-position: -144px -96px
}
.main-content .slide-other .other-nav .other-nav-list:first-child{
    margin-top: 16px;
}
.main-content .slide-other .other-nav .other-nav-list:nth-child(2){
    margin-top: 17px;
    margin-bottom: 17px;
}
.main-content .slide-other .other-nav .other-nav-list li:first-child{
    margin-left: 16px;
}

/* #endregion主要内容 */
/* #region秒杀 */
.seckill {
    margin-top: 10px;
}
.seckill img{
    margin-right: 11px;
    cursor: pointer;
}
.seckill img:last-child{
    margin-right: 0;
}
/* #endregion秒杀 */
/* #region楼层区 */
.floor{
    margin-top: 48px;
}
.floor-nav{
    height: 30px;
    padding-bottom: 4px;
    border-bottom: 2px solid #DD302D;
    line-height: 30px;
}
.floor-nav .floor-name{
    font-size: 20px;
}
.floor-nav .floor-nav-list li{
    float: left;
}
.floor-nav .floor-nav-list li a{
    padding: 0 10px;
    border-left: 1px solid #666666;
    font-size: 16px;
}
.floor-nav .floor-nav-list li:first-child a{
    padding-left: 0px;
    border-left: 0px;
}
.floor-nav .floor-nav-list li:last-child a{
    padding-right: 0px;
}
.floor-info .item{
    float: left;
}
.floor-info .item1{
    width: 190px;
    height: 392px;
    background-color: #F4F4F4;
    padding: 20px;
}
.item1-list {
    margin-bottom: 30px;
}
.item1-list li{
    width: 90px;
    height: 22px;
    padding-bottom: 3.5px;
    border-bottom: 1px solid #D9D9D9;
    font-size: 16px;
    text-align: center;
}
.item1-list li:nth-child(2n-1){
    float: left;
}
.item1-list li:nth-child(2n){
    float: right;
}
.item1-list li:nth-child(3),.item1-list li:nth-child(4){
    margin: 14.4px 0;
}

.floor-info .item2{
    width: 340px;
    height: 432px;
}
.floor-info .item3{
    width: 206px;
    height: 432px;
}
.floor-info .item3 img{
    border-bottom: 1px solid #E2E2E2;
}
.floor-info .item4{
    width: 206px;
    height: 432px;
    border-left: 1px solid#E2E2E2;
    border-right: 1px solid#E2E2E2;
}
.floor-info .item4 img{
    border-bottom: 1px solid#E2E2E2;
}
.floor-info .item5{
    width: 206px;
    height: 432px;
}
.floor-info .item5 img{
    border-bottom: 1px solid#E2E2E2;
}
/* #endregion楼层区 */
/* #region页脚 */
.footer{
    height: 440px;
    background-color: #483E3E;
    overflow: hidden;
    margin-top: 48px;
}
.footer .top-links{
    margin-top: 48px;
}
.footer .links-list{
    float: left;
    width: 190px;
    margin-right: 10px;
} 
.footer .links-list:last-child{
    margin-right: 0px;
} 
.footer .links-list li a{
    font-size: 14px;
    color: white;
}
.footer .line{
    height: 1px;
    background-color: #584D4D ;
    margin-top: 22px;
}
.footer .bottom-links{
    margin-top: 47px;
    text-align: center;
}
.footer .bottom-links-list{
    display: inline-block;
}
.footer .bottom-links li{
    float: left;
}
.footer .bottom-links li a{
    padding: 0 26px;
    border-right: 1px solid white;
    color: white;
}
.footer .bottom-links li:first-child a{
    padding-left: 0px;
}
.footer .bottom-links li:last-child a{
    border-right: 0px;
    padding-right: 0px;
}
.footer .copyright{
    margin-top: 10px;
    text-align: center;
    color: white;
    font-size: 12px;;
}
/* #endregion页脚 */
```



# H5

## 语义化标签

- header 页面头部
- footer 页面尾部
- nav 导航 
- article 中可有多个section，比section更强调独立性，如果一段内容比较独立完整，应该使用article
- section 页面中的某段文字，强调分块，将一段内容分成几部分，用section
- aside 侧边栏 

## 状态标签

- meter 状态条 
- progress 进度条

## 列表标签

- datalist input可以指向，做输入预测
- details 配合summary 做展开详细内容（折叠）

## 文本标签

- ruby 配合 rt 做汉字注音
- mark 用于标记，用于搜索结果

## 表单新增属性

- placeholder 文字输入控件的提示属性
- required 必输，加载单选按钮（多选为当前多选框必选）上的其中一个为，当前同名组中至少选一项
- autofocus 自动获取焦点 

- autocomplete 浏览器自动填写表单
- pattern 正则表达式限制 ，空输入框不会验证  
- type
    - email
    - url
    - number 属性step 步进，同时限制只能输入步进的倍数
    - search
    - tel
    - range 范围选择器
    - color 颜色选择器
    - date 日期
        - month
        - week
        - time
        - datetime-local 日期加时间  

## 多媒体

- 视频 video
    - src 视频源
    - controls 控制按钮
    - muted 默认静音
    - autoplay 自动播放 必须静音 
    - loop 循环 
    - poster 封面源，默认第一帧
    - preload 预加载 
        - auto
        - me tadata
- audio 音频 
    - controls
    - autoplay
    - muted
    - loop

## 全局属性

- contextmenu 右键菜单

## 兼容性 

- js 转换

```html
<!--[if lt ie 9]>
<script src="html5shiv.js"></script>
<![endif]-->
```

- IE=edge

```html
<meta http-equiv="X-UA-Compatible" content="IE=edge"> 
```

- 使用webkit

```html
<meta name="render" content="webkit">
```



# CSS3

## 私有前缀/内核前缀 

正常属性前添加前缀，各种内核测试用 

- chrome：-webkit-
- safari：webkit-
- firefox：-moz-
- edge：-webkit-

## 长度单位

- vw 视口宽度的百分之多少，会随着视口大小动态变化
- vh 视口高度的

## 盒子模型

- box-sizing 指定盒子大小控制的部分
- resize 是否允许用户调整大小，需要伴随overflow使用
- box-shadow  阴影  位置，颜色  透明度 模糊程度 大小 内阴影  
- opacity 调整盒子透明度，包括其中内容 

## 背景

背景默认贴到padding的角上 

- background-origin  修改参考点

    - padding-box
    - content-box
    - border-box

- background-clip  盒子什么部分以外的背景图/颜色不显示

    - content-box
    - 。。。
    - text（文字需要透明，需要加内核前缀）

- background-size

    - 大小
    - 百分比
    - cover 

    - auto
    - contain

- 复合属性 

- 多背景 

## 边框

- border-radius 圆角半径 
    - border-top-left-radius 可分开设置 
    - border-top-left-radius 100px 50px     x，y半径不同 
- outline 边框外轮廓 不参与盒子大小计算  

## 文本

- text-shadow 文本阴影 位置 距离 颜色
- white-space 文本换行
    - pre
    - pre-wrap 超出元素边界自动换行
    - pre-line  超出元素边界自动换行，忽略始末空格
    - nowrap
- text-overflow 文本溢出
    - ellipsis 省略号（配合overflow hidden与whitespace nowrap）
- text-decoration 文本修饰

    - 下划线上划线删除线等 颜色，实虚线

- text-stroke 文本描边
    - 仅webkit 支持，需加前缀

## 渐变

本质上是背景图

- background-image: linear-gradient 线性渐变，
    - 可调渐变方向
    - 渐变角度（也是方向）
    - 调整颜色出现位置
- background-image: radial-gradient 径向渐变
    - 可调圆心
    - 坐标值调圆心
    - 调整半径
    - 调整颜色出现位置

- 重复渐变

    纯色区域继续渐变

    - background-image: repeating-linear-gradient

## Web字体

www.iconfont.cn/webfont

通过字体链接引入字体

```html
@font-face{
	font-family: "testfont" // 取字体名
	src: url("...")
}
h1{
	font-family: "testfont"
}
```

## 字体图标

- unicode 引用
- icofont 引用（建议）
- svg 引用

## 变换

- 位移 transform: translate

    不脱离文档流，不会影响其他元素，对行内元素无效

    - translate(X,Y)
    - translateX
    - translateY

- 缩放 transform: scale

    可用于镜像

    - scaleX()

- 旋转 transform: roate(1deg)

- 扭曲 transform: skew

- 多重变换 上面这些变化写到同一个属性中，会有先后顺序的影响

    - 比如先旋转后坐标系会发生变化

- 变换原点 transform-origin  

    - 默认是50%

    - 对旋转，缩放有影响

## 3D变换

- 父元素开启3D空间
    - transfom-style: preserve-3d
- 景深 加透视效果
    - perspective:长度值，观察者与元素的距离
- 设置透视点位置 perspective-origin
- translateZ 离人眼距离，与景深有关
- 旋转：X，Y

## 过渡

用数字可以表示的属性可以通过过渡

过渡要给元素本身加，不要在动作选择器上加

- transition-property: 写变化时需要过渡的属性名，如height;
    - all 所有能过渡的属性
- transition-duration: 过渡时间
- transition-delay 延迟
- transition-timing-functuin 过渡方式
    - ease 慢快慢
    - linear 匀速
    - ...
    - cubic-bezier 贝塞尔曲线

## 动画

```css
@keyframes name{
    from{
        
    }
    to{
        transform: translate(900px);
        background-color: red;
    }
    // 或者
    0% {
        
    }
    ...
    100%{
        
    }
}
.box{
    /*应用动画到元素*/
    animation-name: name;
    /*动画持续时间*/
    animation-duration: 3s;
    /*动画延迟时间*/
    animation-delay: 0.2s;
}
```

**其他属性**

- animation-timing-functuin 过渡方式，可设step用于过渡背景图形式的动画

- animation-iteration-count 过渡次数，可为infinite
- animation-direction 过渡方向，可往返或者反向
- animation-fill-mode 动画停止时的位置/模式
- animation-play-state 动画播放状态

**与过渡区别**

动画不需要过度条件，过渡需要

## 多列布局

column-count: 5，当前元素内容分为五列

column-width 每列宽度

column-rule-width 间隔宽度

column-rule style 实线虚线

column-rule-color 颜色

column-span 跨列元素加：nono与all

## 伸缩盒模型

弹性盒子

使用display: flex属性开启一个元素的flex布局，当前元素会变为伸缩容器，其直接子元素会自动变为伸缩项目

也可使用display:inline-flex，会将当前元素变为行内元素&伸缩容器，但用的少

### 主轴

- 主轴默认从左到右，侧轴从上到下
- flex-direction 调整主轴方向
- 侧轴方向会随着主轴方向改变
- 主轴方向上排列的元素默认会更改自己的宽度（即使指定宽度）来保证不换行
    - 可通过flex-wrap调整换行方式：wrap换行  no-wrap默认不换行

- flex-flow： row wrap 复合属性 
- 主轴对齐方式 
    - justify-content：center/flex-end/flex-start/ space-around/space-between
-  侧轴对齐方式
    - align-items: flex-start/flex-end/center/baseline/stretch(不给高度拉伸到整个容器)
    - 多行对齐时 align-content: flex-start/flex-end/center/space-around/space/between/space-evenly

### 技巧

元素居中

- justify-content: center

    align-items: center

- display: flex

    子元素 margin: auto

### 基准长度

设置伸缩项目在主轴上的基准长度

flex-basis: auto/**px 

### 伸缩

伸：将主轴富余空间分配给标注了flex-grow的伸缩项目，具体分多少看权重

缩：将主轴减小的空间按其长度为比例乘权重flex-shrink从伸缩项目中去掉

基准长度与伸缩规则可简写为flex

### 排序

给伸缩项目加order属性，默认为0

### 单独侧轴位置

align-self

### 练习

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        *{
            font-family: Arial;
            font-size: 14px;
            margin: 0;
            padding: 0;
            border: none;
        }
        a{
            text-decoration: none;
        }
        ul{
            list-style: none;
        }
        /* body和html都没有内容，所以去找其父元素，html没有父元素，所以去找视口 */
        body,html{
            width: 100%;
            height: 100%;
        }
        body{
            background-image: url("images/bg.jpg");
            background-repeat: no-repeat;
            background-size: cover;
        }
        .page-header{
            background-color: rgba(0,0,0,0.7);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        .page-header-nav{
            display: flex;
            
        }
        .page-header-nav a{
            color: white;
            font-size: 20px;
            border: 1px solid white;
            border-radius: 8px;
            padding: 10px;
            margin-right: 20px;
        }
        .page-header-nav li:last-child a{
        
            margin-right: 0px;
        }
        
        .page-content{
            display: flex;
            /* 可进行计算，注意运算符两边的空格是必须的 */
            height: calc(100vh - 70px);
        }
        .content-nav{
            width: 1000px;
            height: 300px;
            background-color: skyblue;
            margin: auto;
            display: flex;
            justify-content: space-evenly;
            align-items: center;
        }
        .content-nav .item{
            width: 180px;
            height: 200px;
            background-color: orange;
            display: flex;
            flex-direction:column;
            align-items: center;
            justify-content: space-evenly;
            /* 过渡 */
            transition: 0.2s linear;
            cursor: pointer;
        }
        .content-nav .item:hover{
            box-shadow: 0px 0px 20px black;
        }
        .content-nav .item span{
            font-size: 20px;
            color: white;
        }

    </style>
</head>
<body>
    <header class="page-header">
        <a href="#">
            <img src="images/logo.png" alt="logo">
        </a>
        <ul class="page-header-nav">
            <li><a href="#">国内校区</a></li>
            <li><a href="#">国内校区</a></li>
            <li><a href="#">国内校区</a></li>
            <li><a href="#">国内校区</a></li>
        </ul>
    </header>
    <div class="page-content">
        <div class="content-nav">
            <div class="item"><img src="images/item1.png" alt="item1"><span>我的邮箱</span></div>
            <div class="item"><img src="images/item2.png" alt="item1"><span>我的邮箱</span></div>
            <div class="item"><img src="images/item3.png" alt="item1"><span>我的邮箱</span></div>
            <div class="item"><img src="images/item4.png" alt="item1"><span>我的邮箱</span></div>
            <div class="item"><img src="images/item5.png" alt="item1"><span>我的邮箱</span></div>

        </div>
    </div>
</body>
</html>
```

## 响应式布局

- 媒体查询

    ```html
    <style>
    	/*当当前媒体为打印机时，要放在最下面，否则会被别的样式覆盖，没有优先 */    
        @media print{
            
        }
        /*当当前视口为800px */    
        @media (width: 800px){
            
        }
        /*当当前视口小于等于800px */    
        @media (max-width: 800px){
            
        }
        /*当当前屏幕等于800px */    
        @media (device-width: 800px){
            
        }
        /*当当前视口小于等于800px且大于等于400px */    
    	/*且 and 或 or 否 not */    
        @media (max-width: 800px) and (min-width: 800px){
            
        }
    </style>
    ```

### 常用阈值

768px 992px 1200px 

### 条件引用

```html
<link rel="stylesheet" media="这里写媒体查询" href="style.css">
<link rel="stylesheet" media="device-width: 800px" href="style.css">
```

## BFC

某元素的一种状态

- 块级格式上下文
- 默认处于关闭状态

### 功能

当某元素开启BFC

- 其子元素不会产生margin塌陷问题
- 自己不会被其他浮动元素覆盖
- 自身高度不会被其子元素是否浮动影响

### 如何开启

- 默认开启
    - html
    - 浮动元素
    - 绝对定位、固定定位的元素
    - 行内块元素
    - 变革单元格
    - overflow值不为visible的块元素
    - 伸缩项目
    - 多列容器
    - column-span为all的元素
    - display值为flow-root