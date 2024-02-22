---
title: gateway
date: 2023-02-01 16:50:30
tags:
  - 微服务
categories:
  - 笔记
---

# StripPrefix优先级

自定义的全局过滤器（实现GlobalFilter接口）优先级再高，也会在StripPrefix之后执行，所以到达全局过滤器时的路径已经是被截取之后的

# 网关组成

## 路由转发

接受外界请求，通过网关的路由转发，转发到后端的服务器上

## 过滤器

容错，限流等

# 解决方案

## zuul

Netflix 不更新了

## gateway

spring自己推出

# 名词解释

## Route

路由，gateway核心，route包含路由规则，路由校验，过滤处理，容错处理

## Predicate

谓词， 路由规则，简单的校验逻辑

## Filter

过滤器，增加自定义功能



> 其中，predicate 与 filter 的区别主要在于，predicate 作用为判断那些请求为当前路由要处理的请求，filter 为对当前处理的请求所做的处理

# 配置

## 基础配置

```yml
 spring:
  cloud:
   gateway:
   	discovery:
        locator: # 配置处理机制
          # 只要请求地址符合规则: http://gatewayIP:gatewayPort/微服务名称/微服务请求地址
          # 网关会自动映射,将该请求转发为: http://微服务名称/微服务请求地址
          # for example
          # 请求地址: http://localhost:8080/auth/getUsernames
          # 转发成为: http://auth/getUsernames
          # 并且自带负载均衡
          # 商业开发中,enabled一般不设置,使用默认值false,避免不必要的自动转发
          enabled: true #开启网关自动映射处理逻辑
          lower-case-service-id: true #使用小写服务名，默认是大写
```

## 路由配置

```yml
spring:
    cloud:
        gateway:
          # 配置网关中的完整路由,包括命名,地址,谓词集合(规则),过滤器集合
          # routes 这是一个集合,每一个短杠代表一个对象
          #  - id: auth-ver 路由定义的命名,唯一即可,命名规则符合java中变量命名规则
          #    uri: lb://auth-server 当前路由定义的微服务转发地址,lb 代表 load balance
          #    谓词, 命名规则:
          #    是GateWayPredicate接口实现的命名前缀 XXXRoutePredicateFactory
          #    predicates:
          #      - name: 谓词名
          #        args: 参数
          #      或者
          #		 这里正常需求必须写/**, 否则就是固定匹配/api
          #      - Path=/api/** 谓词名=参数
          #    过滤器,命名规则
          #    GatewayFilter接口命名前缀: XXXGatewayFilterFactory
          #    filters:
          #      - name: 过滤器名
          #        args: 参数
          #      或者
          #      StripPrefix为过滤转发地址前缀, =1 为过滤 1节
          #      比如 请求地址 http://localhost:8080/api/getArgs
          #      对应谓词 /api
          #      对应uri为lb://auth-server
          #      则转发地址为 http://auth-server/api/getArgs
          #      通过过滤器,删掉一节
          #      转发地址变为 http://auth-server/getArgs
          #      - StripPrefix=1  过滤器名=参数
          #  ...
          routes: #配置路由路径
            - id: ams2-auth-route
              uri: lb://ams2-auth
              predicates:
                - Path=/auth/**
              filters:
                - StripPrefix=1
            - id: ams2-iam-route
              uri: lb://ams2-iam
              predicates:
                - Path=/iam/**
              filters:
                - StripPrefix=1
            - id: ams2-job-route
              uri: lb://ams2-job
              predicates:
                - Path=/job/**
              filters:
                - StripPrefix=1
```



# 详解

Spring系列配置文件中, 可以直接使用字符串赋值的类型

8中基本类型, 包装类型, string, uri, class, resource 资源文件位置 classpath:

## 谓词 Predicate

name为配置项

args为配置项中的属性设置

### Path

```yml
predicates:
	- Path=/api/**,/abc/**
	# or
	- name: Path
	  args:
	  	patterns=/a/**,/b/**
```

### Header

验证请求头中是否有数据符合需求, 若不配正则, 则查看是否有该请求头

```yml
predicates:
	- name: Header
	  args:
	  	header=my
	  	regexp=hello.* 
```

### Query

验证请求参数中是否有数据符合需求, 若不配正则, 则查看是否有该参数

不判断请求体中的参数, 只判断路径中的参数

```yml
predicates:
	- name: Query
	  args:
	  	param=my
	  	regexp=hello.* 
    
```

### Method

检查请求方式

```yml
predicates:
	- name: Method
	  args:
	 	methods=GET,POST
    # or
    - Method=GET,POST
```

### Remote

客户端ip地址

```yml
predicates:
	- name: Remote
	  args:
	  	sources=192.168.0.1,192.168.0.2
	# or
	- Remote=192.168.0.1,192.168.*
```

### Cookie

```yml
predicates:
	- name: Cookie
	  args:
	  	name=my
	  	regexp=hello.* 
```

### Between,Before,After

请求时间范围

