---
title: bbmusic实现分析
date: 2024-12-12 21:35:19
updated: 2024-12-12 21:35:19
tags:
  - bbmusic
categories:
  - 经验
---

# 参考资料

[B站鉴权部分 bilibili-API-collect/docs/misc/sign/wbi.md at master · SocialSisterYi/bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/misc/sign/wbi.md)

[搜索获取音乐源部分 flutter-app/lib/origin_sdk/bili/client.dart at ae2792346d503f4d22ffd316f2389fe8435c9c88 · bb-music/flutter-app](https://github.com/bb-music/flutter-app/blob/ae2792346d503f4d22ffd316f2389fe8435c9c88/lib/origin_sdk/bili/client.dart)

[具体调用接口部分 flutter-app/lib/modules/search/search.dart at ae2792346d503f4d22ffd316f2389fe8435c9c88 · bb-music/flutter-app](https://github.com/bb-music/flutter-app/blob/ae2792346d503f4d22ffd316f2389fe8435c9c88/lib/modules/search/search.dart)

# B站接口鉴权

## 获取mixin_key

调用接口`https://api.bilibili.com/x/web-interface/nav`获取两个字段，获取到的 `sub_key` 拼接在 `img_key` 后面，得到64位长度的字符串，记为 `raw_wbi_key`。

映射表：

```
const MIXIN_KEY_ENC_TAB: [u8; 64] = [
    46, 47, 18, 2, 53, 8, 23, 32, 15, 50, 10, 31, 58, 3, 45, 35, 27, 43, 5, 49,
    33, 9, 42, 19, 29, 28, 14, 39, 12, 38, 41, 13, 37, 48, 7, 16, 24, 55, 40,
    61, 26, 17, 0, 1, 60, 51, 30, 4, 22, 25, 54, 21, 56, 59, 6, 63, 57, 62, 11,
    36, 20, 34, 44, 52
]
```

遍历映射表，获取`raw_wbi_key`中的对应字符，组合成`mixin_key`

## 计算请求参数签名

1. 欲签名的**原始**请求参数

   ```
   {
        foo: '114',
        bar: '514',
        zab: 1919810
   }
   ```

   `wts` 的值为当前以秒为单位的 Unix 时间戳，如 `1702204169`

   ```
   {
        foo: '114',
        bar: '514',
        zab: 1919810,
        wts: 1702204169
   }
   ```

   随后按键名升序排序后编码 URL Query，拼接前面得到的 `mixin_key`，如 `bar=514&foo=114&wts=1702204169&zab=1919810ea1db124af3c7062474693fa704f4ff8`，计算其 MD5 即为 `w_rid`。

   需要注意的是：如果参数值含中文或特殊字符等，编码字符字母应当**大写** （部分库会编码为小写字母），空格应当编码为 `%20`（部分库按 `application/x-www-form-urlencoded` 约定编码为 `+`）。

   例如：

   ```
   {
        foo: 'one one four',
        bar: '五一四',
        baz: 1919810
   }
   ```

   应该被编码为 `bar=%E4%BA%94%E4%B8%80%E5%9B%9B&baz=1919810&foo=one%20one%20four`。

2. 向原始请求参数中添加 `w_rid`、`wts` 字段

   将上一步得到的 `w_rid` 以及前面的 `wts` 追加到**原始**请求参数编码得到的 URL Query 后即可，目前看来无需对原始请求参数排序。

   如前例最终得到 `bar=514&foo=114&zab=1919810&w_rid=8f6f2b5b3d485fe1886cec6a0be8c5d4&wts=1702204169`。

# 搜索接口

关键词搜索视频

```dart
const url = 'https://api.bilibili.com/x/web-interface/wbi/search/type';
Map<String, String> query = _signParams({
    'search_type': 'video',
    'keyword': params.keyword,
    'page': params.page.toString(),
    'pagesize': '20',
});
final response = await dio.get(
    Uri.parse(url).replace(queryParameters: query).toString(),
);
```

获取视频详情

```dart
const url = 'https://api.bilibili.com/x/web-interface/view';
Map<String, String> query = _signParams({
    'aid': biliid.aid,
    'bvid': biliid.bvid,
});
final response = await dio.get(
    Uri.parse(url).replace(queryParameters: query).toString(),
);
```

