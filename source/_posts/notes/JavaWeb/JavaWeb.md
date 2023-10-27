---
title: JavaWeb
date: 2022-12-08 16:50:30
tags:
  - web基础
categories:
  - 笔记
---

# session

## 获取

可通过request的getSession方法来使用session

通过setAttribute方法注入值

通过getAttribute方法获取session中的值

通过removeAttribute()移除某个值

## 意义

客户端与服务端之间的会话是无状态的, 无状态:会话之间无关联性,无法识别该用户曾经访问过

session可以将关键数据存放在服务器端. 与cookie不同,cookie是将数据存放在客户端的浏览器中

## 生命周期

session存储在服务器的内存中for高速存取

### 何时生效

session在用户第一次访问时创建,需要注意只有访问jsp,servlet时才会创建,而访问html,image等静态资源并不会创建session, 可以调用request.getSession(true)强制创建

### 何时失效

服务器会把长时间没有活动的session从服务器内存中清除,此时session失效, tomcat中的session默认失效时间为20分钟

一旦session被访问,计时清零

或者可以调用sessioin的incalidate方法可以主动清除

### 设置失效时间

web.xml方式:

```xml
<session-config>
    <session-timeout>30</session-timeout>
</session-config>
```



动态设置

```java
request.getSession().setMaxInactiveInterval(多少秒);
//永不过期
request.getSession().setMaxInactiveInterval(-1);
```

tomcat server.xml中设置

```xml
<Context path="/livsorder" 
docBase="/home/httpd/html/livsorder" 　　defaultSessionTimeOut="3600" 
isWARExpanded="true" 　　
isWARValidated="false" isInvokerEnabled="true" 　　isWorkDirPersistent="false"/>
```

## 原理

在客户端浏览器cookie保存sessionID,客户端发送请求时会携带

该cookie值一般为服务器自动生成,仅在当前浏览器有效,各浏览器之间不共享,关闭整个浏览器就会失效,但是由浏览器内的链接,脚本等打开的新窗口会共享父窗口的cookie,也就是会共享一个session

## 不支持解决

如果客户端浏览器将Cookie功能禁用，或者不支持Cookie怎么办？例如，绝大多数的手机浏览器都不支持Cookie。Java Web提供了另一种解决方案：URL地址重写。

URL地址重写是对客户端不支持Cookie的解决方案。URL地址重写的原理是将该用户Session的id信息重写到URL地址中。服务器能够解析重写后的URL获取Session的id。这样即使客户端不支持Cookie，也可以使用Session来记录用户状态。HttpServletResponse类提供了encodeURL(String url)实现URL地址重写，该方法会自动判断客户端是否支持Cookie。如果客户端支持Cookie，会将URL原封不动地输出来。如果客户端不支持Cookie，则会将用户Session的id重写到URL中。

TOMCAT判断客户端浏览器是否支持Cookie的依据是请求中是否含有Cookie。尽管客户端可能会支持Cookie，但是由于第一次请求时不会携带任何Cookie（因为并无任何Cookie可以携带），URL地址重写后的地址中仍然会带有jsessionid。当第二次访问时服务器已经在浏览器中写入Cookie了，因此URL地址重写后的地址中就不会带有jsessionid了。