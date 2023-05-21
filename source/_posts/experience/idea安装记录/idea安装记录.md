---
title: idea安装记录
date: 2023-05-21 20:41:30
---

# 所需文件

链接：https://pan.baidu.com/s/1oQkinHQ-wEcGCRxEbu5KJQ 
提取码：dtzy

# 软件安装

正常安装idea即可，安装完成后关闭idea。

# 注册

1. 将jar包 FineAgent.jar 放入一个文件夹， 比如idea的安装目录
2. 用记事本打开idea安装目录中的bin/idea64.exe.vmoptions
3. 最下面一行添加-javaagent:D:\\idea\\FineAgent.jar，后半部分为 FineAgent.jar 的文件位置
4. 打开idea，选择Activation code, 输入激活码文件中的内容
5. 点击 Activate 进行激活，Continue 进入idea

安装结束

