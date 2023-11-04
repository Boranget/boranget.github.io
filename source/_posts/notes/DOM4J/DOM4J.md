---
title: DOM4J
date: 2023-11-04 16:35:19
tags:
  - DOM4J
categories:
  - 笔记
---

# 使用步骤

1. 导入依赖
2. 创建解析器对象（SAXReader）
3. 解析xml获得Document对象
4. 获取根节点RootElement
5. 获取根节点下的子节点

# 案例

```java
SAXReader saxReader = mew SAXReader();
// 通过类加载器获取项目目录下的内容
InputStream in = TestClass.class.getClassLoaser().getResourceAsStream("jdbc.xml")
Document doc = saxReader.read(in);
// 获取根标签
Element root = doc.getRootElement();
```

# Node

- element 标签
- attribute 标签属性
- text 标签中的内容文本

# 子元素

```java
// 获取子元素list
List<Element> list = element.elements();
```

# 获取标签名

```java
element.getName();
```

# 属性

```java
// 根据属性名获取
Attribute attribute = element.attribute("属性名");
// 获取全部属性
List<Attribute> attributes = element.attributes();
// 属性名
attribute.getName();
// 属性值
attribute.getValue();
// -----------
// 直接获取属性值
elememtn.attributeValue("属性名");
```

# 文本

```java
element。getText()
```





