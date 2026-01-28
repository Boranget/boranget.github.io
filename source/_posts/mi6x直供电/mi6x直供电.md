---
title: mi6x直供电
date: 2026-01-11 23:35:19
updated: 2026-01-11 23:35:19
tags:
  - 直供电
categories:
  - 笔记
---

# 参考资料

[autoboot](https://github.com/anasfanani/magisk-autoboot)

[boot.img](https://github.com/cofface/android_bootimg/blob/master/bootimg.exe)

[搞机助手](https://lsdy.top/gjzs)

[【折腾教程】旧手机改直供电，插电自动开机_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1VN411t7TD/?spm_id_from=333.1387.favlist.content.click&vd_source=7103983ce7cdb97d8715a21074de9a20)

[手机改直供电详细教程_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1VnUjB9EAS/?spm_id_from=333.1387.favlist.content.click)

# 直供电改造

## 电池小板获取

电池下方有两个胶带，扯出来就可以将电池拿下来了

将电池小板用剪刀剪下来，注意不要同时剪两个引脚，否则可能会短路

## 降压模块

淘宝上购买的转4.2v的降压模块

## 电源适配器

至少需要5v2a的输出，不然最后会有无限重启的情况

## 焊接

usb线正极焊接到降压模块的in+上，降压模块的out+焊接到电池小板的B+上

usb线负极焊接到降压模块的in-上，降压模块的out-焊接到电池小板的B-上

过程中可以使用万用表判断降压是否成功

> 焊接过程中不小心把上面的一个电子元件松动掉下来了，重新焊上去的时候焊反了，导致降压后的结果为0v

## 注意

需要注意的是，降压模块的大小是否能塞到手机里，这里使用的mi6x由于是很薄的机型，降压模块放不进去，最终采取了降压模块放在外面，通过两根线接到手机里面接到电池小板上。

# 充电自启

采用了很多办法。比如网上普遍使用的修改boot.img中的`init.rc`文件，但结果为无限重启，最终使用面具模块实现，这里使用的是simple版本，非simple版本不生效

**后记**：模块也没用，应该是因为我走的不是usb口供电导致

# 问题

修改boot文件刚开始用的是镜像助手和镜像工厂工具修改boot.img中的`init.rc`文件，但是结果为无限重启，后来使用bootimg.exe搭配搞机助手，但还是同样的效果

中途使用奇兔刷机重新把手机救回来，后面碰到这种由于刷入其他boot导致的问题可以直接使用搞机助手刷入备份的boot来解决



