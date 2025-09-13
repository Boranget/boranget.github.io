---
title: JavaWeb
date: 2022-12-08 16:50:30
updated: 2023-11-09 10:35:19
tags:
  - javaWeb
categories:
  - 笔记
---

# 静态/动态资源

- 静态资源

    提前写好的请求时能直接用的资源如图片、css、js、以及html文件等

- 动态资源

    需要在程序运行时通过代码运行生成的资源如servlet、thymeleaf等

# Servlet

tomcat接收到请求后会将请求报文转为一个HttpServletRequest对象，同时创建一个HttpServletResponse对象，用于存放响应报文信息。

tomcat会根据请求中的资源路径找到对应的servlet，调用service方法，并且将HttpServletRequest和HttpServletResponse对象传入。

## HelloWorld

1. 创建javaWeb项目，导入tomcat依赖

2. 重写service方法

3. 在service方法中定义业务逻辑

    ```java
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
       	 	// 从request中获取请求数据，此方法无论是get还是post方式都可以获取
       		req.getParameter("username");
    		// 业务逻辑
        	...
            String res = ....
    		// 将响应放入HttpServletResponse
            // 获取打印流
            PrintWriter writer = response.getWriter();
        	writer.write(res);
        }
    ```

4. 在 web.xml中配置servlet

    1. 起一个名定义一个servlet
    2. 给这个servlet绑定类
    3. 给servlet定一个路径(一个servlet可以绑定多个路径/mapping)

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee https://jakarta.ee/xml/ns/jakartaee/web-app_5_0.xsd"
             version="5.0">
        <servlet>
            <servlet-name>helloServlet</servlet-name>
            <servlet-class>MyServlet</servlet-class>
        </servlet>
        <servlet-mapping>
            <servlet-name>helloServlet</servlet-name>
            <url-pattern>/hello</url-pattern>
            <url-pattern>/hello1</url-pattern>
            <url-pattern>/hello2</url-pattern>
        </servlet-mapping>
            <servlet-mapping>
            <servlet-name>helloServlet</servlet-name>
            <url-pattern>/hello3</url-pattern>
            <url-pattern>/hello4</url-pattern>
            <url-pattern>/hello5</url-pattern>
        </servlet-mapping>
    </web-app>
    ```

## servlet-api.jar

编码的时候需要依赖，运行时tomcat中已有，所以打包时不需要携带

## Content-type

MIME类型响应头

用于告知浏览器响应的是什么数据，客户端以此决定如何解析，默认不带，浏览器当作html解析

静态资源可通过扩展名在web.xml中找到对应的mime类型

动态资源需要手动设置

```java
response.setHeader("Content-type","text/html");
// or
response.setContentType("text/html");
```

## url-pattern

- 精确匹配

- 模糊匹配

    / 匹配全部，但不包含jsp文件

    /* 匹配全部，包含jsp文件

    /a/* 匹配前缀

    *.action 匹配后缀

## 注解方式配置

在servlet类上注解@WebService("/hello")

## 生命周期

- 实例化

    构造器

- 初始化

    init方法

- 接受请求并处理

    service方法

- 销毁

    destory方法

servlet是单例模式，构造器和初始化只执行一次，在tomcat关闭时执行destory，service方法每次请求都会执行

注意servlet的线程安全问题

## 提前初始化

```xml
<servlet>
    <servlet-name>helloServlet</servlet-name>
    <servlet-class>MyServlet</servlet-class>
    <!-- -1表示该servlet不会在tomcat启动时便初始化 -->
    <!-- 正整数比如5表示该servlet会在tomcat启动时第几个初始化 -->
    <!-- 如果序号冲突，tomcat会自动协调 -->
    <load-on-startup>-1</load-on-startup>
</servlet>
```
或者

```java
@WebServlet(loadOnStarup = -1)
```

## DefaultServlet

当请求的资源与任意一个servlet地址都匹配不上，会使用defaultServlet来处理。

如果是静态资源，会根据路径去寻找，放到响应中。

## Servlet 继承结构

HttpServlet -> GenericServlet -> Servlet

不推荐直接重写service，建议重写doGet/Post……

## ServletConfig

servletConfig 会在GenericServlet中存入Servlet，通过getServletConfig()可获取该config对象

```xml
 <servlet>
        <servlet-name>helloServlet</servlet-name>
        <servlet-class>MyServlet</servlet-class>
        <init-param>
            <param-name>username</param-name>
            <param-value>jack</param-value>
        </init-param>
        <init-param>
            <param-name>password</param-name>
            <param-value>123456</param-value>
        </init-param>
    </servlet>
