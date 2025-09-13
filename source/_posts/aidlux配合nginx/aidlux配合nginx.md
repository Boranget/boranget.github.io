---
title: aidlux 配合 nginx 搞一个小服务器用
date: 2022-10-02 16:50:30
updated: 2023-07-25 16:50:30
tags:
  - 服务器
  - nginx
categories:
  - 经验
---

# 内网渗透工具

选择一款的内网渗透工具，such as [飞鸽，点击注册](https://www.fgnwct.com/register.html?utm_from=MzU1MjE=)，注意客户端要下载arm64的
免费的基本能用，不过速度比较慢，对速度有要求比如想要远程控制aidlux的建议付费上高速通道。
# nginx反向代理
aidlux 已经安装了nginx，其配置文件在：/etc/nginx/下
![在这里插入图片描述](aidlux配合nginx/cd1b93819d4b41c2942efe09d2ae9409.png)
![在这里插入图片描述](aidlux配合nginx/523e7c9c123347c5ac63a4eed7a36307.png)
我们可以在这个文件夹下创建一个conf结尾的文件：
![在这里插入图片描述](aidlux配合nginx/2f4ec666c4444ef99b1c609b4f2cd313.png)![在这里插入图片描述](aidlux配合nginx/517e7610fabe4806bcf8c2c12c735a7b.png)
其中末尾斜杠可参考[nginx如何配置代理转发](https://www.php.cn/nginx/425693.html#:~:text=nginx%E9%85%8D%E7%BD%AE%E4%BB%A3%E7%90%86%E8%BD%AC%E5%8F%91%E7%9A%84%E6%96%B9%E6%B3%95%EF%BC%9A%E9%A6%96%E5%85%88%E5%9C%A8location%E4%B8%AD%E7%9A%84proxy_pass%E8%AE%BE%E7%BD%AE%E6%96%B0%E7%9A%84url%EF%BC%9B%E7%84%B6%E5%90%8E%E5%9C%A8proxy_set_header%20Host%E8%AE%BE%E7%BD%AEIP%E5%9C%B0%E5%9D%80%E5%92%8C%E7%AB%AF%E5%8F%A3%E5%8F%B7%E5%8D%B3%E5%8F%AF%E3%80%82Nginx%E6%98%AF%E4%B8%AA%E5%8E%89%E5%AE%B3%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%EF%BC%8C%E5%8F%AF%E4%BB%A5%E9%85%8D%E7%BD%AE%E5%A4%9A%E4%B8%AA%E6%9C%8D%E5%8A%A1%E5%99%A8%EF%BC%8C%E4%B8%80%E4%B8%AAserver%E5%B0%B1%E6%98%AF%E4%B8%80%E4%B8%AA%E6%9C%8D%E5%8A%A1%E5%99%A8%20server,%7B%20listen%2080;%20server_name)
# 服务自启
在/root/下找到 .rc.local文件编辑
![在这里插入图片描述](aidlux配合nginx/c8a9f186bb6645c4aa3c7ad4a5102eba.png)
后台启动部分可以参考[Linux nohup 命令](https://www.runoob.com/linux/linux-comm-nohup.html)