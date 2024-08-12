---
title: 文本编辑器相关技术记录
date: 2024-08-6 17:35:19
updated: 2024-08-6 17:35:19
tags:
  - 编辑器
categories:
  - notes
---

# 参考资料

[从零开始写一个富文本编辑器（一） - 掘金 (juejin.cn)](https://juejin.cn/post/6924346082797289480)

[十分钟实现自己的Typora - 掘金 (juejin.cn)](https://juejin.cn/post/6844903878224412686)

[Selection - Web API | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/API/Selection)

[Vditor 实现 Markdown 所见即所得 - 链滴 (ld246.com)](https://ld246.com/article/1577370404903)

[关于所见即所得 Markdown 编辑器的讨论 - 链滴 (ld246.com)](https://ld246.com/article/1579414663700)

# Selection

Selection中存储用户选择的文本范围或者插入符号的位置，获取方式：`window.getSelection()`

在不可编辑元素中，插入点位置和选区范围必须通过鼠标的点击或者拖拽产生，在可编辑元素中，插入点位置和选取范围也可以通过键盘方向键变化。

可通过`window.getSelection().toString()`获取被选中的文字

# Range

可通过`selection.getRangeAt`获取

- `Range.commonAncestorContainer`返回完整包含所选内容的最深一层的节点

# designMode

document的designMode属性，可以将整个页面开启编辑模式，类似于给整个页面加上了`contentEditable="true"`属性。

设置方式如：

`document.designMode = "on";`

可选值有`on`和`off`

设置iframe可编辑：

`iframeNode.contentDocument.designMode = "on";`

# contentEditable

该属性用于开启某个元素的可编辑：

- `"true"` 表明该元素可编辑。
- `"false"` 表明该元素不可编辑。
- `"plaintext-only"` 表明该元素可以纯文本格式编辑，富文本格式会被禁用。
- `"inherit"` 表明该元素继承了其父元素的可编辑状态。

```js
editable = element.contentEditable
element.contentEditable = "true"
```

# 选中复制

复制html页面时，复制到的内容为标签中间的内容，也就是innerText，也包括可编辑内容如输入框的value

# 一些事件监听器

同一元素同一类型的事件监听器可以注册多个

## input

在可编辑元素或者开启了可编辑的元素上添加监听器监听input事件

## beforeinput

会在元素编辑前触发，此时e中的target为编辑前的状态，但在该事件中无法阻止输入的执行

## selectionchange

会在selection变化时触发，包括选区变化，点击了新的位置或者输入了新的内容

# 关于md的分析

在考虑是否使用抽象语法树来分析整个文档，或者使用抽象语法树的时候要不要将h2与h1（等情况）的层级关系抽象到语法树中，目前看来md最合适的方式是所有的元素都在一个层级，比如标题、与标题下的正文，这些元素应该是在同一个层级就可以（抽象为一个一个块），这样在进行标题的添加与删除时，不会导致整个文档的语法树层级变化太大，而对每一块做编辑的时候，每次只需要重新渲染当前块即可，这样变化量较小

思路：每次input事件被触发时，获取当前range，获取选区内的对象内容，接着重新渲染这部分内容，渲染完成后重置光标

如果是先选中一部分选区后，做删除或者替换操作，则在input之前（beforeinput事件）通过range判断选中的范围，在input后再根据具体的操作，则获取这个选取内的所有元素的文本后进行重新渲染，如果是添加也一样，此时肯定要先将选定范围内容的所有元素都删除再重新渲染

关于块级上下文思路

碰到一个空行后则开启/关闭一个上下文，在上下文中要根据当前上下文渲染样式，比如碰到代码块或者列表这种多行的块结构，特殊情况比如代码块等有标准的块上下文标识的按照具体情况考虑
