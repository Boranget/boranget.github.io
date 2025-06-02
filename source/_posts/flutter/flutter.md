---
title: flutter
date: 2024-02-27 10:35:19
updated: 2024-02-27 16:35:19
tags:
  - flutter
categories:
  - experience
---

# Android tool chain问题

使用AS下载完SDK和相关工具后，使用`flutter config --android-sdk SDK路径`设置一下SDK即可

# 墙内google仓库问题

需要在系统环境变量中添加如下两个变量

`PUB_HOSTED_URL="https://pub.flutter-io.cn"`

`FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"`

# 墙内gradle依赖相关问题

build.gradle中配置镜像

```js
buildscript {
    repositories {
        maven { setUrl("https://maven.aliyun.com/repository/central") }
        maven { setUrl("https://maven.aliyun.com/repository/jcenter") }
        maven { setUrl("https://maven.aliyun.com/repository/google") }
        maven { setUrl("https://maven.aliyun.com/repository/gradle-plugin") }
        maven { setUrl("https://maven.aliyun.com/repository/public") }
        maven { setUrl("https://jitpack.io") }
        maven { setUrl("https://maven.aliyun.com/nexus/content/groups/public/") }
        maven { setUrl("https://maven.aliyun.com/nexus/content/repositories/jcenter") }
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        maven { setUrl("https://maven.aliyun.com/repository/central") }
        maven { setUrl("https://maven.aliyun.com/repository/jcenter") }
        maven { setUrl("https://maven.aliyun.com/repository/google") }
        maven { setUrl("https://maven.aliyun.com/repository/gradle-plugin") }
        maven { setUrl("https://maven.aliyun.com/repository/public") }
        maven { setUrl("https://jitpack.io") }
        maven { setUrl("https://maven.aliyun.com/nexus/content/groups/public/") }
        maven { setUrl("https://maven.aliyun.com/nexus/content/repositories/jcenter") }
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}
```

gradle-wrapper.properties中配置镜像

```
distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-8.3-all.zip
```

flutterSDK\flutter\packages\flutter_tools\gradle\flutter.gradle中添加

但似乎作用不大

```js
buildscript {
    repositories {
        //google()
        //mavenCentral()
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
        maven { url 'https://maven.aliyun.com/repository/public' }
    }
}
```

flutterSDK\flutter\packages\flutter_tools\gradle\resolve_dependencies.gradle中添加镜像，似乎作用不大

```js

repositories {
    maven {
        url "$storageUrl/${engineRealm}download.flutter.io"
    }
    maven { url 'https://maven.aliyun.com/repository/google' }
    maven { url 'https://maven.aliyun.com/repository/jcenter' }
    maven { url 'https://maven.aliyun.com/repository/public' }
}
```



# 声明式UI

[声明式 UI | Flutter 中文文档 - Flutter 中文开发者网站 - Flutter](https://docs.flutter.cn/get-started/flutter-for/declarative)