---
title: PicGo配合github搭建图床
date: 2024-02-27 10:35:19
updated: 2024-2-27 16:35:19
tags:
  - 图床
  - cdn
  - jsDelivr
  - PicGo
categories:
  - notes
---

# 参考资料

[Typora搭建github图床 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/391237563)

[利用GitHub+jsdelivr搭建一个高速图床全网最详细附加解决上传失败问题 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/347516134)

[如何使用jsDelivr+Github 实现免费CDN加速? - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/346643522)

[使用 jsDelivr CDN 对 Github 图床进行加速，带给你如丝滑般的图片体验！ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/138582151)

[配置手册 | PicGo](https://picgo.github.io/PicGo-Doc/zh/guide/config.html#又拍云)

[配置文件 | PicGo-Core](https://picgo.github.io/PicGo-Core-Doc/zh/guide/config.html#picbed-github)

# github端配置

## 建立图床仓库

github上新建一个开源仓库，用于存放图片资源

## 生成访问token

个人设置>开发者设置>个人访问token

![image-20240227100929263](PicGo配合github搭建图床/image-20240227100929263.png)

选择刚创建的仓库

![image-20240227105134923](PicGo配合github搭建图床/image-20240227105134923.png)

这里的token需要有Content的写入权限，权限参考：[REST API endpoints for repository contents - GitHub Docs](https://docs.github.com/en/rest/repos/contents?apiVersion=2022-11-28#create-or-update-file-contents)

![image-20240227105038570](PicGo配合github搭建图床/image-20240227105038570.png)

![image-20240227105042414](PicGo配合github搭建图床/image-20240227105042414.png)

# Typora端配置

## PicGo-Core

进入Typora的设置，找到图像配置中的图像上传配置，选择PicGo-core，点击右侧的下载或更新，等待下载。

下载完成后，点击打开配置文件，按照如下格式修改

```json
{
  "picBed": {
    "current": "github",
    "github":{
        "repo": "boranget/image-bed-0", // 仓库名，格式是username/reponame
  		"token": "" // github token
    }
  },
  "picgoPlugins": {}
}
```

配置完后点击typora设置中的`验证图片上传选项`

![image-20240227105459688](PicGo配合github搭建图床/image-20240227105459688.png)

可以看到上传成功，这里注意上传的时候不可以使用steam++代理github，否则会报证书问题。其他代理工具是否可用未知

## 批量上传

在typora导航栏中，点击`格式>图像>上传所有本地图片`，可以上传当前md文件中所有用到的图片到github，同时将文档中的图片引用地址改为github中文件的raw地址，但似乎有图片引用错位的问题

# jsDelivr加速

在picgo配置文件中配置根目录和自定义域名，如下

```json
{
  "picBed": {
    "current": "github",
    "github":{
      "repo": "boranget/image-bed-0", 
      "token": "",
        // path必须填写，否则地址拼接时会变为undefined
      "path": "", 
        // https://cdn.jsdelivr.net/gh/用户名/图床仓库名@分支
      "customUrl": "https://cdn.jsdelivr.net/gh/boranget/image-bed-0@main",
      "branch": "main"
    }
  },
  "picgoPlugins": {}
}
```

