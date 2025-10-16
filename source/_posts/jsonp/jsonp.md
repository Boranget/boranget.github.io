---
title: jsonp
date: 2025-02-27 10:35:19
updated: 2025-02-27 16:35:19
tags:
  - jsonp
categories:
  - 笔记
---

# 参考资料

[JSONP 跨域原理及实现 - JavaScript进阶之路 - SegmentFault 思否](https://segmentfault.com/a/1190000041946934)

# 定义

解决跨域的一种方法

jsonp本质上是使用了浏览器不会限制script标签source属性的访问，故可以让服务器将响应封装到js代码里返回

# 例子

```java
@WebServlet("/jsonp")
public class JsonpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 设置响应类型为JavaScript
        response.setContentType("application/javascript");
        
        // 获取回调函数名
        String callback = request.getParameter("callback");
        
        // 简单的JSON数据
        String jsonData = "{\"name\":\"张三\",\"age\":25,\"message\":\"这是JSONP响应数据\"}";
        
        // 构造JSONP响应：回调函数(数据)
        String jsonpResponse = callback + "(" + jsonData + ")";
        
        // 输出响应
        response.getWriter().print(jsonpResponse);
    }
}
```

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>简单JSONP示例</title>
</head>
<body>
    <script>
        // 定义回调函数
        function handleResponse(data) {
            console.log("收到JSONP响应:");
            console.log("姓名: " + data.name);
            console.log("年龄: " + data.age);
            console.log("消息: " + data.message);
            alert("收到数据: " + data.name);
        }
    </script>
    
    <!-- 动态创建script标签发起JSONP请求 -->
    <script>
        // 创建script元素
        var script = document.createElement('script');
        // 设置请求URL，包含回调函数名，这里的函数名是给后端看的，让后端知道应该调用哪个函数来获取值
        script.src = 'http://localhost:8080/jsonp?callback=handleResponse';
        // 将script元素添加到页面
        document.body.appendChild(script);
    </script>
</body>
</html>

```

