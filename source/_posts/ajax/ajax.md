---
title: ajax
date: 2023-04-22 10:35:19
updated: 2023-11-09 10:35:19
tags:
  - ajax
categories:
  - 笔记
---

# Ajax

Asynchronous JavaScript and XML

- 可以在不重新加载整个页面的情况下，与服务器交换数据
- 不需要浏览器插件，只需要运行JavaScript执行
- Ajax的一种实现方式：XMLHttpRequest
- 不必等待响应回来就可以继续操作甚至可以发送下一个ajax请求

# Ajax的实现

- 原生JS实现方式
- 第三方封装好的工具如 jquery
- 使用框架 vue axios

# 原生JS

```js
function getMessage(){
    var request = new XMLHttpRequest();
    // request.readState 1 2 3 4，其中4为收到响应
    // 回调函数
    request.onreadystatechange=function(){
        if(request.readyState == 4 && request.status == 200){
            document.write(request.responseText);
        }
    }
    request.open("GET","http://d1.weather.com.cn/sk_2d/101210401.html?_=[[2]]");
    request.send();
}
```

注意有同源限制会报错

> VM1665:11  [Report Only] Refused to connect to 'http://d1.weather.com.cn/sk_2d/101210401.html?_=[[2]]' because it violates the following Content Security Policy directive: "connect-src 'self