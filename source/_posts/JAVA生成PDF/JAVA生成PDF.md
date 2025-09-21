---
title: JAVA生成PDF
date: 2025-09-21 11:35:19
updated: 2025-09-21 11:35:19
tags:
  - PDF
categories:
  - notes
---

# 参考资料

[如何使用 Selenium 生成 PDF - 极道](https://www.jdon.com/75228-PDF.html)

[SpringBoot + ITextPdf：高效生成 PDF 预览文件-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/2455468)

# 简述

通常我们都会有在java项目中生成pdf的需求，或需要返回给前端，或需要进行存储到本地

主流有几种方法，一种是我在项目上见到的selenium生成，另一种是现在使用者较多的专用工具生成

# SELENIUM

selenium是一种浏览器模拟工具，使用selenium生成pdf本质上是调用了浏览器的将页面打印为pdf 的功能。由于是调用了浏览器的功能，所以服务器上需要安装对应的浏览器和驱动用于调用；优点是可以进行复杂的PDF文件的生成，缺点就是配置比较麻烦。

# 框架生成

ITextPdf 和 OPENPDF是两种常用的PDF生成工具，比较方便，但对于一些复杂的html支持并不是很好

## 字体不显示问题

html中用到的字体需要提前存放在后端，并使用字体设置方法设置该字体

# 下载

我现在接触到的一个项目是使用selenium将pdf打印出来后，存到minio，然后把下载连接返回给前端，这样使用minio作为整个项目的下载入口