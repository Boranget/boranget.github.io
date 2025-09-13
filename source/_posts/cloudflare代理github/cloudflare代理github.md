---
title: cloudflare代理github
date: 2023-07-21 16:50:30
updated: 2024-07-30 16:50:30
tags:
  - 代理
categories:
  - 经验
---

# 参考资料

[gh-proxy](https://github.com/hunshcn/gh-proxy)

# 起因

之前一直用gh-proxy来代理github，偶尔发现该网页的页脚有源码分享，于是自己搭建一个

# Cloudflare注册

首页：[https://workers.cloudflare.com](https://workers.cloudflare.com/)

注册账号并登录后，点击左侧”Workers 和 Pages“，点击创建

复制 [index.js](https://cdn.jsdelivr.net/gh/hunshcn/gh-proxy@master/index.js) 到`work.js`点击部署，一般右侧预览窗口应显示最终效果。

但国内访问web.dev域名会被拦截，这里需要自定义域名代理

# 代码注释

```js
"use strict";

/**
 * static files (404.html, sw.js, conf.js)
 */
const ASSET_URL = "https://hunshcn.github.io/gh-proxy/";
// 前缀，如果自定义路由为example.com/gh/*，将PREFIX改为 '/gh/'，注意，少一个杠都会错！
const PREFIX = "/";
// 分支文件使用jsDelivr镜像的开关，0为关闭，默认关闭
const Config = {
  jsdelivr: 0,
};

const whiteList = []; // 白名单，路径里面有包含字符的才会通过，e.g. ['/username/']

// 归档文件
const exp1 =
  /^(?:https?:\/\/)?github\.com\/.+?\/.+?\/(?:releases|archive)\/.*$/i;
const exp2 = /^(?:https?:\/\/)?github\.com\/.+?\/.+?\/(?:blob|raw)\/.*$/i;
const exp3 = /^(?:https?:\/\/)?github\.com\/.+?\/.+?\/(?:info|git-).*$/i;
// raw
const exp4 =
  /^(?:https?:\/\/)?raw\.(?:githubusercontent|github)\.com\/.+?\/.+?\/.+?\/.+$/i;
const exp5 =
  /^(?:https?:\/\/)?gist\.(?:githubusercontent|github)\.com\/.+?\/.+?\/.+$/i;
const exp6 = /^(?:https?:\/\/)?github\.com\/.+?\/.+?\/tags.*$/i;

/**
 * @param {any} body
 * @param {number} status
 * @param {Object<string, string>} headers
 */
function makeRes(body, status = 200, headers = {}) {
  headers["access-control-allow-origin"] = "*";
  return new Response(body, { status, headers });
}

/**
 * @param {string} urlStr
 */
function newUrl(urlStr) {
  try {
    return new URL(urlStr);
  } catch (err) {
    return null;
  }
}
// 全局添加fetch的监听器，该监听器相当于程序入口
addEventListener("fetch", (e) => {
  const ret = fetchHandler(e).catch((err) =>
    makeRes("cfworker error:\n" + err.stack, 502)
  );
  e.respondWith(ret);
});

function checkUrl(u) {
  for (let i of [exp1, exp2, exp3, exp4, exp5, exp6]) {
    if (u.search(i) === 0) {
      return true;
    }
  }
  return false;
}

// 处理进入的fetch请求
/**
 * @param {FetchEvent} e
 */
async function fetchHandler(e) {
  const req = e.request;
  const urlStr = req.url;
  const urlObj = new URL(urlStr);
  let path = urlObj.searchParams.get("q");
  // 如果是用q参数传递的，会重定向为跟在地址后面的格式，用对应的逻辑处理
  if (path) {
    return Response.redirect("https://" + urlObj.host + PREFIX + path, 301);
  }
  // cfworker 会把路径中的 `//` 合并成 `/`
  // 这里的path会被修正为被代理的地址
  path = urlObj.href
    .substr(urlObj.origin.length + PREFIX.length)
    .replace(/^https?:\/+/, "https://");

  if (
    path.search(exp1) === 0 ||
    path.search(exp5) === 0 ||
    path.search(exp6) === 0 ||
    path.search(exp3) === 0 ||
    path.search(exp4) === 0
  ) {
    return httpHandler(req, path);
  } else if (path.search(exp2) === 0) {
    if (Config.jsdelivr) {
      const newUrl = path
        .replace("/blob/", "@")
        .replace(/^(?:https?:\/\/)?github\.com/, "https://cdn.jsdelivr.net/gh");
      return Response.redirect(newUrl, 302);
    } else {
      path = path.replace("/blob/", "/raw/");
      return httpHandler(req, path);
    }
  } else if (path.search(exp4) === 0) {
    const newUrl = path
      .replace(/(?<=com\/.+?\/.+?)\/(.+?\/)/, "@$1")
      .replace(
        /^(?:https?:\/\/)?raw\.(?:githubusercontent|github)\.com/,
        "https://cdn.jsdelivr.net/gh"
      );
    return Response.redirect(newUrl, 302);
  } else {
    // 不满足任何正则，一般就是404
    return fetch(ASSET_URL + path);
  }
}

/**
 * @param {Request} req
 * @param {string} pathname
 */
function httpHandler(req, pathname) {
  const reqHdrRaw = req.headers;

  // preflight
  // 预检请求直接响应允许跨域
  if (
    req.method === "OPTIONS" &&
    reqHdrRaw.has("access-control-request-headers")
  ) {
    // 跨域允许响应体
    /** @type {ResponseInit} */
    const PREFLIGHT_INIT = {
      status: 204,
      headers: new Headers({
        "access-control-allow-origin": "*",
        "access-control-allow-methods":
          "GET,POST,PUT,PATCH,TRACE,DELETE,HEAD,OPTIONS",
        "access-control-max-age": "1728000",
      }),
    };
    return new Response(null, PREFLIGHT_INIT);
  }
  // 获取请求头
  const reqHdrNew = new Headers(reqHdrRaw);
  let urlStr = pathname;

  // 有白名单默认false，否则默认true
  let flag = !Boolean(whiteList.length);
  for (let i of whiteList) {
    if (urlStr.includes(i)) {
      flag = true;
      break;
    }
  }
  if (!flag) {
    return new Response("blocked", { status: 403 });
  }
  // 如果没有协议前缀就加一个
  if (urlStr.search(/^https?:\/\//) !== 0) {
    urlStr = "https://" + urlStr;
  }
  // 转化为URL对象
  const urlObj = newUrl(urlStr);

  /** @type {RequestInit} */
  const reqInit = {
    method: req.method,
    headers: reqHdrNew,
    redirect: "manual",
    body: req.body,
  };
  return proxy(urlObj, reqInit);
}

// 代理请求
/**
 *
 * @param {URL} urlObj
 * @param {RequestInit} reqInit
 */
async function proxy(urlObj, reqInit) {
  const res = await fetch(urlObj.href, reqInit);
  // 响应头
  const resHdrOld = res.headers;
  const resHdrNew = new Headers(resHdrOld);
  // 响应状态
  const status = res.status;

  // 重定向请求处理
  if (resHdrNew.has("location")) {
    let _location = resHdrNew.get("location");
    if (checkUrl(_location)) {
      resHdrNew.set("location", PREFIX + _location);
    } else {
      reqInit.redirect = "follow";
      return proxy(newUrl(_location), reqInit);
    }
  }
  // 继续向响应头中放入跨域相关？
  resHdrNew.set("access-control-expose-headers", "*");
  resHdrNew.set("access-control-allow-origin", "*");

  resHdrNew.delete("content-security-policy");
  resHdrNew.delete("content-security-policy-report-only");
  resHdrNew.delete("clear-site-data");

  return new Response(res.body, {
    status,
    headers: resHdrNew,
  });
}

```

# 支持的地址

- 分支源码：https://github.com/hunshcn/project/archive/master.zip
- release源码：https://github.com/hunshcn/project/archive/v0.1.0.tar.gz
- release文件：https://github.com/hunshcn/project/releases/download/v0.1.0/example.zip
- 分支文件：https://github.com/hunshcn/project/blob/master/filename
- commit文件：https://github.com/hunshcn/project/blob/1111111111111111111111111111/filename
- gist：https://gist.githubusercontent.com/cielpy/351557e6e465c12986419ac5a4dd2568/raw/cmd.py

# 绑定自定义域名

部署后，进入worker的设置页面，点击触发器，选择添加自定义域，将托管到cloudflare的域名填进去，可以使用添加前缀的子域名设置，带证书生效后便可访问。