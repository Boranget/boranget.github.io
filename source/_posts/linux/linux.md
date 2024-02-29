---
title: Linux
date: 2021-02-02 16:50:30
updated: 2024-01-29 10:35:19
tags:
  - linux
categories:
  - notes
---

# 常用快捷键

| 按键            | 作用                  |
| ------------- | ------------------- |
| ctrl+d        | 键盘输入结束或退出终端         |
| ctrl+s        | 暂停当前程序              |
| ctrl+z        | 当前程序放到后台运行，恢复到前台为fg |
| ctrl+a        | 将光标移到行头，相当于home     |
| ctrl+e        | 相当于end              |
| ctrl+k        | 删除从光标到行末的内容         |
| alt+Backspace | 删除一个单词（不是字母）        |
| shift+PgUp    | 终端向上                |
| shift+PgDn    | 终端向下                |

# Shell中常用的通配符

| 字符             | 含义                    |
| -------------- | --------------------- |
| *              | 匹配0或多个字符              |
| ？              | 匹配任意一个字符              |
| [list]         | 匹配list中任意单一字符         |
| [^list]        | 匹配list之外的字符           |
| [c1-c2]        | 匹配c1到c2中任意单一字符如 [0-9] |
| {s1,s2,......} | 匹配其中一个字符串             |
| {c1..c2}       | 匹配全部字符                |

# Linux的目录结构

- /bin
  
  Binary的缩写，存放着最经常使用的命令

- /sbin
  
  super bin， 存放系统管理员使用的系统管理程序

- /home
  
  存放普通用户的主目录，其中每个linux用户都有自己的一个目录，相当于win中的user

- /root
  
  系统管理员的用户主目录

- /boot
  
  存放启动linux时的核心文件

- /proc
  
  一个虚拟的目录，系统内存的映射

- srv
  
  存放一些服务启动后要提取的数据

- sys
  
  存放了一个文件系统

- tmp
  
  存放临时文件

- /dev
  
  相当于设备管理器，把所有的硬件以文件的形式存储

- /media
  
  linux自动识别一些设备，如U盘光驱等， 识别后会把识别的设备挂载到这个目录下

- /mnt
  
  系统提供该目录给用户临时挂在别的文件系统，用户可以将外部的存储挂载在/mnt/

- /opt
  
  给主机额外安装软件所用的目录

- /usr/local
  
  安装额外软件的目录，一般是通过编译源码安装的

- /var
  
  存放经常修改的目录，比如各种日志

- /selinux[security-enhanced linux] 360
  
  一种安全子系统，可以控制程序只能访问特定文件

# vim

## 模式

- esc -> 默认模式
- i|a -> 编辑模式
- :|/ -> 命令模式

## 常用快捷键

通常是指默认模式下

- v 选择模式

- 选择模式按下y复制

- 拷贝当前行 yy

- 粘贴 p

- 选择模式删除选中 d

- 删除当前行 dd

- 连续删除5行 5dd

- 查找 /关键字，光标会跳到查找位置，n为查找下一个

- 设置显示行号 :set nu 

- 设置取消行号 :set nonu 

- 最末行 G 第一行 gg

- 撤销一步 u

- 跳到第4行 默认模式 4 shift+g

- 设置编码 :set encoding=utf-8

# 关机/登录/注销

- sync 将内存中数据写入磁盘
- shutdown
  - -h now 立即关机
  - -h 1 1分钟后关机
  - -r now 立即重启
- halt 等价于关机
- reboot 重启
- logout 注销， 在图形界面无效

# 用户/用户组

## 相关操作

- useradd \<用户名\> 新增一个用户
- useradd -d 指定某目录 -g 指定组 \<用户名\> 
- passwd \<用户名\> 更改密码
- userdel \<用户名\> 删除用户
- userdel -r \<用户名\> 删除用户及其目录
- id  \<用户名\>  查询用户信息
- su -  \<用户名\>  切换用户
- su 切换到root
- exit 返回上一个用户
- groupadd  \<组名\> 添加组
- groupdel  \<组名\> 删除组
- usermod -g \<组名\>   \<用户名\>  切换一个用户到另一个组
- usermod -d \<目录名\>   \<用户名\>  改变用户目录

