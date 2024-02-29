---
title: edge浏览器使用pyecharts_snapshot_selenium渲染成图片
date: 2021-06-17 16:50:30
updated: 2021-06-17 16:50:30
tags:
  - python
categories:
  - experience
---

# pyecharts渲染成图片

![在这里插入图片描述](edge浏览器使用pyecharts_snapshot_selenium渲染成图片/20210617103805753.png)


snapshot-selenium 是 pyecharts + selenium 渲染图片的扩展，使用 selenium 需要配置 browser driver，这部分可以参考 selenium-python 相关介绍，推荐使用 Chrome 浏览器，可以开启 headless 模式。目前支持 Chrome, Safari

由于个人用的浏览器是edge，但selenium-python不支持edge，所以做了如下配置：
1. 下载edge web driver：https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/
2. 将解压得到的文件放入一个文件夹中，将其中的exe文件重命名为MicrosoftWebDriver.exe, 然后将此文件夹放入path环境变量
3. 对snapshot源码做一点修改，添加edge相关的配置，期间通过查看webdriver的init文件得知获取edge浏览器驱动的方法为webdriver.Edge()：
	![在这里插入图片描述](edge浏览器使用pyecharts_snapshot_selenium渲染成图片/2021061710383363.png)

4. 传入browser参数：
	![在这里插入图片描述](edge浏览器使用pyecharts_snapshot_selenium渲染成图片/20210617103842503.png)

5. 运行结果
	

![在这里插入图片描述](edge浏览器使用pyecharts_snapshot_selenium渲染成图片/20210617103858427.png)