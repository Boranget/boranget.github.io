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

    **注意：jdk1.8之前的版本（不包括1.8）需要使用dom4j 2.0.*的版本，与其后版本不兼容**

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

# 无中生有

逐个节点构建一个xml结构,并导出为字符串

```jsva
Document document = DocumentHelper.createDocument();
Element rootElement = document.addElement("ROOT");
Element empId = rootElement.addElement("ID");
empId.setText("2021");
Element empCode = rootElement.addElement("CODE");
empCode.setText("200");
Element empTime = rootElement.addElement("TIME");
empTime.setText(time);
String xmlStr = document.asXML().toString();
```

# xml字符串转为xml对象

```java
Document dom =DocumentHelper.parseText(xmlStr);
Element root=dom.getRootElement();
String id = root.element("ID").getText();
String code = root.element("CODE").getText();
String message = root.element("MESSAGE").getText();
```

# 通过xpath获取节点

```java
Document document = ....; 
List<Node> nodes = document.selectNodes("//nodeName");
```

路径前带双斜杠为从寻找整个文档中所有的name为"nodeName"的节点

路径前带单斜杠为在根节点下寻找某节点

```jsva
for (Node node : nodes) {
    ......
    String s = node.selectSingleNode("rn5:id").getText();
    .............
}
```

路径前不带斜杠为在当前调用node下寻找某节点.

**注意**: 如果在selectSingleNode方法中传入了双斜杠表达式,他会寻找整个文档中第一个名称为nodeName的节点返回

可添加 | 表示多个xpath

# 命名空间

## 读取

带命名空间的xml字符串转为dom对象, 并且在寻找节点时要带命名空间

```java
		
 private static Document getDocumentFromXmlWithNameSpace(String xmlRes) {
        Map<String, String> xmlMap = new HashMap<>();
		// 将所有命名空间加入此map
        xmlMap.put("rn0", "urn:java.lang");
        xmlMap.put("rn2", "urn:com.sap.aii.mdt.api.data");
        ...............
        SAXReader reader = new SAXReader();
        reader.getDocumentFactory().setXPathNamespaceURIs(xmlMap);
        Document document = null;
        try {
            byte[] bytes = xmlRes.getBytes();
            document = reader.read(new ByteInputStream(bytes, bytes.length));
        } catch (DocumentException e) {
            e.printStackTrace();
        }
        return document;
}

```

## 写入

在给根元素设置命名空间属性时不能直接通过属性设置，所有的命名空间元素（xmlns开头属性）都必须通过根元素的addNamespace方法设置，否则会出错。

```xml
<xsd:schema xmlns="http://www.democz.com/collect" xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace="http://www.democz.com/collect">
```

需要

```java
Document document = DocumentHelper.createDocument();
// 创建schema标签
Element schema = new DefaultElement("schema",DEFAULT_NAMESPACE);
// 命名空间设置
schema.addAttribute("targetNamespace",namespace);
schema.addNamespace("",namespace);
schema.addNamespace("xsd","http://www.w3.org/2001/XMLSchema");
```

带前缀prefix命名空间的元素名需要在定义元素时用参数的形式写入，不然（直接使用命名中添加前缀的方式）迟早会出错

```java
// 创建命名空间用于全局使用
public static final DefaultNamespace DEFAULT_NAMESPACE = new DefaultNamespace("xsd", "http://www.w3.org/2001/XMLSchema");
// 创建schema标签
Element schema = new DefaultElement("schema",DEFAULT_NAMESPACE);
// 命名空间设置
schema.addAttribute("targetNamespace",namespace);
schema.addNamespace("",namespace);
schema.addNamespace("xsd","http://www.w3.org/2001/XMLSchema");
// 放入top元素
Element sequence = new DefaultElement("sequence", DEFAULT_NAMESPACE);
Element complexType = new DefaultElement("complexType", DEFAULT_NAMESPACE);
```

错误示范：

```java
Element schema = new DefaultElement("xsd:schema");
```

# 写入到文件

将document的内容写入到文件，一种方式是使用asXML后获取字符串手动存储，另一种是使用dom4j的XMLWriter，可以同时设置格式化缩进与编码

**一个坑，不要使用FileWriter配合XMLWriter的方式，这样会导致format设置的编码无效，正确搭配是FileOutPutStream**

[xmlWriter以UTF-8格式写xml问题_xmlwriter里面可以操作outputformat-CSDN博客](https://blog.csdn.net/m0_37564426/article/details/88665677)

```java
/**
 * @author boranget
 * @date 2023/12/3
 */
public class OexsdWriter {
    static final Logger logger = LogManager.getLogger(OexsdWriter.class);
    public static void writeOexsdsToFile(String location, String excelFileName, Map<String, Document> ori) {

        ori.forEach((fileName, document) -> {
            // 格式化输出
            OutputFormat format = new OutputFormat().createPrettyPrint();
            // 紧凑输出
            // OutputFormat format = new OutputFormat().createCompactFormat();
            // 设置编码格式
            format.setEncoding("utf-8");
            // 获取文件夹
            // 这里不直接用excelFileName.split()是避免输入参数为相对路径（./file.xlsx）的情况下会被第一个.干扰
            File newFolder = new File(location, new File(excelFileName).getName().split("\\.")[0]);
            if (!newFolder.exists()) {
                newFolder.mkdirs();
            }
            // 创建目标文件
            File targetXsdFile = new File(newFolder, fileName + ".xsd");
            // 这里不能使用FileWriter，否则会导致format中设置的编码无效
            // FileWriter fileWriter = null;
            FileOutputStream fileOutputStream = null;
            XMLWriter xmlWriter = null;
            try {
                fileOutputStream = new FileOutputStream(targetXsdFile);
                xmlWriter = new XMLWriter(fileOutputStream,format);
                xmlWriter.write(document);
                logger.info("xsd [ "+targetXsdFile.getAbsolutePath()+" ]写入成功");
            } catch (IOException e) {
                logger.error("xsd [ "+targetXsdFile.getAbsolutePath()+" ]写入到文件时出现异常");
                e.printStackTrace();
            } finally {
                if (xmlWriter != null) {
                    try {
                        xmlWriter.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                if (fileOutputStream != null) {
                    try {
                        fileOutputStream.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        });
    }
}

```



