---
title: markdown规范教程
date: 2024-08-6 17:35:19
updated: 2024-08-6 17:35:19
tags:
  - markdown
categories:
  - notes
---

# 参考资料

[Markdown 官方教程](https://markdown.com.cn/)https://ld246.com/article/1579414663700)

# 标题

标题为在段落开头添加`#`标记，在跟一个空格后添加标题内容，映射成html后，会转为`h`标签包裹的元素，最多支持到6级标题。

```html
= markdown =
# 一级标题
## 二级标题
= html =
<h1>一级标题</h1>
<h2>二级标题</h2>
```

# 段落

段落在html中是被`<p></p>`标签包裹的内容，在markdown中，使用一个空行分隔开两段文本会生成这种段落结构（也就是需要敲两次回车）。

```html
= markdown =
这是第一个自然段

这是第二个自然段
= html =
<p>这是第一个自然段</p>
<p>这是第二个自然段</p>
```

# 换行

对应html中的`<br />`标签，标准的换行语法是在需要换行的地方添加两个空格然后再加一个回车，不清楚为什么不能直接回车，typora官方的建议是，尽量少用换行结构或者不用，如果需要用的话，建议使用`<br />`标签，个人感觉md中还是尽量少出现html标签为好

```
= markdown =
第一行  （这里有两个空格）
第二行
= html =
第一行<br />
第二行
```

# 强调语法

## 粗体

在md中使用两个下划线或者两个星号包裹的内容，会被渲染为`<strong>`元素，目前更推荐使用星号包裹。

```html
= markdown =
这是**重点**
这是__重点__
= html =
这是<strong>重点</strong>
```

## 斜体

与粗体类似的，但左右只使用一个星号或下划线，渲染为`<em>`元素

```html
= markdown =
这是*重点*
这是_重点_
= html =
这是<em>重点</em>
```

注意斜体和粗体是能共存的，只需要左右各加三个星号或者下划线，此外大多数的修饰符其实都可以共存。

# 引用

md会将开头为`>`的行作为引用的一部分，并不要求`>`符号后跟一个空格（但建议），甚至在typora的实现中，无论在箭头符后跟多少空格都不会在渲染后体现。

```html
= markdown =
>浪费时间就是谋财害命
= html =
<blockquote>
    浪费时间就是谋财害命
</blockquote>
```

引用块中应该能包裹其他元素，在typora中，几乎可以包裹所有md元素，但引用块中的标题并不会体现在导航中

# 列表

## 有序列表

在md中，会将数字开头并跟一个英文句点再加一个空格的行渲染为有序列表，且与开头数字无关，最后都会渲染为从1开始的有序列表

```html
= markdown =
1. First item
8. Second item
3. Third item
5. Fourth item
= html =
<ol>
<li>First item</li>
<li>Second item</li>
<li>Third item</li>
<li>Fourth item</li>
</ol>
```

嵌套

```html
= markdown =
1. First item
2. Second item
3. Third item
    1. Indented item
    2. Indented item
4. Fourth item
= html =
<ol>
    <li>First item</li>
    <li>Second item</li>
    <li>Third item
        <ol>
            <li>Indented item</li>
            <li>Indented item</li>
        </ol>
    </li>
    <li>Fourth item</li>
</ol>
```

## 无序列表

类似有序列表，不过开头非数字而是如下字符:`-`, `*`, `+`

```html
= markdown =
- First item
- Second item
- Third item
    - Indented item
    - Indented item
- Fourth item
= html =
<ul>
    <li>First item</li>
    <li>Second item</li>
    <li>Third item
        <ul>
            <li>Indented item</li>
            <li>Indented item</li>
        </ul>
    </li>
    <li>Fourth item</li>
</ul>
```

## 列表中包含其他元素

需要在其他元素之前添加四个空格或者一个制表符，实测支持的元素有限，常见的有段落、图片、引用块、代码块等，但对于代码块，需要将每一行之前都添加四个空格，多少比较麻烦了。

# 代码与代码块

代码

将字符包裹在反引号中作为代码显示

```html
= markdown =
At the command prompt, type `nano`
= html =
At the command prompt, type <code>nano</code>
```

可以使用双反引号作为包裹会出现单反引号的代码（但包裹不了双反引号）

 ```html
= markdown =
``Use `code` in your Markdown file.``
= html =
<code>Use `code` in your Markdown file.</code>
 ```

## 代码块

md默认的代码块是将代码的每一行开头都使用四个空格或者一个制表符进行缩进，而更常用的是使用三个反引号框住的围栏式代码块

# 分割线

在单独的一个块中使用三个以上的如下符号可创建一条分割线：`*`,`-`,`_`，且改行不能包含其他内容

建议在该行上下都添加一个空行

```html
= markdown =
***
---
___
= html =
<hr />
```

# 链接

链接文本放入方括号，链接地址放入圆括号中，悬停内容放在括号中的双引号中

```html
= markdown =
这是一个链接 [Markdown语法](https://markdown.com.cn "最好的markdown教程")。
= html =
<a href="https://markdown.com.cn" title="最好的markdown教程">Markdown语法</a>
```

另外可使用尖括号将内容变为可点击内容

```html
= markdown =
<https://markdown.com.cn>
<fake@example.com>
= html =
<a href="https://markdown.com.cn">https://markdown.com.cn</a>
<a href="fake@example.com">fake@example.com</a> 
```

可在链接前后添加星号用于强调显示

注意在链接中尽量使用20%代替空格

# 图片

图片的md语法就是在链接语法之前添加一个叹号

```html
= markdown =
![这是图片](/assets/img/philly-magic-garden.jpg "Magic Gardens")
= html =
<img src="/assets/img/philly-magic-garden.jpg" alt="这是图片" title="Magic Gardens">
```

给图片添加链接

```html
= markdown =
[![沙漠中的岩石图片](/assets/img/shiprock.jpg "Shiprock")](https://markdown.com.cn)
= html =
<a href="https://markdown.com.cn"><img src="/assets/img/shiprock.c3b9a023.jpg" alt="沙漠中的岩石图片" title="Shiprock"></a>
```

# 转义字符

## 可转义的

可使用反斜杠对大多数字符进行转义

| Character | Name                                                         |
| --------- | ------------------------------------------------------------ |
| \         | backslash                                                    |
| `         | backtick (see also [escaping backticks in code](https://markdown.com.cn/basic-syntax/escaping-characters.html#escaping-backticks)) |
| *         | asterisk                                                     |
| _         | underscore                                                   |
| { }       | curly braces                                                 |
| [ ]       | brackets                                                     |
| ( )       | parentheses                                                  |
| #         | pound sign                                                   |
| +         | plus sign                                                    |
| -         | minus sign (hyphen)                                          |
| .         | dot                                                          |
| !         | exclamation mark                                             |
| \|        | pipe (see also [escaping pipe in tables](https://markdown.com.cn/extended-syntax/escaping-pipe-characters-in-tables.html)) |

## 自动转义的

对于html字符比如`< > &`以及空格等字符，在渲染成html之前，必须做转义为html实体，避免被误渲染

# 内嵌html标签

支持在行内使用html标签，但有些编辑器不会开启这项功能

# 表格

使用管道符创建表格

```html
= markdown =
| Syntax      | Description |
| ----------- | ----------- |
| Header      | Title       |
| Paragraph   | Text        |
= html =
<table>
    <thead>
        <tr><th>Syntax</th> <th>Description</th></tr>
    </thead> 
    <tbody>
        <tr><td>Header</td> <td>Title</td></tr> 
        <tr><td>Paragraph</td> <td>Text</td></tr>
    </tbody>
</table>
```

# 围栏代码块

使用三个反引号进行围栏式代码块的声明

```html
= markdown =
​```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
​```
= html =
<code>
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
</code>
```

# 待办事项

注意方括号前有一个空格

```html
= markdown =
- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media
= html =
这里应该是使用多选框渲染的
```