```

```java
 final String username = getServletConfig().getInitParameter("username");
```

可通过注解配置

```java
@WebServlet(initParams = {@WebInitParam(name = "username", value = "jack"),@WebInitParam(name = "password", value = "123456"),})
```

## ServletContext

为所有的servlet提供公共的信息存储，单例

```xml
<context-param>
    <param-name>master</param-name>
    <param-value>itsme</param-value>
</context-param>
```

```java
final ServletContext servletContext = getServletContext();
final Object master = servletContext.getInitParameter("master");
```

**获取服务运行目录**

获得项目部署位置下某个文件或者路径在服务器上的真实路径

```java
String  path = getServletContext().getRealPath("");
String  path = getServletContext().getRealPath("img");
String  path = getServletContext().getRealPath("img/a.jpg");
```

**获取上下文路径**

```java
String  path = getServletContext().getContextPath();
```

**域对象**

- 三个域
    - 应用域
    - 会话域
    - 请求域
- 相关api
    - setAttribute
    - getAttribute
    - removeAttribute

## HttpServletRequest

- 请求行

    - 获取请求方式：getMethod

    - 获取请求协议：getScheme（无版本号）/getProtocol（带版本号）

    - 获取请求路径：getRequestURI（不带域名）/getRequestURL（带域名）

        URI：统一资源标识符 局部

        URL：统一资源定位符 完整

    - 获取应用端口号：getLocalPort

    - 获取客户端软件端口号：getRemotePort

    - 获取客户端发请求时使用的端口号：getServerPort（代理的时候可能不同）

    - 获取请求路径：getServletPath

- 请求头

    - 单独获取某个请求头：getHeader("Authorization")
    - 获取所有请求头名字：getHeaderNames  
    - 获取请求资源类型：getContentType
    
- 参数

    **Get请求可以有请求体，Post请求可以有param**

    - 获取get请求中的参数：getParmeter("username")

    - 获取一个键多个值，如多选框：getParmeterValues("hobby")

    - 获取所有参数名：getParmeterNames

        通过遍历取值时建议使用取多值的方法，避免遗漏

    - 返回参数Map：Map\<String, String[]\> getParameterMap

- 获取请求体中的非键值参数：getReader

- 获得二进制输入流：getInputStream

## HttpServletResponse

- 响应行

    - 设置状态码：setStatus

    - 设置响应头：setHeader("key","value")

        可设置任意头

    - 设置内容头与内容大小：setContenType, setContentLength

    - 设置响应体

        - 获得Writer：getWriter

            writer.write(str)

            可配合setContentLength(str.getBytes().length)

        - 获得字节输出流：getOutputStream 

## 请求转发

通过HttpServletRequest实现

- 请求和响应对象会转发给下一个成员
- 服务器内部行为，客户端无感，客户端只发送了一次请求，客户端地址栏不会改变
- 服务端只产生一对req-resp

- 可以转发到WEB-INF下，访问受保护资源

- 不可以转发项目外部资源如百度

```java
// 获取转发器，servletB为委托的servlet Path，且没有斜杠开头
RequestDispatcher requestDispatcher = req.getRequestDispathcer("servletB");
// or 转发到视图
RequestDispatcher requestDispatcher = req.getRequestDispathcer("index.html");
// or 转发到WEB-INF下内容
RequestDispatcher requestDispatcher = req.getRequestDispathcer("WEB-INF/index.html");
// 转发请求
requestDispatcher.forward(req, resp)
```

## 响应重定向

通过HttpServletResponset实现

- 客户端重新发送请求，地址栏会变化

- request无法继续传递

- 不可访问WEB-INF
- 可重定向到外部资源
- 页面跳转优先使用重定向方式

```java
// 方法一
resp.setStatus(302);
resp.setHeader("location","servletB");
// 方法二
resp.sendRedirect("servletB");
// or 视图
resp.sendRedirect("index.html")
```

## 乱码

- html乱码

    文件的保存编码与文件中meta设置中的编码不同

- tomcat乱码

    改变conf下的logging配置

- sout乱码

    jvm解析编码与java编译时编码不同

    VMoption：-Dfile.encoding=UTF-8

- GET请求乱码

    form表单请求为GBK，tomcat接收get参数时用utf8解析导致的乱码：

    conf中server.xml，修改 URIEncoding与客户端保持一致

    ```xml
     <Connector port="8080" protocol="HTTP/1.1"
                   connectionTimeout="20000"
                   redirectPort="8443"
                   maxParameterCount="1000"
                   URIEncoding="GBK"
                   />
    ```

- POST请求乱码

    req.setCharacterEncoding("GBK")

    注意要在取数据之前设置

- 响应体乱码

    tomcat默认使用utf-8编码响应体

    响应头中设置setCharacterEncoding用于设置响应的编码格式

    响应头中设置setContent-Type用于告知客户端响应的编码

    建议先setCharacterEncoding再setContent-Type

## 路径

- 前端相对路径

    ./ 与直接写路径为当前目录 ../为上一层

    浏览器根据当前资源所在的URL上计算相对路径，接着发送请求给服务端，前端对文件结构无感 

    **注意：**若使用请求转发到某个页面，当前窗口的路径不变，在解析目标页面中的相对路径时还是会使用当前窗口的路径为基准，这也是为什么要使用重定向来跳转页面 

- 前端绝对路径

    以斜线/开头，会以baseurl作为基准，缺点依赖于项目上下文，项目上下文可更改，变化的时候更改麻烦

    - 可以通过head中的base标签的href属性设置当前页面中的基准，会自动补充到当前页面中没有./或../修饰的相对路径（“img/a.jpg ”）前，若base的href中路径为相对路径（斜线开头），则该种相对路径会变为绝对路径
    - 另一种

- 后端重定向

    重定向会发回前端一个href，客户端根据href的格式（相对路径还是绝对路径），拼接请求并重新发送

- 请求转发

    请求转发返回的页面中的相对路径会以前端发请求的地址为基准

    请求转发不需要添加项目上下文

- 项目上下文解决

    解决办法：不要项目上下文

# MVC模式

将系统分为模型、视图、控制器三部分

- M model 模型层
    - 存放和数据库对象的实体类以及一些用于存储非数据库表完整相关的VO对象
    - 存放一些对数据进行逻辑运算操作的一些业务处理代码
- V view 视图层
    - 存放一些视图文件相关代码 html css js等
    - 在前后端分离的项目中，后端没有试图文件，该层次会演化成独立的前端项目
- C controller 控制层
    - 接收客户端请求，获得请求数据
    - 将准备好的数据响应给客户端

常见的实例结构

- M
    - 实体类包：pojo、entity、bean 存放实体类
    - 数据库访问包：dao、mapper 对数据库进行CRUD
    - 服务包：service 对数据进行业务逻辑运算
- V
    - web目录下的视图资源
    - 前后端分离后的前端项目，后端中不存在该层次
- C
    - 控制层：controller

## 实体类

- 规则
    - 实体类的类名和表格的表格名应该对应
    - 属性名与表格中字段名对应
    - 每个属性都必须是私有的
    - 每个属性都必须具有getter和setter方法
    - 必须具备无参构造器
    - 应该实现序列化接口
    - 应该重写hashcode和equals方法
    - toString方法

## DAO

data access object 数据访问对象

用于定义针对表格的CRUD的方法

一般应该定义接口和实现类

# 会话

- http是无状态协议

    客户端与服务端之间的会话是无状态的（会话之间无关联性,无法识别该用户曾经访问过）

    需要在服务端保存一个凭证，客户端携带凭证来判断客户端的会话

- session将数据存放在服务器端。cookie将数据存放在客户端的浏览器中。

## Cookie

cookie是一种键值对格式的数据，由于保存在客户端，故不建议保存敏感数据

服务端创建cookie，将cookie放入响应对象中，tomcat会将cookie转化为set-cookie响应头，响应给客户端。

客户端会将cookie存放在浏览器中，下次访问该服务的资源时会携带该cookie

Cookie仅在当前浏览器有效，各浏览器之间不共享，关闭整个浏览器就会失效。

```
// 服务器端向浏览器设置cookie
Cookie c1 = new Cookie("k1","v1");
Cookie c2 = new Cookie("k2","v2");
// 设置c2的存活时间
c2.setMqxAge(秒计数)
resp.addCookie(c1);
resp.addCookie(c2);
// 服务器获取请求中携带的cookie
Cookie[] cookies = req.getCookies();
if(null != cookies){
	for(Cookie c: cookies){
		sout(c.getName()+": "+c.getValue());
	}
}
```

- 会话级cookie
    - 服务端没有明确指定cookie存活时间
    - 浏览器端cookie存活在内存中
    - 浏览器关闭之前cookie会一直存活
    - 浏览器关闭后cookie被释放
- 持久化cookie
    - 服务段设置了cookie的存活时间
    - 浏览器端cookie会被存储在硬盘上
    - Cookie存活时间收浏览器设置时间决定

设置cookie的生效范围

```java
// 只在请求/hello的时候携带
c1.setPath("/hello")
```



## Session

用户初次访问服务器，服务器会生成一个Session与相对应的sessionID并将sessionID设到客户端cookie中，在客户端浏览器cookie保存sessionID，客户端发送请求时会携带sessionID，但是由浏览器内的链接、脚本等打开的新窗口会共享父窗口的cookie，也就是会共享一个session。

```java
HttpSession s = req.getSession();
s.setAttribute("k","v");
s.getAttribute("k");
s.removeAttribute("k");
String s = s.getId();
boolean isNew = s.isNew();
```

**时效性**

session存储在服务器的内存中，在用户第一次访问时创建。需要注意只有访问jsp的时候servlet时才会创建，而访问html、image等静态资源并不会创建session。

session可以通过可以调用request.getSession(true)强制创建。服务器会把长时间没有活动的session从服务器内存中清除，此时session失效。tomcat中的session默认失效时间为30分钟，一旦session被访问时计时会清零，或者可以调用sessioin的incalidate方法可以主动清除，若用户在有效期内访问，则Session会续期。

**设置失效时间**

web.xml方式（可在全局或者本项目中设置）:

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

## 浏览器不支持Cookie如何解决

如果客户端浏览器将Cookie功能禁用，或者不支持Cookie怎么办？例如，绝大多数的手机浏览器都不支持Cookie。Java Web提供了另一种解决方案：URL地址重写。

URL地址重写是对客户端不支持Cookie的解决方案。URL地址重写的原理是将该用户Session的id信息重写到URL地址中。服务器能够解析重写后的URL获取Session的id。这样即使客户端不支持Cookie，也可以使用Session来记录用户状态。HttpServletResponse类提供了encodeURL(String url)实现URL地址重写，该方法会自动判断客户端是否支持Cookie。如果客户端支持Cookie，会将URL原封不动地输出来。如果客户端不支持Cookie，则会将用户Session的id重写到URL中。

TOMCAT判断客户端浏览器是否支持Cookie的依据是请求中是否含有Cookie。尽管客户端可能会支持Cookie，但是由于第一次请求时不会携带任何Cookie（因为并无任何Cookie可以携带），URL地址重写后的地址中仍然会带有jsessionid。当第二次访问时服务器已经在浏览器中写入Cookie了，因此URL地址重写后的地址中就不会带有jsessionid了。

# 域对象

setAttribute、getAttribute、removeAttribute

## 请求域对象

信息存储在HttpServletRequest中，有效期在一次请求内，可经由请求转发传递

## 会话域对象

存储在Session中，可跨多请求

## 应用域对象

信息存储在ServletContext中，有效期为在当前应用内，可跨多会话

# 过滤器

在请求时Tomcat在将请求和响应封装为对象之后，在经过servlet之前会先经过过滤器，且在响应时，servlet处理之后，也会经过一次filter。

过滤器可以控制请求是否继续向后端到达目标资源，也可以直接在该方法内进行响应处理。

## helloFilter

```java
/**
 * 需要实现Filter接口
 */
class MyFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        // doBefore 在请求到达目标资源之前的处理
        System.out.println(servletRequest);
        // 放行到目标资源
        filterChain.doFilter(servletRequest,servletResponse);
        // doAfter 请求处理完毕，从目标资源返回到客户端时的处理
        System.out.println(servletResponse);
    }
}
```

```xml
<filter>
    <filter-name>helloFilter</filter-name>
    <filter-class>MyFilter</filter-class>
     <init-param>
         <param-name>username</param-name>
         <param-value>jack</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>helloFilter</filter-name>
    <!--会经过filter的路径-->
    <url-pattern>/*</url-pattern>
    <!--会经过filter的servlet-->
    <servlet-name>helloServlet</servlet-name>
</filter-mapping>
```

## ServletRequestWrapper

可以自定义request的实现，在需要多次读取request的输入流中可以用到

## filter的生命周期

```java
public interface Filter {
    default void init(FilterConfig filterConfig) throws ServletException {
    }

    void doFilter(ServletRequest var1, ServletResponse var2, FilterChain var3) throws IOException, ServletException;

    default void destroy() {
    }
}
```

- 构造

    与初始化两个阶段都是在项目启动时便执行

    执行一次

- 初始化

    执行一次

    可以获取web文件中配置的filter初始化参数

    ```java
    filterConfig.getInitParameter("key")
    ```

- 过滤

    执行多次

- 销毁 

    项目结束时执行

## 注解配置

```java
/**
 * 需要实现Filter接口
 */