```yml
predicates:
	- Between=2020-01-31T18:00:00.000+08:00[Asia/Shanghai],2020-02-31T18:00:00.000+08:00[Asia/Shanghai]
	- Before=2020-01-31T18:00:00.000+08:00[Asia/Shanghai]
	- After=2020-02-31T18:00:00.000+08:00[Asia/Shanghai]
```

### Host

校验请求头中的Host

### Weight

负载均衡，权重配置, 多版本发布偶尔使用

group为分组名,同一分租为同一功能

2,8为其权重

```yml
  - id: ams2-auth-route
	uri: lb://ams2-auth
	predicates:
		- Weight=group,2
  - id: ams2-iam-route
	uri: lb://ams2-iam
	predicates:
		- Weight=group,8

```

## 过滤器 Filter

### StringPrefix

去除前缀

```yml
filters:
 - StripPrefix=1
```



### AddRequestHeader

添加请求头

```yml
filters:
 - AddRequestHeader=k,v
 # or
 - name:AddRequestHeader
   args:
   	name:k
   	value:v
```

### AddRequestParameter

添加请求参数

### AddResponseHeader

增加响应头参数

### DedupeResponseHeader

对指定响应头去重

### CircuitBreaker

实现熔断使用,支持CircuitBreaker和Hystrix

### FallbackHeaders

可添加降级时的异常信息

### PrefixPath

匹配所有前缀满足条件的URI

### RequestRateLimiter

限流过滤器

### RedirectTo

重定向

### RemoveRequestHeader

删除请求头参数

### RemoveResponseHeader

删除响应头参数

### RewritePath

重写请求路径

### RewriteResponseHeader

有同名覆盖,无同名增加响应头

### SaveSession

Security与Session整合使用

### SecureHeaders

具有权限验证时,建议的头信息内容

### SetPath

功能和StripPrefix接近,语法更接近restful

### SetRequestHeader

替换,没有就忽略

### SetResponseHeader

替换

### SetStatus

设置响应码

### Retry

重试

### RequestSize

请求最大大小

### ModifyRequestBody

修改请求体内容

### ModifyResponseBody

修改响应体



# 使用gateway限流

**RequestRateLimiter**: 限流过滤器

## 常见限流算法

### 计数器

以每秒查询率限制

以第一个请求开始,每个请求让计数器加一,当达到100后,其他的请求都被拒绝

如果一秒钟内前200ms请求数量已经达到了100,那么后面800ms中的假如500次请求都被拒绝,这种情况被称为突刺

### 漏桶算法

解决一个就暴露出一个位置

极端情况:桶满了

### 令牌桶算法

令牌工厂: 稳定生产令牌

假设每秒生成一个令牌,一个令牌用于绑定一个客户端

令牌不断生成,直到达到上限

请求一过来, 就分配令牌

请求上限取决于令牌桶中现有的令牌数量

## redis

```yml
- name: RequestRateLimiter
  args:
    keyResolver: '#{@myKeyResolver}'
    redis-rate-limiter.replenishRate: 1
    redis-rate-limiter.burstCapacity: 1
```

# 使用gateway降级

```yml
- name: Hystrix
  args:
  	name: fallbackcmd # 名字分组
    fallbackUri: forward:/downgrade #远程服务错误时,gateway工程中的哪一个控制器逻辑返回降级结果
```

# 全局过滤器

无需在配置文件中开启, 默认所有路由都生效

```java
@Component
public class AuthGlobalFilter implements GlobalFilter, Ordered {

    private static Logger LOGGER = LoggerFactory.getLogger(AuthGlobalFilter.class);

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        // 前置过滤
        Date begin = new Date();
        System.out.println("全局过滤器执行,当前时刻:"+begin.getTime());
        // 执行主逻辑
        Mono<Void> result = chain.filter(exchange);
        // 后置过滤
        Date end = new Date();
        System.out.println("全局过滤器执行,当前时刻:"+end.getTime()
                          +"本次执行用时"+(end.getTime()-begin.getTime()));
        return result;
    }

    @Override
    public int getOrder() {
        return 0;
    }
}
```

# 自定义路由过滤器

需要在路由中单独配置

```java

@Component
public class RequestPathGatewayFilterFactory
extends AbstractGatewayFilterFactory<RequestPathGatewayFilterFactory.Config> {
    public RequestPathGatewayFilterFactory() {
        super(Config.class);
    }

    // 简化配置方案
    @Override
    public List<String> shortcutFieldOrder() {
        return Arrays.asList("name","path");
    }

    // 过滤逻辑
    @Override
    public GatewayFilter apply(RequestPathGatewayFilterFactory.Config config) {
        return new GatewayFilter() {
            @Override
            public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
                String s = exchange.getRequest().getPath().toString();
                System.out.println("本次请求地址:"+s);
                System.out.println("配置参数是: name:"+config.getName());
                System.out.println("配置参数是: path:"+config.getPath());
                return chain.filter(exchange);
            }
        };
    }
    // 当前过滤器的配置信息
    // 这里必须是静态内部类
    public static class Config{
        private String name;
        private String path;

        public String getName() {
            return name;
        }

        public Config setName(String name) {
            this.name = name;
            return this;
        }

        public String getPath() {
            return path;
        }

        public void setPath(String path) {
            this.path = path;
        }
    }
}
```