## 几个点

- 从权限高的用户切换到权限低的用户不需要输入密码

- sudo \<cmd\> 可以以特权级别运行 cmd 命令， 需要当前用户属于 sudo 组，且需要输入当前用户的密码

- su - \<user\> 也可以切换当前用户到user，但同时用户的环境变量和工作目录也会随之改变

- groups \<用户名\> 查看该用户所在组

- groups 查看当前用户所在组

- adduser 和 useradd 的区别
  
  useradd 只创建用户，不会创建用户密码和工作目录， 创建完了要用passwd \<username\> 去设置用户密码
  
  adduser 在创建用户的同时会有创建密码和工作目录的步骤
  
  useradd类似命令，adduser 类似程序

- /etc/passwd 文件 存放用户的各种信息
  
  用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录shell

- /etc/shadow 文件 存放口令配置
  
  登 录 名:加 密 口 令: 最 后 一 次 修 改 时 间:最 小 时间 隔:最 大 时 间 回 隔:警 告 时 间:不 活 动  时 间 :失 效 时 间:标 志

- /etc/group 文件 存放组信息
  
  组名:口令:组标识号:组内用户列表

# 运行级别

- 0：关机
- 1：单用户[找回丢失密码]
- 2：多用户状态没有网络服务
- 3：多用户状态有网络服务
- 4：系统未使用
- 5： 图形界面
- 6： 系统重启

常用级别为3和5

修改/etc/inittab 的id:5:initdefault: 这一行中的数字改变默认运行级别

## 单用户状态找回root密码

开机 > 引导时回车 > 输入 e > 选第二行编辑内核 > 输入e > 输入1回车 > 输入 b 此时进入单用户模式,可使用passwd修改root密码 > reboot 重启

# 帮助命令

- man  <命令> 
- help  <命令> 

# 文件操作

- pwd 显示当前工作目录的绝对路径

- ls  [option] [目录或者文件] 
  
  - -a 显示当前目录所有文件和目录，包括隐藏内容
  - -l 列表方式显示
- du -sh 文件夹名 统计文件夹内容大小

- cd [参数] 进入目录
  
  - cd ~ 或者 cd : 
    
    进入用户目录
  
  - 当前路径 cd .
  
  - 上一级 cd ..
  
  - 绝对路径 cd /

- mkdir [option]  <目录名> 创建目录
  
  - -p 创建多级目录

- rmdir [option]  <目录名> 删除目录
  
  - -rf 删除非空目录

- touch  <文件名> 创建文件

- cp [option] \<源文件/目录\> \<目标目录/目标文件名\> 复制文件
  
  - -r 复制文件夹
  
  - 指定目标文件名会在复制的同时重命名
  
  - 强制覆盖 \\cp [option] \<源文件/目录\> \<目标目录/目标文件名\> 
  
  - scp 系统之间传输文件（需要开启ssh）
    
    scp C:\Users\zbh\Desktop\1.txt  lucas@192.168.11.150:/home/lucas/

- rm [option]  <目录名/文件名> 删除
  
  - -r 删除文件夹
  - -f 强制删除不提示
  - 比如 rm -rf 

- mv \<源文件/目录\> \<目标目录/目标文件名\> 移动文件或者重命名

- cat [option]   输出文件内容
  
  - -n 显示行号
  - 一般搭配管道命令 |more 使用分页浏览

- more <文件名>
  
  - space 向下一页
  - enter 向下一行
  - q 退出
  - ctrl+f 向下一屏
  - ctrl+b 向上一屏
  - = 输出当前行行号
  - :f 输出文件名和当前行行号

- less <文件名> 类似more，但非一次性读出，适合大文件浏览
  
  - space 向下一页
  - pagedown 向下一页
  - pageup 向上一页
  - / 向下搜索 n 下一个 N 上一个
  - ? 向上搜索 n 上一个 N 下一个
  - q 退出

