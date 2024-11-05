---
title: nginx
date: 2022-11-09 16:50:30
updated: 2024-01-23 10:35:19
tags:
  - nginx
categories:
  - notes
---

# 基本概念

## 反向代理

对客户端隐藏服务器的真实位置，与正向代理（vpn）相反

## 负载均衡

轮询，加权轮询，iphash

## 动静分离

动态页面与静态页面交给不同的服务器解析

# 默认的配置文件

```nginx
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}
```

## 整体的配置

```nginx
...              #全局块

events {         #events块
   ...
}

http      #http块
{
    ...   #http全局块
    server        #server块
    { 
        ...       #server全局块
        location [PATTERN]   #location块
        {
            ...
        }
        location [PATTERN] 
        {
            ...
        }
    }
    server
    {
      ...
    }
    ...     #http全局块
}
```

## 配置含义

1. 全局块

   不会被{}包裹，全局块篇配置影响nginx全局的指令。一般有：运行nginx服务器的用户组、 nginx进程pid存放路径、日志存放路径、配置文件引入、允许生成worker process数等

2. events块

   配置影响nginx服务器或与用户的网络连接。 比如：

   - 每个进程的最大连接数
   - 选取哪种事件驱动模型处理连接请求
   - 是否允许同时接受多个网络连接
   - 开启多个网络连接序列化

3. http块

   可以嵌套多个server, 配置代理, 缓存, 日志定义等绝大多数功能和第三方模块的配置, 如文件引入, mime-type定义, 日志自定义, 是否使用sendfile传输文件, 连接超时时间,但链接请求数等.

   - server块

       配置虚拟主机的相关参数, 一个http块中可以有多个server

       - location块

           配置请求的路由, 以及各种页面的处理情况

```nginx
...
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    ...

    server {
        ...

        location {
            ...
        }
    }

    server {
        ...
    }
}
```



## 一个示例配置文件

```nginx
########### 每个指令必须有分号结束。#################
#user administrator administrators;  #配置用户或者组，默认为nobody nobody。
#worker_processes 2;  #允许生成的进程数，默认为1
#pid /nginx/pid/nginx.pid;   #指定nginx进程运行文件存放地址
error_log log/error.log debug;  #制定日志路径，级别。这个设置可以放入全局块，http块，server块，级别以此为：debug|info|notice|warn|error|crit|alert|emerg
events {
    accept_mutex on;   #设置网路连接序列化，防止惊群现象发生，默认为on
    multi_accept on;  #设置一个进程是否同时接受多个网络连接，默认为off
    #use epoll;      #事件驱动模型，select|poll|kqueue|epoll|resig|/dev/poll|eventport
    worker_connections  1024;    #最大连接数，默认为512
}
http {
    include       mime.types;   #文件扩展名与文件类型映射表
    default_type  application/octet-stream; #默认文件类型，默认为text/plain
    #access_log off; #取消服务日志    
    log_format myFormat '$remote_addr–$remote_user [$time_local] $request $status $body_bytes_sent $http_referer $http_user_agent $http_x_forwarded_for'; #自定义格式
    access_log log/access.log myFormat;  #combined为日志格式的默认值
    sendfile on;   #允许sendfile方式传输文件，默认为off，可以在http块，server块，location块。
    sendfile_max_chunk 100k;  #每个进程每次调用传输数量不能大于设定的值，默认为0，即不设上限。
    keepalive_timeout 65;  #连接超时时间，默认为75s，可以在http，server，location块。

    upstream mysvr {   
      server 127.0.0.1:7878;
      server 192.168.10.121:3333 backup;  #热备
    }
    error_page 404 https://www.baidu.com; #错误页
    server {
        keepalive_requests 120; #单连接请求上限次数。
        listen       4545;   #监听端口
        server_name  127.0.0.1;   #监听地址       
        location  ~*^.+$ {       #请求的url过滤，正则匹配，~为区分大小写，~*为不区分大小写。
           #root path;  #根目录
           #index vv.txt;  #设置默认页
           proxy_pass  http://mysvr;  #请求转向mysvr 定义的服务器列表
           deny 127.0.0.1;  #拒绝的ip
           allow 172.18.5.54; #允许的ip           
        } 
    }
}
```

