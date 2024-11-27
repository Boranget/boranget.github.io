---
title: curl
date: 2024-02-27 10:35:19
updated: 2024-02-27 16:35:19
tags:
  - curl
categories:
  - experience
---

# 简单get请求

```
curl www.baidu,com
curl "www.baidu,com?a=1&b=2"
```

# post带表单

```
curl -X POST -d 'a=1&b=2' www.baidu.com
```

# post带json

```
curl -H "Content-Type: application/json" -X POST -d '{"abc":123,"bcd":"nihao"}' www.baidu.com
```

# 查看响应头

```
curl -i www.baidu,com
```