# 覆盖追加

- \> 将原来的内容覆盖
- \>\> 追加到文件尾部

例如：ls -l > a.txt 将ls -l 的显示内容覆盖到a.txt中， 如果文件不存在则创建

- tee 指令
  
  -a 追加

# echo

输出内容到控制台

echo $PATH 

# head&tail

- head 用于显示文件的开头部分内容
  - head \<文件名\> 查看文件前十行内容
  - head -n 5  \<文件名\> 查看前5行内容
- tail 显示文件尾部内容
  - tail  \<文件名\> 查看后十行
  - tail -n 5  \<文件名\> 查看后5行
  - tail -f  \<文件名\> 实时追踪更新

# 链接

## 链接的概念

类似于win中的快捷方式，但不大相同

- 硬链接 hard link
  
  与快捷方式不同的是，硬链接和源文件都是指向同一个文件，但是如果一个文件创建了硬链接，那即使将源文件删除， 也可以通过硬链接去访问。直到将所有的硬链接删除，才算删除彻底。
  
  这里有个概念为inode，每次增加一个硬链接，该文件的inode会加1，当删除文件直到inode为0时，才算彻底删除
  
  需要注意的是
  
  - 硬链接以副本的方式存在，但不占用实际空间
  - 不允许给目录创建硬链接
  - 硬链接只有在同一个文件系统中才能创建

- 软链接 又叫符号链接 symbolic link
  
  类似于快捷方式，源文件删除后，软链接也会失效
  
  - 以路径的形式存在
  - 可以跨文件系统
  - 可以对一个不存在的文件名链接
  - 可以对目录链接

## ln命令

ln命令用于创建链接文件

ln [option]  \<文件名\>

- -b 删除， 覆盖以前建立的链接
- -d 允许超级用户制作目录的硬链接
- -f 强制执行
- -i 交互模式， 文件存在则提示用户是否覆盖
- -n 把软链接视为一般目录
- -s 软链接（符号链接）
- -v 显示详细的处理过程

注意的是。如果删除软链接时，文件名末尾带斜杠，会显示资源忙

## 移动复制

cp 软链接到另一个位置，该软连接会失效，若试图将其打开会提示没有那个文件或目录。

cp硬链接到另一个位置正常。

# history

用于查看最近的指令

!n 执行历史记录中编号为n的指令，!n之间无空格

# 时间日期

date 显示当前日期

- date +%Y 显示年份
- date +%m 显示月份
- date +%d 显示天
- date "+%Y年%m月%d日 %H点%M分%S秒" 连接符显示， 为了避免空格导致参数中断，可以加双引号
- date -s "2021-10-10 11:22:33" 设置当前时间

ntpdate -u ntp.api.bz 根据时间同步服务器同步时间

cal 查看日历（需要安装）

- cal 2018 查看2018年的全部日历

# 搜索

find [搜索范围] [option]  \<关键词\>

- -name 按照文件名 默认为该模式
  
  可使用通配符* 比如find -name \*ello\*

- -user 按照用户名

- -size 按照文件大小
  
  - find -size +20M 查找大于20M的文件
  - find -size 20M 查找等于20M的文件
  - find -size -20M 查找小于20M的文件

locate 在索引中查找，会快一点，但需要更新索引

grep [option] [文件名] \<关键词\>在文件中查找具体内容

- -n 显示行号
- -i 忽略大小写

# 压缩解压

## *.gz

gzip用于压缩文件，gunzip用于解压文件

gzip压缩之后不会保留源文件

## *.zip

zip用于压缩文件，unzip用于解压

zip  [option]  \<压缩后文件名\>  \<压缩文件名\>

- -r 递归压缩目录

unzip  [option]  \<解压文件名\>  

- -d \<目标目录文件名\>

## *.tar.gz

tar [option] \<压缩后文件名\>  \<压缩文件名\>

- -c 产生 *.tar 打包文件
- -v 显示详细信息
- -f 指定压缩后的文件名
- -z 打包的同时压缩
- -x 解包

示例：

