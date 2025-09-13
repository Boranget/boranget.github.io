---
title: 使用Filter更改请求目标地址
date: 2023-10-20 16:35:19
updated: 2023-10-20 10:35:19
tags:
  - Filter
categories:
  - 经验
---

# 缺点

缺点在于，继续执行filter中的其他filter和转发请求（修改目标地址）只能实现一个，转发之后就算后面继续写了执行过滤器链，也会先执行完请求之后再回来执行。所以建议转发Filter放到最后一个Filter。

# 实现

```java
package com.example.springweb;
import org.springframework.stereotype.Component;
import javax.servlet.*;
import java.io.IOException;

/**
 * @author boranget
 * @date 2023/10/20
 * 注册为Bean的filter将会用于所有请求
 */
@Component
public class AbstractFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        // 直接转发到/hello
        servletRequest.getRequestDispatcher("/hello").forward(servletRequest, servletResponse);
        // 执行完请求再执行下面的代码
        // filterChain.doFilter(servletRequest,servletResponse);
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}

```