# location规则

```nginx
location [= | ~ | ~* | ^~] uri {
    .............
}
```

= : 用于不含正则表达式的uri前,要求请求字符串与uri严格匹配

# 代理转发

```nginx
server{
	// 监听的端口
    listen 80;
    location /{
    // .........代理配置
    }
}
```



![image-20221108171421986](nginx/image-20221108171421986.png)

两种配置区别:

```nginx
upstream my_server{
	server 10.0.0.2:8080;
	keepalive 2000;
}
server{
	listen 80;
	server_name 10.0.0.1;
	client_max_body_size 1024M;
	
	location /my/ {
		proxy_pass http://10.0.0.2:8080/;
	}
}
# 与
server{
	listen 80;
	server_name 10.0.0.1;
	client_max_body_size 1024M;
	
	location /my/ {
		proxy_pass http://10.0.0.2:8080;
	}
}
```


前者会转发到 http://10.0.0.2:8080

后者会转发到 http://10.0.0.2:8080/my

也就是说,如果转发到的地址末尾不带/斜杠的话，转发时会带上过滤路径一起转发，而如果转发地址带/斜杠，则会去掉过滤地址转发。

# 负载均衡

```nginx
upstream mysvr { 
    server 192.168.10.121:3333;
    server 192.168.10.122:3333;
}
server {
    ....
    location  ~*^.+$ {         
        proxy_pass  http://mysvr;  #请求转向mysvr 定义的服务器列表         
    }
}
```

1. 热备份

   AAAAAAA挂了BBBBBBBB............

   ```nginx
   upstream mysvr { 
       server 127.0.0.1:7878; 
       server 192.168.10.121:3333 backup;  #热备     
   }
   ```

2. 轮询

   ABABABABAB...............

   ```nginx
   upstream mysvr { 
       server 127.0.0.1:7878;
       server 192.168.10.121:3333;       
   }
   ```

3. 加权轮询

   ABBABBABB.............

   ```nginx
   upstream mysvr { 
       server 127.0.0.1:7878 weight=1;
       server 192.168.10.121:3333 weight=2;
   }
   ```

4. iphash

   ```nginx
   upstream mysvr { 
       server 127.0.0.1:7878; 
       server 192.168.10.121:3333;
       ip_hash;
   }
   ```

**其他配置**

- down，表示当前的server暂时不参与负载均衡。
- backup，预留的备份机器。当其他所有的非backup机器出现故障或者忙的时候，才会请求backup机器，因此这台机器的压力最轻。
- max_fails，允许请求失败的次数，默认为1。当超过最大次数时，返回proxy_next_upstream 模块定义的错误。
- fail_timeout，在经历了max_fails次失败后，暂停服务的时间。max_fails可以和fail_timeout一起使用。

```nginx
upstream mysvr { 
    server 127.0.0.1:7878 weight=2 max_fails=2 fail_timeout=2;
    server 192.168.10.121:3333 weight=1 max_fails=2 fail_timeout=1;    
}
```

# SNI导致的握手失败问题

原先配置

```nginx
location / {
    # root   /usr/share/nginx/html;
    # index  index.html index.htm;
    proxy_pass https://wwwcie.ups.com/security/v1/oauth/token;
    # proxy_ssl_server_name on;
    # proxy_ssl_session_reuse off;
}
```

报错：

> 2023/12/11 05:49:02 [error] 23#23: *2 SSL_do_handshake() failed (SSL: error:0A000438:SSL routines::tlsv1 alert internal error:SSL alert number 80) while SSL handshaking to upstream, client: 172.17.0.1, server: localhost, request: "GET / HTTP/1.1", upstream: "https://104.109.129.184:443/security/v1/oauth/token", host: "localhost"
> 2023/12/11 05:49:02 [warn] 23#23: *2 upstream server temporarily disabled while SSL handshaking to upstream, client: 172.17.0.1, server: localhost, request: "GET / HTTP/1.1", upstream: "https://104.109.129.184:443/security/v1/oauth/token", host: "localhost"

