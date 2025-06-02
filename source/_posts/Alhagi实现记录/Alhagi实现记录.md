---
title: Alhagi实现记录
date: 2024-11-17 21:35:19
updated: 2024-11-17 21:35:19
tags:
  - 编辑器
  - markdown
categories:
  - notes
---

# 参考资料

https://spec.commonmark.org/0.31.2/

# CommonMark解析策略

1. 先将文档分解为块结构，但不解析文本，链接引用定义可以先收集起来
2. 将标题和段落中的纯文本解析为行内元素，此时可使用之前收集好的链接引用定义
