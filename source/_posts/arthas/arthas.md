---
title: arthas
date: 2024-01-31 10:35:19
updated: 2024-01-31 10:35:19
tags:
  - arthas
categories:
  - notes
---

# 介绍

用于监控运行时的java进程，且无需对java进程进行配置

# 官网

[快速入门 | arthas (aliyun.com)](https://arthas.aliyun.com/doc/quick-start.html)

# 使用

运行arthas时，会输出jps信息，输入序号选择对应的java进程进行跟踪

# 命令

[命令列表 | arthas (aliyun.com)](https://arthas.aliyun.com/doc/commands.html)

- dashboard 查看数据面板
- jad 反编译类
- monitor 监控方法的调用
- watch 监控方法的返回值与入参等

# 启动

官网下载jar包后，在待监控服务机器上使用java -jar命令执行该jar包

启动后会输出一个当前机器上的java进程列表，选择对应的（要监控的java进程）进行监控

# Watch

注意结束后要执行stop命令

## 监控某方法的入参与出参

使用`watch`命令，比如要查看如下方法

```java
package com.boranget.controller;

@RestController
public class HelloController {
    @Autowired
    private HelloService helloService;
   
    @RequestMapping("/getMsg")
    public String getMsg(@RequestBody String body){
        String res = helloService.getMsg(body);
        return res;
    }
}

```

则可以在进入arthas后执行：

```
watch com.boranget.controller.HelloController getMsg -x 4
```

其中`-x 4`表示要对对象进行最多深度为4层的查看，输出如下：

```
method=com.boranget.controller.HelloController.getMsg location=AtExit
ts=2024-08-01 13:26:23; [cost=0.556119ms] result=@ArrayList[
    @Object[][
        @String[{\r\n    "header":["1"],\r\n    "msg":"hi"\r\n}],
    ],
    @HelloController[
        helloService=@HelloService[
        ],
    ],
    @String[hi],
]
```

# tt

tt可以记录一段时间内指定方法的执行情况，需要注意的是，tt底层是将记录使用一个map存储在了jvm中，且停止arthas后不会自动释放这块内存，所以需要手动删除

## 开始记录


`tt -t com.boranget.controller.HelloController caculate`

若方法执行太频繁，可通过 -n限制记录次数

[arthas@15199]$ tt -t com.boranget.controller.HelloController caculate                                      Press Q or Ctrl+C to abort.                                                                                 Affect(class count: 1 , method count: 1) cost in 182 ms, listenerId: 1                                       INDEX  TIMESTAMP       COST(ms  IS-RE  IS-E  OBJECT       CLASS                    METHOD                                          )        T      XP                                                                  ------------------------------------------------------------------------------------------------------------ 1000   2024-08-01 16:  2.68198  true   fals  0x4e3ac0a4   HelloController          caculate                        52:36           9               e                                                                    1001   2024-08-01 16:  0.27205  true   fals  0x4e3ac0a4   HelloController          caculate                        52:42           5               e                                                                    1002   2024-08-01 16:  0.14023  true   fals  0x4e3ac0a4   HelloController          caculate                        52:46           3               e                                                                    1003   2024-08-01 16:  0.18027  true   fals  0x4e3ac0a4   HelloController          caculate                        52:49           5               e                                                                    1004   2024-08-01 16:  0.03644  true   fals  0x4e3ac0a4   HelloController          caculate                        53:03           3               e                                                                    1005   2024-08-01 16:  0.20714  true   fals  0x4e3ac0a4   HelloController          caculate                        53:18           4               e                                                         

## 查看记录

使用ctrl+c或者次数够了停止后，可通过`tt -l`查看记录结果

通过`tt -i index`查看某条记录的详细情况，其中index为表中开头的索引

## 重新执行

`tt -i index -p `重新执行某条记录的方法，并且可使用当时的参数进行执行

注意如果对数据库有操作，自然也会影响数据库（比如某字段自增操作）

## 清除所有tt

```
tt --delete-all
```

