---
title: 百度千帆大模型ErnieSpeed使用
date: 2024-05-22 22:35:19
updated: 2024-05-22 22:35:19
tags:
  - aigc
categories:
  - 经验
---

# 参考资料

[百度智能云-云智一体深入产业 (baidu.com)](https://cloud.baidu.com/)

[ERNIE-Speed-128K - 千帆大模型平台 | 百度智能云文档 (baidu.com)](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/6ltgkzya5)

[获取access_token - 千帆大模型平台 | 百度智能云文档 (baidu.com)](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/Ilkkrb0i5)

# 注册账号并实名认证

进入百度智能云官网，使用手机号注册，注册完成后，点击头像进入用户中心，进行个人认证

认证过程可以使用二代身份证：输入真实姓名与身份证号后，会出现一个二维码，使用微信扫描该二维码，进行人脸识别即可

# 创建应用

[百度智能云控制台 (baidu.com)](https://console.bce.baidu.com/qianfan/ais/console/applicationConsole/application)

点击该地址进入应用控制台，点击左侧应用接入，填写相关信息并创建应用，创建成功后可以看到apiKey和secretKey

# 获取token

访问地址 `https://aip.baidubce.com/oauth/2.0/token`

以查询参数的方式在地址后跟上`grant_type`、`client_id`、`client_secret`三个参数，值分别为固定值`client_credentials`、应用的apiKey、应用的secretKey，同时请求方式需为post，请求格式为json，但是请求体为空，响应中会携带access_token

# 发送请求

以ernie-speed-128k为例，请求地址为`https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/ernie-speed-128k?access_token=`，token填写上面获取的access_token

请求内容可以查看文档，下面简单给出请求示例

```json
{
    "messages": [
        {
            "role": "user",
            "content": "你好"
        },
        {
            "role": "assistant",
            "content": "您好，有什么我可以帮助您的吗？如果您有任何问题或需要帮助，请随时告诉我，我会尽力为您提供支持和解答。"
        },
        {
            "role": "user",
            "content": "一加一等于几"
        },
        {
            "role": "assistant",
            "content": "您好，有什么我可以帮助您的吗？如果您有任何问题或需要帮助，请随时告诉我，我会尽力为您提供支持和解答。"
        },
        {
            "role": "user",
            "content": "我上一个问你的问题是什么"
        }
    ]
}
```

响应：

```json
{
    "id": "as-yk98martgq",
    "object": "chat.completion",
    "created": 1716388057,
    "result": "您上一个问的问题是“一加一等于几”。在数学中，1加1等于2。如果您有其他问题或需要进一步的帮助，请随时告诉我。",
    "is_truncated": false,
    "need_clear_history": false,
    "usage": {
        "prompt_tokens": 58,
        "completion_tokens": 31,
        "total_tokens": 89
    }
}
```

