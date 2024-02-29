---
title: Milvus安装
date: 2023-10-25 10:35:19
updated: 2023-10-27 16:50:30
tags:
  - Milvus
categories:
  - experience
---

# 参考资料

[Install Milvus Standalone with Docker Compose (CPU) Milvus documentation](https://milvus.io/docs/install_standalone-docker.md)

[安装环境需求](https://milvus.io/docs/prerequisite-docker.md)

[Docker: Error response from daemon: Ports are not available 端口没被占用，却显示被占用-CSDN博客](https://blog.csdn.net/u012558210/article/details/127999746)

[milvus 官网](https://milvus.io/)


# 前置条件

已安装Docker桌面版（windows系统）

# 下载docker配置文件

https://github.com/milvus-io/milvus/releases/download/v2.3.1/milvus-standalone-docker-compose.yml

下载该文件并将该文件重命名为‘“docker-compose.yml”

# 执行

在该文件的存储目录执行

```cmd
docker-compose up -d
```

## 错误

**提示**

```
Error response from daemon: Ports are not available: exposing port TCP 0.0.0.0:9000 -> 0.0.0.0:0: listen tcp 0.0.0.0:9000: bind: An attempt was made to access a socket in a way forbidden by its access permissions.
```

**解决**

重启nat网络

```shell
net stop winnat
net start winnat
```

接着重新运行docker

# 映射端口

映射milvus-standalone服务端口到19530，用于其他程序调用

```
 docker port milvus-standalone 19530/tcp
```



