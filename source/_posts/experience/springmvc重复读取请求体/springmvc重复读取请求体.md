---
title: springmvc重复读取请求体
date: 2023-10-20 15:35:19
tags:
  - spring mvc
categories:
  - 经验
---

# 参考资料

[【精选】【Spring MVC 系列】Spring MVC 中 Filter 配置的 6 种方式，看看你了解哪些_springmvc filter_大鹏cool的博客-CSDN博客](https://blog.csdn.net/zzuhkp/article/details/121288762)

[重复读取 HttpServletRequest 中 InputStream 的方法_httpservletrequest 读取inputstream-CSDN博客](https://blog.csdn.net/qq_35246620/article/details/107387531)

[拦截器拦截requestbody数据如何防止流被读取后数据丢失_防止流读取一次后就没有了-CSDN博客](https://blog.csdn.net/qq_22585453/article/details/84387323)

# 需求

某项目需求：通过请求体中某个参数确定后续步骤，但Spring MVC默认请求只能读取一次，filter中读过一次请求体后后续Controller中注入参数会出现问题。

# 实现

## Wrapper

在过滤过程中可以当request使用

```java
package com.example.springweb;

import org.springframework.util.StreamUtils;

import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.Charset;

/**
 * @author boranget
 * @date 2023/10/20
 */
public class SafeHttpServletRequestWrapper extends HttpServletRequestWrapper {
    // 保存请求体到字符串时使用的字符集
    private static final String CHARSET_UTF8 = "UTF-8";
    // 保存请求体
    private final byte[] body;
    // 保存请求体的字符串
    private String bodyString;

    /**
     * 构造方法
     * 传入输入流后，将内容读出来并保存
     * @param request
     * @throws IOException
     */
    public SafeHttpServletRequestWrapper(HttpServletRequest request) throws IOException {
        super(request);
        this.bodyString = StreamUtils.copyToString(request.getInputStream(), Charset.forName(CHARSET_UTF8));
        body = bodyString.getBytes(CHARSET_UTF8);
    }

    /**
     * 获取请求体（中间过程使用）
     * @return
     */
    public String getBodyString() {
        return this.bodyString;
    }

    /**
     * 获取reader（中间过程使用）
     * @return
     * @throws IOException
     */
    @Override
    public BufferedReader getReader() throws IOException {
        return new BufferedReader(new InputStreamReader(getInputStream()));
    }

    /**
     * 获取输入流（后续步骤使用）
     * 这一个增强就是因为输入流已经被消耗了，但我们要个让接下来的处理可以读到东西
     * @return
     * @throws IOException
     */
    @Override
    public ServletInputStream getInputStream() throws IOException {

        final ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(body);

        return new ServletInputStream() {

            @Override
            public boolean isFinished() {
                return false;
            }

            @Override
            public boolean isReady() {
                return false;
            }

            @Override
            public void setReadListener(ReadListener readListener) {

            }

            @Override
            public int read() throws IOException {
                return byteArrayInputStream.read();
            }
        };
    }
}

```

## Filter

```java
package com.example.springweb;

import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * @author boranget
 * @date 2023/10/20
 * 注册为Bean的filter将会用于所有请求
 */
@Component
public class AbstractFilter  implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        try {
            // 存入wrapper
            SafeHttpServletRequestWrapper requestWrapper = new SafeHttpServletRequestWrapper((HttpServletRequest) servletRequest);
            // 当前过程从wrapper中读取
            System.out.println(requestWrapper.getBodyString());
            // 后续过程使用wrapper
            filterChain.doFilter(requestWrapper, servletResponse);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}

```

