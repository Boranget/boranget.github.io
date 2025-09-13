---
title: Elasticsearch
date: 2024-08-05 10:35:19
updated: 2024-12-27 15:35:19
tags:
  - Elasticsearch
categories:
  - 笔记
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

创建索引同时设置映射

```json
PUT 39.100.88.104:9200/amertest
{
    "settings": {
        "analysis": {
        "tokenizer": {
            "xml_tokenizer": { 
                "type": "pattern",
                "pattern": "(<[^/>]*>[^<]*</[^>]*>)",
                "group": 1
            }
        },
        "analyzer": {
            "xml_analyzer": { // 自定义的分析器名称
                "type": "custom",
                "char_filter": [], 
                "tokenizer": "xml_tokenizer", // 自定义分词
                "filter": ["lowercase"] 
            }
        }
    }
    },
    "mappings": {
        "properties": {
            "content": {
                "type": "text",
                "analyzer": "xml_analyzer",
                "search_analyzer": "xml_analyzer"
            }
        }
    }
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

## 查看索引映射

```
GET 39.100.88.104:9200/amertest/_mappings?pretty
```



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

**分页**

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

# 模糊查询/wildcard查询

wildcard查询也是基于term的，模糊查询的范围只能在分词结果上进行。

模糊查询的查询参数不会走分词器，如果不想区分大小写，配置`"case_insensitive": true`

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

可在mapping中将一个字段的类型改为wildcard类型，这样在wildcard搜索时 会对效率有提升（未测试）

# 多条件搜索

- must 为与逻辑
- should为或逻辑

```
GET 39.100.88.104:9200/amertestxml/_search
{
    "query": {
        "bool": {
            "must": [
                {
                    "wildcard": {
                        "content": {
                            "value": "*0000000000204028*",
                            "case_insensitive": true
                        }
                    }
                },
                {
                    "wildcard": {
                        "content": {
                            "value": "<MANDT>800</MANDT>",
                            "case_insensitive": true
                        }
                    }
                }
            ]
        }
    }
}
```



# 分析器/ analyzer

## 作用

- 在对text字段进行索引时
- 对text字段进行full-text搜索时，会对查询参数进行分析

## 组成

分析器由以下三部分组成

- character filter

    在tokenizer之前，会先使用character filter原始文本进行处理，比如增加删除替换字符

    一个分析器可以有0-n个character filter，且可按顺序处理

- tokenizer

    将character filter的结果切分为一个个token，比如可根据下划线、空格等

    一个分析器只能有一个tokenizer

- token fileter

    对tokenizer输出的的token进行过滤，包括增删改，比如可以将单词全部小写、去除指定单词、增加同义词等

    一个分析器可以有0-n个token fileter，且可按顺序处理

## 组装自定义分词器

格式：

```json
{
  "settings": {
    "analysis": {           // 分词设置
      "char_filter": {},    // char_filter 字符过滤器
      "tokenizer": {},      // tokenizer 分词器
      "filter": {},         // filter 分词过滤器
      "analyzer": {}        // analyzer 自定义分词器
    }
  }
}
```

比如：

```
PUT test_index/_settings
{
    "analysis": {
        "char_filter": {
            "&_to_and": {   // 自定义&_to_and过滤器
                "type": "mapping",
                "mappings": [
                    "& => and"
                ]
            }
        },
        "tokenizer": {
            "custom_tokenizer": { // 自定义分词器，根据下划线、横线、斜线、点分词
                "type": "pattern",
                "pattern": "[/_\\-\\.]"
            }
        },
        "filter": {
            "my_stopwords": {
                "type": "stop",
                "stopwords": [
                    "the",
                    "a"
                ]
            }
        },
        "analyzer": {
            "my_analyzer": { // 自定义的分析器名称
                "type": "custom",
                "char_filter": [
                    "html_strip",
                    "&_to_and"
                ], // 跳过HTML标签, 将&符号转换为"and"
                "tokenizer": "custom_tokenizer", // 自定义分词
                "filter": [
                    "lowercase",
                    "my_stopwords"
                ] // 转换为小写
            }
        }
    }
}
```

## 修改索引中的分词器

```
// 关闭索引:
POST index_name/_close

// 启用filter
PUT index_name/_settings
{
    "analysis": {
        "analyzer": {               
            "my_analyzer": {        // 自定义的分词器
                "type": "standard", //分词器类型standard
                "stopwords": "_english_" //standard分词器的参数，默认的stopwords是\_none_
            }
        }
    }
}

// 重新打开索引:
POST index_name/_open
```

## 分词器测试

```
GET index_name/_analyze
{
    "analyzer": "my_analyzer",
    "text":"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MATMAS05><IDOC BEGIN=\"1\"><EDI_DC40 SEGMENT=\"1\"><TABNAM>EDI_DC40</TABNAM><MANDT>800</MANDT>"
}
```

响应：

```
{
  "tokens": [
    {
            "token": "<?xml version=\"1.0\" encoding=\"UTF-8\"?",
            "start_offset": 0,
            "end_offset": 37,
            "type": "word",
            "position": 0
        },
        {
            "token": "MATMAS05",
            "start_offset": 39,
            "end_offset": 47,
            "type": "word",
            "position": 1
        },
        {
            "token": "IDOC BEGIN=\"1\"",
            "start_offset": 49,
            "end_offset": 63,
            "type": "word",
            "position": 2
        },
        {
            "token": "EDI_DC40 SEGMENT=\"1\"",
            "start_offset": 65,
            "end_offset": 85,
            "type": "word",
            "position": 3
        },
        {
            "token": "TABNAM>EDI_DC40</TABNAM",
            "start_offset": 87,
            "end_offset": 110,
            "type": "word",
            "position": 4
        },
        {
            "token": "MANDT>800</MANDT",
            "start_offset": 112,
            "end_offset": 128,
            "type": "word",
            "position": 5
        }
  ]
}
```

## tokenizer测试

```json
PUT my-index-000001
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_analyzer": {
          "tokenizer": "my_tokenizer"
        }
      },
      "tokenizer": {
        "my_tokenizer": {
          "type": "simple_pattern",
          "pattern": "[0123456789]{3}"
        }
      }
    }
  }
}

POST my-index-000001/_analyze
{
  "analyzer": "my_analyzer",
  "text": "fd-786-335-514-x"
}
```

## 正则表达式分词

https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-simplepattern-tokenizer.html

https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-pattern-tokenizer.html#_configuration_16

# 内存大小设置

ES安装目录下config目录中的jvm.option,修改-Xms和XMx

- 不要超过物理内存的50%
- 堆内存大小不要超过32G
- 一般设置31G

# 聚合

比如查平均值或者求和等操作

# 索引模板

创建索引时的配置可以保存为模板

# Bulk API

可进行批量操作，请求体格式为：

```
{ action: { metadata }}
{ request body        }
{ action: { metadata }}
{ request body        }
```

需要注意的时，每一个结构都必须在单独的一行，如果是用postman调用，则请求体最后要加单独的一个空行

- `create` 如果文档不存在就创建，但如果文档存在就返回错误
- `index` 如果文档不存在就创建，如果文档存在就更新
- `update` 更新一个文档，如果文档不存在就返回错误
- `delete` 删除一个文档，如果要删除的文档id不存在，就返回错误

请求体一次不能超过100M

## 批量插入

```
curl --location 'host/amertestxml/_bulk' \
--header 'Content-Type: application/json' \
--data '{"index": {}}
{"content":"bylk_1"}
{"index": {}}
{"content":"bylk_2"}
'
```



