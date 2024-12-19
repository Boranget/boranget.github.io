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

# google仓库问题

在系统环境变量中添加如下两个变量

`PUB_HOSTED_URL="https://pub.flutter-io.cn"`

`FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"`

# gradle

修改

`my_flutter\android\gradle\wrapper\gradle-wrapper.properties`下`distributionUrl=file://D/tools/flutterSDK/gradle-8.11.1-all.zip`