@WebFilter(
        filterName = "helloFilter",
        initParams = {@WebInitParam(name = "k",value = "v")},
        urlPatterns = {"/servletA","*.html"},
        servletNames = {"servletB"}
)
// @WebFilter("/servletA") 默认值为过滤路径而不是过滤器名
public class MyFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        // doBefore 在请求到达目标资源之前的处理
        System.out.println(servletRequest);
        // 放行到目标资源
        filterChain.doFilter(servletRequest,servletResponse);
        // doAfter 请求处理完毕，从目标资源返回到客户端时的处理
        System.out.println(servletResponse);

    }
}
```

## 过滤器链

若通过配置文件的方式配置filter，执行的顺序与web.xml中配置的filter-mapping配置的顺序有关系

若通过注解的方式配置filter，执行顺序与Filter的类名有关系

# 监听器

监听域对象的事件

- ServletContext
    - ServletContextListener	ServletContext的创建和销毁
    - ServletContextAttributeListener	ServletContext数据增删改

- Session

    - HttpSessionListener	

        req.getSession时session才会创建 

    - HttpSessionAttributeListener	

    - HttpSessionBindingListener	监听监听器绑定session域

        将当前listener放入某个session域中为绑定，移除为解绑

        可getSession获取session对象

    - HttpSessionActivationListener	session 钝化/活化 序列化与反序列化

        需要先绑定

- Request

    - ServletRequestListener	
    - ServletRequesAttributeListener	

## helloListener

```java
/**
 * @author boranget
 * @date 2023/11/9
 */
