---
title: Elasticsearch
date: 2024-08-05 10:35:19
updated: 2024-08-05 10:35:19
tags:
  - Elasticsearch
categories:
  - notes
---

# 参考资料

[Download Elasticsearch | Elastic](https://www.elastic.co/cn/downloads/elasticsearch)

# 配置

windows下直接启动`bin\elasticsearch.bat`后无法访问（hang up），经验证，需要先将配置文件中的`xpack.security.enabled: true`改为`xpack.security.enabled: false`。

# 启动

运行`bin\elasticsearch.bat`后，访问`http://localhost:9200/`

显示内容如下，即为启动成功

```
{
  "name": "....",
  "cluster_name": "elasticsearch",
  "cluster_uuid": ".....",
  "version": {
    "number": "8.14.3",
    "build_flavor": "default",
    "build_type": "zip",
    "build_hash": "..........",
    "build_date": "2024-07-07T22:04:49.882652950Z",
    "build_snapshot": false,
    "lucene_version": "9.10.0",
    "minimum_wire_compatibility_version": "7.17.0",
    "minimum_index_compatibility_version": "7.0.0"
  },
  "tagline": "You Know, for Search"
}
```

# 修改密码

执行bin下的`elasticsearch-reset-password -u elastic`，会重新生成一个随机密码

# 创建/删除索引

索引相当于结构化存储中的数据库，在es中要求索引名必须为英文小写

## 创建

`curl -X PUT 'localhost:9200/weather'`

响应：

```json
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "testindex"
}
```

## 删除

`curl -X DELETE 'localhost:9200/weather'`

```json
{
    "acknowledged": true
}
```

# 类型

类型Type，是在索引下的一级数据结构，新版的es去掉了该层级，type名字默认`_doc`

# 中文分词器

[infinilabs/analysis-ik: 🚌 The IK Analysis plugin integrates Lucene IK analyzer into Elasticsearch and OpenSearch, support customized dictionary. (github.com)](https://github.com/infinilabs/analysis-ik)

用于对存储结构中的中文字段进行分词从而进行搜索

# 映射与动态映射

映射负责数据的存储与索引方式，

一般情况下无需手动创建映射，ES会自动创建映射并在检测到有新字段出现的时候更新映射

如需手动创建映射，可在索引创建时传参设置



# 数据操作

需要注意的是，为了方便索引，存入一个index中的数据结构最好是一致的，这样也方便统一标识各个字段的类型以及设置分词器。

## 新增

```
curl -X PUT 'localhost:9200/accounts/person/1' -d '
{
  "user": "张三",
  "title": "工程师",
  "desc": "数据库管理"
}'
```

其中的`person`为索引下的type层级，如果没有设置type，默认为`_doc`，**最新版type已弃用，直接使用`_doc`**

其中的`1`为记录的id，可为任意字符串

```
curl -X PUT 'localhost:9200/testindex/_doc/1' -d '
{
  "name":"testIndex/1",
  "age":18,
  "nick":"张三"
}'
```

或者使用post请求，不指定id，此时id会随机生成

```
curl -X POST 'localhost:9200/testindex/_doc' -d '
{
  "name":"testIndex/1",
  "age":18,
  "nick":"张三"
}'
```

## 查看

使用get请求

```
curl 'localhost:9200/accounts/person/1'
```

若结果不存在，则会响应404，同时found字段为false

## 删除

```
curl -X DELETE 'localhost:9200/accounts/person/1'
```

删除成功会响应200，找不到该条记录则响应404

## 更新

使用put请求针对某个id发送一条新数据，响应中result字段为“update”，而创建时该字段为"created"

## 搜索

获取某索引下的所有记录：

`curl 'localhost:9200/content/_search'`

```json
{
    "took": 2,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 3,
            "relation": "eq"
        },
        "max_score": 1.0,
        "hits": [
            {
                "_index": "content",
                "_id": "1",
                "_score": 1.0,
                "_source": {
                    "title": "t1",
                    "content": "hello world1"
                }
            },
            {
                "_index": "content",
                "_id": "2",
                "_score": 1.0,
                "_source": {
                    "title": "t2",
                    "content": "hello world2"
                }
            },
            {
                "_index": "content",
                "_id": "3",
                "_score": 1.0,
                "_source": {
                    "title": "t3",
                    "content": "hello world3"
                }
            }
        ]
    }
}
```

match搜索

请求地址如上，但添加了请求体

```json
{
    "query": {
        "match": {
            "content": "world1"
        }
    }
}
```

则搜索结果为

```json
{
    "took": 3,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 1,
            "relation": "eq"
        },
        "max_score": 0.9808291,
        "hits": [
            {
                "_index": "content",
                "_id": "1",
                "_score": 0.9808291,
                "_source": {
                    "title": "t1",
                    "content": "hello world1"
                }
            }
        ]
    }
}
```

默认情况下，match请求返回十条记录，可通过size参数调整

```json
{
    "query": {
        "match": {
            "content": "hello"
        }
    },
    "size": 13
}
```

另外可结合from参数进行分页

```json
{
    "query": {
        "match": {
            "content": "hello"
        }
    },
    "size": 13,
    "from": 5
}
```

# wildcard查询

wildcard查询也是基于term的，模糊查询的范围只能在分词结果上进行。

如下，content为要查询的字段，value为要查询的内容，case_insensitive为忽略大小写

```
{
    "query":{
        "wildcard":{
            "content":{
                "value":"docnUm_*000000000020402*",
            "case_insensitive": true
            }
        }
        
    }
}
```

## wildcard字段

可在mapping中将一个字段的类型改为wildcard类型，这样在wildcard搜索时 会对效率有提升（未测试）