- 压缩多个文件
  
  tar -zcvf a.tar.gz a.txt b.txt

- 解压到当前目录
  
  tar -zxvf a.tar.gz

- 解压到已存在目录
  
  tar -zxvf a.tar.gz -C /opt/

# 组管理和权限管理

- 文件所有者
  
  一般文件所有者为文件创建者
  
  - 查看文件所有者 ls -l
  - 修改文件所有者：chown  <用户名>  <文件名>
  - 递归修改：chown -R  <用户名>  <文件名>

- 文件所有组
  
  - 查看文件所在组：ls -l
  - 修改文件所在组：chgrp  <组名>  <文件名>
  - 递归修改文件所在组：chgrp -R  <组名>  <文件名>

## 文件信息说明

lrwxrwxrwx 1 root root    5  5月 23 10:29 test1c -> test1

- 0：文件类型 d目录 -文件 l链接 c输入设备 b块文件硬盘
- 123：所有者权限 u
- 456：所属组权限 g
- 789 其他用户权限 o
- 文件的硬链接数，目录的子目录（包括.和..）
- 所属用户
- 所属用户组
- 文件大小（目录的大小固定为4096）
- 最后更新时间
- 文件名

## 权限说明

- 文件
  - r 可读取
  - w 可修改（不包括删除）
  - x 可被执行
- 目录
  - r 可读取，ls查看目录内容
  - w 可修改 创建删除文件以及重命名目录
  - x 可进入该目录

可用数字表示 r=4，w=2，x=1 

如 rwx = 4+2+1 = 7

修改权限

- chmod u=rwx,g=rx,o=x  <文件名> = chmod 751 <文件名>
- chmod o+w <文件名>
- chmod a-x <文件名>

# crond

| 字段  | 是否必填 | 允许值  | 可用特殊字符  |
| --- | ---- | ---- | ------- |
| 分   | 是    | 0-59 | ， - * / |
| 小时  | 是    | 0-23 | ， - * / |
| 月中日 | 是    | 1-31 | ， - * / |
| 月   | 是    | 1-12 | ， - * / |
| 周中日 | 是    | 0-7  | ， - * / |

| 特殊符号 | 含义                                                                                                 |
| ---- | -------------------------------------------------------------------------------------------------- |
| *    | 所有字段可用，表示对应时间域的每一个时刻，例如，***** 在分钟字段时，表示“每分钟”                                                       |
| -    | 表达一个范围，如在小时字段中使用“10-12”，则表示从10到12点，即10,11,12                                                       |
| ,    | 表达一个列表值，如在周中日中使用“1,3,5”，则表示星期一，星期三和星期五                                                             |
| /    | x/y表达一个等步长序列，x为起始值，y为增量步长值。如在分钟字段中使用0/15，则表示为0,15,30和45秒，而5/15在分钟字段中表示5,20,35,50，你也可以使用*/y，它等同于0/y |

crontab 任务管理

- -e 编辑定时任务
- -l 查询定时任务
- -r 删除当前用户所有定时任务

cron 服务管理

- service cron start
- service cron restart
- service cron stop

# 磁盘

- 格式化磁盘 mkfs -t ext4 /dev/sdb1

- mount <设备名称> <挂载目录>

- unmount <设备名称> 或者 <挂载目录>

- 修改 /etc/fstab 实现挂载， 修改之后执行 mount -a 生效 

- df -lh 查询磁盘使用情况

- du -h <目录名> 查询指定目录的磁盘占用
  
  - -a 显示具体文件
  - -s 只显示整个目录占用大小，不可与a同时使用
  - -h 带计量单位
  - -c 列出明细增加汇总值
  - --max-depth=1 查询子目录深度

## 挂载多个物理磁盘到一个逻辑磁盘

1. 创建PV
   
   physical volume 物理卷，物理磁盘，可以通过fdisk -l查看操作系统上有几块硬盘
   
   ```bash
   pvcreate /dev/sdb # 创建磁盘1
   pvcreate /dev/sdc # 创建磁盘2
   ```