开启SNI后解决

```nginx
location / {
    # root   /usr/share/nginx/html;
    # index  index.html index.htm;
    proxy_pass https://wwwcie.ups.com/security/v1/oauth/token;
    proxy_ssl_server_name on;
    # proxy_ssl_session_reuse off;
}
```

**SNI：Server Name Indication**是 TLS 的扩展，允许在握手过程开始时通过客户端告诉它正在连接的服务器的主机名称。作用：用来解决一个服务器拥有多个域名的情况。

# 后端已处理跨域后nginx再处理跨域出错

背景：后端设置了croswebfilter，nginx反向代理了后端，使得前端在访问后端时使用同源的域，同时也设置了跨域头的添加

情况：浏览器前端请求nginx代理的后端的时候报错，postman请求nginx代理的后端不报错

原因：后端通过header中是否有origin头来判断当前请求是否为跨域请求，如果当前请求为跨域请求，则会在响应头中添加允许跨域的头。而nginx的配置会在所有请求的响应头中添加跨域头，这样会造成冲突

解决：去掉后端的跨域处理

postman不报错的原因：postman没有同源限制，所以不会在请求中添加origin，故后端不会对该请求的响应头做处理

# proxy_set_header和add_header的区别

![img](nginx/20190709170853778.png)

proxy_set_header是nginx设置请求头给上游服务器，add_header是nginx设置响应头信息给浏览器。

 假如nginx请求上游服务器时，添加额外的请求头，就需要使用proxy_set_header。在java中使用HttpServletRequest.getHeader(String name)来获取请求头的值，name是请求头的名称。

```yaml
语法格式：
proxy_set_header field value;
value值可以是包含文本、变量或者它们的组合。
常见的设置如：
proxy_set_header Host $proxy_host;
proxy_set_header version 1.0;
```

nginx响应数据时，要告诉浏览器一些头信息，就要使用add_header。例如跨域访问

```yaml
add_header 'Access-Control-Allow-Origin' '*';
add_header 'Access-Control-Allow-Headers' 'X-Requested-With';
add_header 'Access-Control-Allow-Methods' 'GET,POST,OPTIONS'
# 由于跨域请求，浏览器会先发送一个OPTIONS的预检请求，我们可以缓存第一次的预检请求的失效时间
if ($request_method = 'OPTIONS') {
	add_header 'Access-Control-Max-Age' 2592000;
	add_header 'Content-Type' 'text/plain; charset=utf-8';
	add_header 'Content-Length' 0;
	return 204;
}
```

# nginx代理后端

conf.d下文件：

```nginx
error_log  /etc/nginx/log/error_log debug;
server {
        listen       80;
        server_name  39.*.*.92;
    	# 保温大小
        client_max_body_size 100M;
        location / {
        		# 处理当前类型请求时寻找文件的根目录
                root   /etc/nginx/html/dist;
        		# 直接请求当前路径时寻找的页面
                index  sign-in.html;
        		# 若无法直接找到当前请求路径时，按顺序查找如下页面，如果都找不到则404
                try_files $uri $uri.html $uri/ =404;
        }
        # 反向代理后端，将后端变为与前端同个域，将无同源问题
        location /ci/ {
                proxy_pass http://127.0.0.1:9000/;
        }

        error_page   500 502 503 504  /50x.html;

}
```

# try_files

参数`$uri`为当前请求的路径，try_files后跟的参数为从前向后匹配，若都匹配不到则直接请求最后一个参数，最后一个参数可以是真实存在的文件，也可以是等号+状态码，比如=404

```nginx
try_files $uri $uri.html $uri/ =404;
try_files $uri $uri.html $uri/ 404.html;
```

# 缓冲区大小

get 请求下载文件时，net::ERR_INCOMPLETE_CHUNKED_ENCODING 200 (OK)

>- `nginx`配置缓冲区设置过小；
>- `nginx`的临时目录（`/proxy_temp`）没有权限写入缓存文件；