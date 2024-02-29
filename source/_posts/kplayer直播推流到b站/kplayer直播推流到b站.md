---
title: kplayer直播推流到b站
date: 2023-11-11 08:35:19
updated: 2023-11-12 16:50:30
tags:
  - kplayer
  - 直播推流
categories:
  - experience
---

# 参考资料

[24小时无人值守直播 来自 cnzixn - 酷安 (coolapk.com)](https://www.coolapk.com/feed/44479806?shareKey=OGU3NDQ3YjMwYmRlNjU0ZWQzZjE~&shareUid=24743986&shareFrom=com.coolapk.market_13.3.6)

[KPlayer文档](https://docs.kplayer.net/v0.5.8/)

# 下载安装kplayer

参考[KPlayer文档](https://docs.kplayer.net/v0.5.8/)，快速安装执行以下语句

```bash
curl -fsSL get.kplayer.net | bash
```

# 获取推流地址

访问哔哩哔哩：头像 > 个人中心 > 直播中心 > 我的直播间 > 开播设置

填写分类与直播间名称后点击开始直播，下面会展示服务器地址与串流密钥

拼接服务器地址与串流密钥，中间没有其他分隔符，组成推流地址。

# 配置kplayer

安装结束后在当前目录下会生成kplayer文件夹，进入会有一个`config.json.example`文件，cp一份命名为`config.json`，编辑该文件。

其中，resource>list为直播资源的存放地址，extensions为资源文件的后缀。

output>reconnect_internal 为直播服务器重连时间，秒为单位，建议设置

output>lists>path 为上面组成的推流地址

```json
{
    "version": "2.0.0",
    "resource": {
        "lists": [
            "/home/bili/video/"
        ],
        "extensions": [
            "mp4"
        ]
    },
    "play": {
        "start_point": 1,
        "play_model": "loop",
        "encode_model": "rtmp",
        "cache_on": true,
        "cache_uncheck": false,
        "skip_invalid_resource": true,
        "fill_strategy": "tile",
        "rpc": {
            "on": true,
            "http_port": 4156,
            "grpc_port": 4157,
            "address": "127.0.0.1"
        },
        "encode": {
            "video_width": 854,
            "video_height": 480,
            "video_fps": 25,
            "audio_channel_layout": 3,
            "audio_sample_rate": 44100,
            "bit_rate": 0,
            "avg_quality": 0
        }
    },
    "output": {
        "reconnect_internal": 2,
        "lists": [{
            "path": "rtmp:……flag=1"
        }]
    }
}
```

# 缓存生成

服务器性能很差建议生成缓存，play>cache_on 设为true

# 视频切换失败

文件名尽量不要有特殊字符，设备性能不好的话适当降低屏幕分辨率，这里放上最终的配置，放了50集360p的猫和老鼠，帧数每秒12帧

```json
{
        "version": "2.0.0",
        "resource": {
                "lists": [
                        "/home/kplayer/video"
                ],
                "extensions": [
                        "mp4"
                ]
        },
        "play": {
                "start_point": 1,
                "play_model": "loop",
                "encode_model": "rtmp",
                "cache_on": true,
                "cache_uncheck": false,
                "skip_invalid_resource": true,
                "fill_strategy": "tile",
                "encode": {
                        "video_width": 600,
                        "video_height": 360,
                        "video_fps": 12,
                        "audio_channel_layout": 3,
                        "audio_sample_rate": 44100,
                        "bit_rate": 0,
                        "avg_quality": 0
                }
        },
        "output": {
                "reconnect_internal": 2,
                "lists": [{
                        "path": "推流地址"
                }]
        }
}


```
