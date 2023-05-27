---
title: MySQL安装与配置
date: 2023-05-27 16:50:30
categories:
  - 经验
---

# 卸载

打开安装器，点击右侧的remove

![image-20230527205355781](MySQL安装与配置/image-20230527205355781.png)

选中要卸载的组件next > execute

若卸载失败， 可以打开Windows 应用管理卸载

# 下载

在mysql官网下载安装器：msi结尾文件

# 安装

1. choosing a setup type 

   其中：

   - developer default  会安装 server，connectors，workbench，文档，实例
   - server only 只安装server
   - client only 只安装 client
   - full 安装所有
   - custom 自定义

   这里选择 custom 自定义

2. select products

   选中左边的组件，点击中间的按钮可以添加到右边进行安装，这里我只选择了server 和 shell。

   点击右侧框中的具体组件，下方会出现蓝色字体 advanced option，点击设置安装位置

   这里分别制定为

   server 

   ​	D:\tools\mysql\mysql8\server

   ​	D:\tools\mysql\mysql8\server\data

   shell

   ​	D:\tools\mysql\mysql8\shell

3. Installation

   点击execute，会显示正在安装，当状态为complete即安装结束

# 配置

安装完成后，安装器会自动跳到配置界面

type and networking 这个页面配置端口和内存占用等，默认即可，可以勾选最下面的 show advanced and logging option next

authentication method 选择下面5.x的模式 next

accounts and roles 填写root密码 next

windows service 默认 next

server file permission 默认 next

logging options 这里的日志会存放到我们上面指定的server-data目录下 默认 next

advanced options 默认 next

apply configuration execute

finish

最后将 D:\tools\mysql\mysql8\server\bin 目录配置到环境变量的path中

# 测试连接

打开一个新的cmd窗口， 输入mysql -uroot -p 回车，输入密码，连接成功即可