public class MyApplicationListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        final ServletContext servletContext = sce.getServletContext();
        System.out.println("应用域初始化了");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce);
        final ServletContext servletContext = sce.getServletContext();
        System.out.println("应用域被销毁了");
    }
}
```

```xml
<listener>
    <listener-class>MyApplicationListener</listener-class>
</listener>
```

## 注解配置方式

```java
/**
 * @author boranget
 * @date 2023/11/9
 */
@WebListener
public class MyApplicationListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        final ServletContext servletContext = sce.getServletContext();
        System.out.println("应用域初始化了");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce);
        final ServletContext servletContext = sce.getServletContext();
        System.out.println("应用域被销毁了");
    }
}
```

## 属性监听器

```java
/**
 * @author boranget
 * @date 2023/11/9
 */
@WebListener
public class MyApplicationListener implements ServletContextAttributeListener {
    @Override
    public void attributeAdded(ServletContextAttributeEvent scae) {
        // 新增的属性名
        scae.getName();
        // 新增的属性值
        scae.getValue();
        scae.getServletContext();
    }

    @Override
    public void attributeRemoved(ServletContextAttributeEvent scae) {
        ServletContextAttributeListener.super.attributeRemoved(scae);
    }

    @Override
    public void attributeReplaced(ServletContextAttributeEvent scae) {
        scae.getValue(); // 旧值
        scae.getNewValue(); // 新值
        ServletContextAttributeListener.super.attributeReplaced(scae);
    }
}
```

# Cookie设置与携带策略

## 设置

- 访问子域，设置子域、父域、兄弟域的cookie
    - 当前域与父域可设置，兄弟域不可
- 访问父域，设置子域、父域、兄弟域的cookie
    - 只能设置父域

## 携带

- 访问子域不会携带父域cookie

- 访问父域不会携带子域cookie