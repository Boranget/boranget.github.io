---
title: windows服务部署jar
date: 2025-02-27 10:35:19
updated: 2025-02-27 16:35:19
tags:
  - 服务
categories:
  - 经验
---

# 参考资料

https://github.com/winsw/winsw

https://blog.csdn.net/xch_yang/article/details/129167189

https://github.com/winsw/winsw/blob/v3/docs/xml-config-file.md

# 存在问题

使用winsw启动的java进程的默认用户为System，使用jps无法查找到非当前用户启动的java进程

# 使用方式

## 配置文件

下载exe程序和xml文件，修改xml文件内容

```xml
<service> 
    <id>catcher</id> 
    <name>catcher</name>
    <description>This is catcher service.</description>
    <!-- java环境变量 -->
    <executable>C:\amer\jdk17\jdk-17.0.8\bin\java</executable> 
    <arguments>-jar "C:\amer\sftpserver\catcher\catcher-1.0-SNAPSHOT.jar"</arguments>
    <!-- 开机启动 -->
    <startmode>Automatic</startmode>
    <workingdirectory>C:\amer\sftpserver\catcher</workingdirectory>
 </service>
```

- id：安装windows服务后的服务ID，必须是唯一的。
- name：服务名称，也必须是唯一的。
- executable：执行的命令，如启动命令java。
- arguments：命令执行参数，如指定虚拟机参数，配置文件路径等。
- startmode：启动模式，如开机启动Automatic。
- logpath：日志路径，%BASE%代表相对路径，也就是当前目录。

## 全局使用

1. Take *WinSW.exe* or *WinSW.zip* from the distribution.
2. Write *myapp.xml* (see the [XML config file specification](https://github.com/winsw/winsw/blob/v3/docs/xml-config-file.md) and [samples](https://github.com/winsw/winsw/blob/v3/samples) for more details).
3. Run [`winsw install myapp.xml [options\]`](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#install-command) to install the service.
4. Run [`winsw start myapp.xml`](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#start-command) to start the service.
5. Run [`winsw status myapp.xml`](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#status-command) to see if your service is up and running.

## 局部使用（名称绑定）

1. Take *WinSW.exe* or *WinSW.zip* from the distribution, and rename the *.exe* to your taste (such as *myapp.exe*).
2. Write *myapp.xml* (see the [XML config file specification](https://github.com/winsw/winsw/blob/v3/docs/xml-config-file.md) and [samples](https://github.com/winsw/winsw/blob/v3/samples) for more details).
3. Place those two files side by side, because that's how WinSW discovers its co-related configuration.
4. Run [`myapp.exe install [options\]`](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#install-command) to install the service.
5. Run [`myapp.exe start`](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#start-command) to start the service.

# 指定用户执行

https://github.com/winsw/winsw/blob/v3/docs/xml-config-file.md

```xml
<serviceaccount>
  <username>DomainName\UserName</username>
  <password>Pa55w0rd</password>
  <allowservicelogon>true</allowservicelogon>
</serviceaccount>
```