2. 创建VG
   
   volume group 卷组，一组物理磁盘的组合，其中可以有一块或多块磁盘。
   
   卷组在创建时可以指定磁盘，创建完成也可以通过拓展增加磁盘。
   
   ```bash
   # 创建磁盘组 lvm_data
   vgcreate lvm_data /dev/sdb /dev/sdd
   # 扩展磁盘组 lvm_data
   vgextend lvm_data /dev/sdc
   ```

3. 创建LV
   
   logic volume 逻辑卷
   
   ```bash
   # 从lvm_data 中划分出一块110G大小的空间分配给逻辑块 vg_data
   lvcreate -110.0G -n vg_data lvm_data
   ```

4. 格式化分区
   
   ```bash
   # mkfs -t [文件系统] [分区位置]
   mkfs -t ext4 /dev/lvm_data/vg_data
   ```

5. 挂载分区
   
   ```bash
   # mount [分区位置] [目录地址]
   mount /dev/lvm_data/vg_data /data
   ```

6. 设置开机加载
   
   在/etc/fstab文件末尾添加如下行
   
   ```
   /dev/lvm_data/vg_data  /data  ext4  defaults  0 0
   ```

# 文件统计

通过搭配使用 ls ，grep，wc命令

- ls 文件信息
- grep 正则表达式的筛选
- wc 统计行数

例：

统计文件个数

​    ls -l |grep "^-" |wc -l

树状显示 tree

# 进程管理

分为前台进程和后台进程，且每个进程都会有一个父进程，父进程结束后子进程也会结束，比如ssh连接

- ps 查看进程
  
  - -e 显示所有进程
  - -f 全格式

- ctrl + c 终止前台进程

- kill [option] <进程号> 结束进程
  
  - -9 立刻停止

- pstree 进程数
  
  - -p 显示pid
  - -u 显示进程所属用户

- service [start|stop|restart|reload|status] <服务名> 服务管理

- top [option] 动态进程监控
  
  - -d <秒> 更新间隔
  - -l 不显示闲置或僵死进程
  - -p 指定进程pid
  
  运行后交互
  
  - P cpu排序
  - M 内存排序
  - N pid排序
  - q 退出
  - u 输入用户
  - k 杀死进程

# 网络

## netstat

- -an 按一定顺序
- -p 显示哪个进程在调用

## ip

类似于ifconfig

```bash
ip link show                     # 显示网络接口信息
ip link set eth0 up             # 开启网卡
ip link set eth0 down            # 关闭网卡
ip link set eth0 promisc on      # 开启网卡的混合模式
ip link set eth0 promisc offi    # 关闭网卡的混个模式
ip link set eth0 txqueuelen 1200 # 设置网卡队列长度
ip link set eth0 mtu 1400        # 设置网卡最大传输单元
ip addr show     # 显示网卡IP信息
ip addr add 192.168.0.1/24 dev eth0 # 设置eth0网卡IP地址192.168.0.1
ip addr del 192.168.0.1/24 dev eth0 # 删除eth0网卡IP地址

ip route show # 显示系统路由
ip route add default via 192.168.1.254   # 设置系统默认路由
ip route list                 # 查看路由信息
ip route add 192.168.4.0/24  via  192.168.0.254 dev eth0 # 设置192.168.4.0网段的网关为192.168.0.254,数据走eth0接口
ip route add default via  192.168.0.254  dev eth0        # 设置默认网关为192.168.0.254
ip route del 192.168.4.0/24   # 删除192.168.4.0网段的网关
ip route del default          # 删除默认路由
ip route delete 192.168.1.0/24 dev eth0 # 删除路由
```

## 防火墙

- 查看防火墙状态
  
  ```shell
  firewall-cmd --state
  ```

- 开启/关闭防火墙
  
  ```shell
  systemctl start(stop) firewalld
  ```

- 查看防火墙已经开放的端口号
  
  ```shell
  firewall-cmd --list-ports
  ```

- 开放指定端口
  
  ```shell
  firewall-cmd --zone=public --and-port=3306/tcp --permanent
  ```
  
  > –zone #作用域
  > –add-port=3306/tcp #添加端口，格式为：端口/通讯协议
  > –permanent #永久生效，没有此参数重启后失效

