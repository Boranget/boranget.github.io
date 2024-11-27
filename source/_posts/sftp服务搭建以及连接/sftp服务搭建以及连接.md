---
title: sftp服务搭建以及连接
date: 2024-10-11 10:35:19
updated: 2024-10-11 10:35:19
tags:
  - sftp
categories:
  - experience
---

# 参考资料

[SFTP服务器的搭建与使用_sftp服务器搭建-CSDN博客](https://blog.csdn.net/qq_35623011/article/details/85003109)

[SFTP搭建@windows using freeSHHd&FileZilla - 零一两二三 - 博客园 (cnblogs.com)](https://www.cnblogs.com/wzs2016/p/6394990.html#:~:text=重点讲一下认证吧， freesshd支持两种方式的认证，password和public key，你可以使用其中的任意一种，也可以要求客户端同时进行两种认证，也就是说，如果两个都设置为required，客户端要想连入服务器，得同时要有密码和public key。,都设为allowed，任意一种认证都可以进入服务器。 第一种认证简单，只要在客户端输入用户名和密码就可以，第二种就需要一对密钥了（公钥和私钥，私钥客户端持有，公钥要放到服务器上，图中的public key folder就是存放各个客户端私钥对应的公钥的）.)

# 搭建sftp服务

下载freeSSHd安装，另一款常用的ftp工具filezilla的服务端并不提供sftp的功能（只有ftp和ftps）。

## 安装

1. 双击安装包后正常安装即可

2. 创建私钥：安装的最后会引导创建私钥
3. 设置为系统服务

## 配置

- 启动时会连接官网，但是官网已经挂了，所以直接ok
- 可以点击ssh标签页修改端口等信息
- 选择用户标签页新增用户，可选择密码模式、公钥模式

## 连接

如果连接时失败可尝试使用管理员权限重新启动服务应用

## sftp的认证方式

### 密码模式

给用户设置密码即可

### 公钥模式

生成一对公私钥，可使用xftp自带的工具生成，或者使用ssh-keygen。需要生成为ssh-rsa格式的密钥对，私钥客户端连接时使用，公钥存储在服务端authentication中的public key folder，**注意公钥命名必须与该公钥对应的用户名相同且无后缀。**

对于较新的sftp服务器，对安全要求比较高的，可能会需要生成比如rsa-sha2-256的密钥，可用如下方式生成：

```
 ssh-keygen -t rsa-sha2-256 -b 2048
```

# JSCH0.2.*连接Freesshd

[jenkins配置ssh的时候测试连接出现Algorithm negotiation fail_com.jcraft.jsch.jschalgonegofailexception: algorit-CSDN博客](https://blog.csdn.net/t0404/article/details/136206576)

jsch的版本从0.1.x升级到0.2.x的时候，禁用了ssh-rsa,ssh-dss算法，需要进行如下配置

```java
JSch.setConfig("server_host_key", JSch.getConfig("server_host_key") + ",ssh-rsa,ssh-dss");
            JSch.setConfig("PubkeyAcceptedAlgorithms", JSch.getConfig("PubkeyAcceptedAlgorithms") + ",ssh-rsa,ssh-dss");
```

# 私钥文件转换

`-----BEGIN RSA PRIVATE KEY-----`和`-----BEGIN PRIVATE KEY-----`的转换

执行

```
ssh-keygen -p -m PEM -f /path/to/your/rsa_private_key
```

如果提示权限过高，可将权限修改为600，如果修改权限无效，可能是在挂载盘上进行了修改，将其移入本地目录进行权限修改。

`-----BEGIN RSA PRIVATE KEY-----`到ssh key 的转换，这里需要用到puttygen，使用puttygen导入rsa 的私钥，接着导出openssh的私钥

![image-20241015164813651](sftp服务搭建以及连接/image-20241015164813651.png)

# 从私钥导出公钥

注意每次修改私钥格式后都要重新生成对应的公钥

`ssh-keygen -y -f conversion.key > conversion`

# RC2-40-CBC不支持

从p12证书中导出pem文件时报错

```
openssl pkcs12 -in ftp_scb_test0913.p12  -out sftp_key.pem
```

`80CB4337B67F0000:error:0308010C:digital envelope routines:inner_evp_generic_fetch:unsupported:../crypto/evp/evp_fetch.c:349:Global default library context, Algorithm (RC2-40-CBC : 0), Properties ()`

解决方式，添加provider参数

```
openssl pkcs12 -in ftp_scb_test0913.p12  -out sftp_key.pem -provider default -provider legacy
```

# JSCH文档

[ChannelSftp (JSch API) (epaul.github.io)](https://epaul.github.io/jsch-documentation/javadoc/)

# JSCH例子

```java
package com.cds2;

import com.jcraft.jsch.*;

import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Properties;
import java.util.Vector;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class SftpCatcher {
    // 渣打Sftp连接信息
    private static final String SCB_SFTP_HOST = "H2H-uat.sc.com";
    private static final int SCB_SFTP_PORT = 4022;
    private static final String SCB_SFTP_USER = "1";
    private static final String SCB_SFTP_KEY_FILE = "conversion.key";
    // 中转Sftp连接信息
    private static final String CACHE_SFTP_HOST = "39.100.88.104";
    private static final int CACHE_SFTP_PORT = 4022;
    private static final String CACHE_SFTP_USER = "1";
    private static final String CACHE_SFTP_PASSWORD = "1";

    // 从渣打服务器拉取的频率（秒）
    private static final long s2cInterval = 30 * 60; // 半个小时

    // 向渣打服务器推送的频率（秒）
    private static final long c2sInterval = 10; // 十秒


    public static void main(String[] args) throws Exception {
        log("main", "程序启动");
        // 允许使用ssh-rsa,ssh-dss
        // 由于是类变量，只设置一次
        JSch.setConfig("server_host_key", JSch.getConfig("server_host_key") + ",ssh-rsa,ssh-dss");
        JSch.setConfig("PubkeyAcceptedAlgorithms", JSch.getConfig("PubkeyAcceptedAlgorithms") + ",ssh-rsa,ssh-dss");
        // 新开两个线程进行两个定时任务
        // 渣打2中转
        ScheduledExecutorService s2cScheduledExecutorService = Executors.newScheduledThreadPool(1);
        s2cScheduledExecutorService.scheduleAtFixedRate(
                new Runnable() {
                    @Override
                    public void run() {
                        transformFireFromSCBToCache();
                    }
                },
                5,
                s2cInterval,
                TimeUnit.SECONDS
        );
        // 中转2渣打
        ScheduledExecutorService c2sScheduledExecutorService = Executors.newScheduledThreadPool(1);
        c2sScheduledExecutorService.scheduleAtFixedRate(
                new Runnable() {
                    @Override
                    public void run() {
                        transformFireFromCacheToSCB();
                    }
                },
                0,
                c2sInterval,
                TimeUnit.SECONDS
        );
    }

    static Session getScbSession() throws JSchException {
        // ====== 设置SCB会话参数 ======
        JSch scbJsch = new JSch();
        scbJsch.addIdentity(SCB_SFTP_KEY_FILE);
        final Session scbSession = scbJsch.getSession(SCB_SFTP_USER, SCB_SFTP_HOST, SCB_SFTP_PORT);
        Properties scbConfig = new Properties();
        scbConfig.put("StrictHostKeyChecking", "no");
        scbSession.setConfig(scbConfig);
        return scbSession;
    }

    static Session getCacheSession() throws JSchException {
        // ====== 设置中转会话参数 ======
        JSch cacheJsch = new JSch();
        final Session cacheSession = cacheJsch.getSession(CACHE_SFTP_USER, CACHE_SFTP_HOST, CACHE_SFTP_PORT);
        cacheSession.setPassword(CACHE_SFTP_PASSWORD);
        Properties cacheConfig = new Properties();
        cacheConfig.put("StrictHostKeyChecking", "no");
        cacheSession.setConfig(cacheConfig);
        return cacheSession;
    }

    /**
     * 将符合要求的文件从渣打SFTP服务器上，移动到中转SFTP服务器上
     * PI将文件取走后，可以配置自动删除与自动归档
     *
     * @throws Exception
     */
    private static synchronized void transformFireFromSCBToCache() {
        log("渣打2中转", Thread.currentThread().toString());
        Session scbSession = null;
        Session cacheSession = null;
        ChannelSftp scbChannelSftp = null;
        ChannelSftp cacheChannelSftp = null;
        try {
            scbSession = getScbSession();
            cacheSession = getCacheSession();
            // 建立scb会话
            scbSession.connect();
            scbChannelSftp = (ChannelSftp) scbSession.openChannel("sftp");
            scbChannelSftp.connect();
            // 建立cache会话
            cacheSession.connect();
            cacheChannelSftp = (ChannelSftp) cacheSession.openChannel("sftp");
            cacheChannelSftp.connect();
            Vector<ChannelSftp.LsEntry> ls = scbChannelSftp.ls("/");
            for (ChannelSftp.LsEntry entry : ls) {
                if (entry.getFilename().matches("GCNA8976.*MT940UTF8_DEFAULT.*")) {
                    log("transformFireFromSCBToCache", "match::true::" + entry);
                    try (
                            InputStream fileInputStream = scbChannelSftp.get(entry.getFilename());
                            OutputStream outputStream = cacheChannelSftp.put(entry.getFilename());
                    ) {
                        byte[] bytes = new byte[1024];
                        int len;
                        while ((len = fileInputStream.read(bytes)) != -1) {
                            outputStream.write(bytes, 0, len);
                        }
                        log("transformFireFromSCBToCache", "文件传输完成::" + entry.getFilename());
                    } catch (Exception e) {
                        log("transformFireFromSCBToCache", "文件传输失败::" + entry.getFilename());
                        log("transformFireFromSCBToCache", e);
                    }
//                     TODO 删除渣打服务器上的源文件
//                    scbChannelSftp.rm(entry.getFilename());
//                    log("transformFireFromSCBToCache", "移除渣打服务器文件::" + entry.getFilename() + "::成功");
                } else {
                    log("transformFireFromSCBToCache", "match::false::" + entry);
                }
            }
        } catch (Exception e) {
            log("transformFireFromSCBToCache", e);
        } finally {
            if (scbChannelSftp != null) {
                scbChannelSftp.exit();
            }
            if (scbSession != null) {
                scbSession.disconnect();
            }
            if (cacheChannelSftp != null) {
                cacheChannelSftp.exit();
            }
            if (cacheSession != null) {
                cacheSession.disconnect();
            }
        }

    }

    /**
     * 将中转SFTP服务器上/tft_in中的文件，移动到渣打SFTP服务器上的/tft_in目录下
     * 将文件从中转服务器发送到渣打服务器，需要手动归档
     *
     * @throws Exception
     */
    private static synchronized void transformFireFromCacheToSCB() {
        log("中转2渣打", Thread.currentThread().toString());
        Session scbSession = null;
        Session cacheSession = null;
        ChannelSftp scbChannelSftp = null;
        ChannelSftp cacheChannelSftp = null;
        try {
            scbSession = getScbSession();
            cacheSession = getCacheSession();
            // 建立scb会话
            scbSession.connect();
            scbChannelSftp = (ChannelSftp) scbSession.openChannel("sftp");
            scbChannelSftp.connect();
            // 建立cache会话
            cacheSession.connect();
            cacheChannelSftp = (ChannelSftp) cacheSession.openChannel("sftp");
            cacheChannelSftp.connect();

            final String dirPath = "/tft_in/";
            final String archivePath = "/archiveDir/tft_in/";
            Vector<ChannelSftp.LsEntry> ls = cacheChannelSftp.ls(dirPath);
            for (ChannelSftp.LsEntry entry : ls) {
                if (entry.getAttrs().isDir()) {
                    continue;
                }
                log("transformFireFromCacheToSCB", entry.toString());
                // 将文件移动到渣打服务器上
                try (
                        InputStream fileInputStream = cacheChannelSftp.get(dirPath + entry.getFilename());
                        OutputStream outputStream = scbChannelSftp.put(dirPath + entry.getFilename());
                        FileOutputStream archiveOutputStream = new FileOutputStream("cache.file");
                ) {
                    byte[] bytes = new byte[1024];
                    int len;
                    while ((len = fileInputStream.read(bytes)) != -1) {
                        outputStream.write(bytes, 0, len);
                        archiveOutputStream.write(bytes, 0, len);
                    }
                    log("transformFireFromCacheToSCB", "文件传输完成::" + entry.getFilename());
                } catch (Exception e) {
                    log("transformFireFromCacheToSCB", "文件传输失败::" + entry.getFilename());
                    log("transformFireFromCacheToSCB", e);
                }
                // 归档
                try (
                        InputStream fileInputStream = new FileInputStream("cache.file");
                        OutputStream outputStream = cacheChannelSftp.put(archivePath + entry.getFilename());
                ) {
                    byte[] bytes = new byte[1024];
                    int len;
                    while ((len = fileInputStream.read(bytes)) != -1) {
                        outputStream.write(bytes, 0, len);
                    }
                    log("transformFireFromCacheToSCB", "归档完成::" + entry.getFilename());
                } catch (Exception e) {
                    log("transformFireFromCacheToSCB", "归档失败::" + entry.getFilename());
                    log("transformFireFromCacheToSCB", e);
                }
                // 删除中转服务器上的文件
                cacheChannelSftp.rm(dirPath + entry.getFilename());
                log("transformFireFromCacheToSCB", "移除中转服务器文件::" + entry.getFilename() + "::成功");

            }
        } catch (Exception e) {
            log("transformFireFromSCBToCache", e);
        } finally {
            if (scbChannelSftp != null) {
                scbChannelSftp.exit();
            }
            if (scbSession != null) {
                scbSession.disconnect();
            }
            if (cacheChannelSftp != null) {
                cacheChannelSftp.exit();
            }
            if (cacheSession != null) {
                cacheSession.disconnect();
            }
        }
    }

    static void log(String logger, String message) {
        // 构造日志消息：时间+logger::+message
        String logMessage = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) + "::" + logger + "::" + message;
        // 将日志消息写到控制台
        System.out.println(logMessage);
        // 将日志消息写入文件
        try (
                FileWriter fileWriter = new FileWriter("log.txt", true);
                BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
        ) {
            bufferedWriter.write(logMessage);
            bufferedWriter.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    static void log(String logger, Throwable throwable) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        throwable.printStackTrace(pw);
        String errorStack = sw.toString();
        log(logger, errorStack);
    }
}

```

