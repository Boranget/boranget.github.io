---
title: 坚果pro2折腾记录
date: 2023-05-20 20:15:30
updated: 2023-05-31 10:35:19
tags:
  - 刷机
categories:
  - 经验
---

# 参考资料

[自制9008工程线给坚果pro2救砖_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Rv41117wP/?spm_id_from=333.788.recommend_more_video.-1&vd_source=7103983ce7cdb97d8715a21074de9a20)

[【图片】坚果PRO2 Pro2_通用线刷救砖包 V4.1.1及线刷救砖教程【坚果pro2吧】_百度贴吧 (baidu.com)](https://tieba.baidu.com/p/5543782291)

[坚果pro2完美降回6.0.3卡刷包 完美恢复方法_坚果pro2刷机包6.0.3_xcntime的博客-CSDN博客](https://blog.csdn.net/xcntime/article/details/116357400)

# 所需文件

链接：https://pan.baidu.com/s/1CVFE8fp75TJFT4gjTSBPyw 
提取码：xszz

# 工程线制作

坚果pro2需要进入9008模式才可以进行刷机，进入9008模式需要工程线，所以需要购买或者自己制作一条。制作方法可以查看参考资料，具体步骤为，取一条可以传输数据的type-c数据线，取出其中的黑、绿两根线，拨开皮备用。

# 救砖过程

1. 安装QPST工具，地址可以查看我写的另一篇关于随身WiFi的博客中的随身wifi资源合集。

2. 进入QPST文件安装目录的bin文件夹，找到绿色图标的qfil程序打开。

3. 在手机关机的情况下，将工程线的黑绿两根线短接，连接电脑与手机，三秒后松开短接，打开电脑的设备管理器，端口树下可以看到9008设备。

   ![image-20230520203718672](坚果pro2折腾记录/image-20230520203718672.png)

4. 点击QFIL中的SelectPort，选择9008。

5. 在Select Build Type选择 Flat Build。

6. Select Programmer处勾选Browse选择程序路径，选择线刷包文件夹中的“prog_emmc_ufs_firehose_Sdm660_ddr.elf”文件。

7. Load XML处勾选线刷包文件夹中的rawprogram_unsparese.xml文件，勾选后，自动弹出第2个选择框，勾选线刷包文件夹中的patch0.xml。

8. 点击Download开始刷机。

9. 进度条走完，出现successful等提示后，拔掉数据线开机，此时线刷救砖结束。

![image-20230520204232655](坚果pro2折腾记录/image-20230520204232655.png)

# 卡刷过程

刷入救砖包后，发现无法激活，在查询后发现有的版本可以通过输入法的“关于”界面进入浏览器，但这个线刷包中，将浏览器和下载器都封了，无法调用，在各种折腾无果后，抱着试试的态度，刷入了一个卡刷包。

1. 数据线连接电脑与手机，电脑端打开文件管理器，将所需文件中的卡刷包拖入手机中。

   ![image-20230520204653044](坚果pro2折腾记录/image-20230520204653044.png)

2. 将手机关机，长按音量下键与电源键，进入recovery：音量键上下移动，电源键确认。
3. 选择 Apply update from SD card ，选择6.0.3-201807271621-user-ob-876f282561.zip，开始卡刷。
4. 刷机结束后开机，成功跳过激活进入系统。