- 关闭指定端口
  
  ```shell
  firewall-cmd --remove-port=3306/tcp --permanent
  ```

- 重启防火墙
  
    每次打开或者关闭防火墙需要重启才生效
  
  ```shell
  firewwall-cmd --reload
  ```

- 检查端口是否开放
  
  ```shell
  firewall-cmd --query-port=3306/tcp
  ```

# 开启ssh

- 安装sshserver
  
  apt-get install openssh-server

# 环境变量配置

编辑 `/etc/profile`，末尾添加export

编辑完成保存

```shell
# 重新加载使其生效
source /etc/profile
```

# 一个sh文件样例

```sh
#!/bin/sh -x

## Init Paramter
ftp_home=/export/home/nbdadm
report_name=PUECHASE
file_name=$1
local_folder=/export/home/nbpadm/icwftp/outbound/PO
remote_folder=/app_data/systemsfiles/prpo/attachment/efax
archive=/export/home/nbdadm/icwftp/archive/PO
NOWYEAR=`data + "%Y"`
NOWMONTH=`data + "%m"`
NOWDAY=`data + "%d"`
NOWTIME=${NOWDAY}${NOWMONTH}${NOWYEAR}
tmp_ftp_script=/tmp/tmp_ftp_script_${file_name}
file='*'

## GET User/Password
password_file=${ftp_home}/etc/smic_ftp_password.ini
username=`cat $password_file |grep $report_name | awk {'print $2'}`
password=`cat $password_file |grep $report_name | awk {'print $3'}`
ftp_server=`cat $password_file |grep $report_name | awk {'print $4'}`

## FTP Files
echo "open ${ftp_server}" > ${tmp_ftp_script}
echo "user ${username} ${password}" >> ${tmp_ftp_script}
echo "cd ${remote_folder}" >> ${tmp_ftp_script}
echo "mkdir ${NOWYEAR}" >> ${tmp_ftp_script}
echo "cd ${NOWYEAR}" >> ${tmp_ftp_script}
echo "mkdir ${NOWMONTH}" >> ${tmp_ftp_script}
echo "cd ${NOWMONTH}" >> ${tmp_ftp_script}
echo "mkdir ${NOWDAY}" >> ${tmp_ftp_script}
# l前缀的cd为进入本地文件夹
echo "lcd ${local_folder}" >> ${tmp_ftp_script}
echo "cd ${remote_folder}/${NOWYEAR}/${NOWMONTH}/${NOWDAY}" >> ${tmp_ftp_script}
echo "bi" >> ${tmp_ftp_script}
echo "prom" >> ${tmp_ftp_script}
echo "mput ${file}" >> ${tmp_ftp_script}
echo "quit" >> ${tmp_ftp_script}

#cat ${tmp_ftp_script}
ftp -vin < ${tmp_ftp_script}
rm -f ${tmp_ftp_script}
mkdir ${archive}/${NOWTIME}
mv ${local_folder}/* ${archive}/${NOWTIME}


## smic_ftp_password.ini
# S11-U01   user001     mypass..    10.224.6.10     s118001/outbound
# S11-U03   user002     mypass..    10.224.6.11     s118001/outbound
# S11-U04   user003     mypass..    10.224.6.13     s118001/outbound

```

# 安装openjdk

```shell
apt install openjdk-17-jdk
```

# 字体安装

需要先安装字体管理工具 apt install xfonts-utils

将ttf字体文件拷贝到Linux下的 /usr/share/fonts目录。然后依次执行mkfontscale 、mkfontdir 、fc-cache使字体生效

# 端口占用进程查询以及kill

查看是否有进程占用

netstat -tunlp|grep {port}

kill -9 {pid}

# systemctl

## 服务注册

```
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target

```

## 命令

```bash
# 启动
systemctl start servername
# 停止
systemctl stop servername
# 重启
systemctl restart servername
# 刷新服务
systemctl daemon-reload
```

