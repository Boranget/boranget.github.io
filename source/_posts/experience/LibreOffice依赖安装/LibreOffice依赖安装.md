---
title: LibreOffice依赖安装
date: 2024-01-23 10:35:19
tags:
  - LibreOffice依赖安装
categories:
  - 经验
---

# 项目

一个文件转换项目

[GitHub - jodconverter/jodconverter: JODConverter automates document conversions using LibreOffice or Apache OpenOffice.](https://github.com/jodconverter/jodconverter)

# LibreOffice安装脚本

```sh
#!/bin/bash
cd /tmp

install_redhat() {
   wget https://downloadarchive.documentfoundation.org/libreoffice/old/7.5.3.2/rpm/x86_64/LibreOffice_7.5.3.2_Linux_x86-64_rpm.tar.gz -cO LibreOffice_7_rpm.tar.gz && tar -zxf /tmp/LibreOffice_7_rpm.tar.gz && cd /tmp/LibreOffice_7.5.3.2_Linux_x86-64_rpm/RPMS
   echo $?
   if [ $? -eq 0 ];then
     yum install -y libSM.x86_64 libXrender.x86_64  libXext.x86_64
     yum groupinstall -y  "X Window System"
     yum localinstall -y *.rpm
     echo 'install finshed...'
   else
     echo 'download package error...'
   fi
}

install_ubuntu() {
   wget https://downloadarchive.documentfoundation.org/libreoffice/old/7.5.3.2/deb/x86_64/LibreOffice_7.5.3.2_Linux_x86-64_deb.tar.gz  -cO LibreOffice_7_deb.tar.gz && tar -zxf /tmp/LibreOffice_7_deb.tar.gz && cd /tmp/LibreOffice_7.5.3.2_Linux_x86-64_deb/DEBS
   echo $?
 if [ $? -eq 0 ];then
     apt-get install -y libxinerama1 libcairo2 libcups2 libx11-xcb1
     dpkg -i *.deb
     echo 'install finshed...'
  else
    echo 'download package error...'
 fi
}


if [ -f "/etc/redhat-release" ]; then
  yum install -y wget
  install_redhat
else
  apt-get install -y wget
  install_ubuntu
fi

```

# 步骤

运行以上脚本即可，libreoffice会安装到opt目录下

# 乱码

- 系统字体缺失

    大部分Linux系统上并没有预装中文字体或字体不全，需要把常用字体拷贝到Linux服务器上，具体操作如下： 下载如下字体包 https://kkfileview.keking.cn/fonts.zip 文件解压完整拷贝到Linux下的 /usr/share/fonts目录。然后依次执行mkfontscale 、mkfontdir 、fc-cache使字体生效

- liberoffice字体缺失

    在/opt/libreoffice7.5/share/fonts目录存入字体文件夹，重启服务