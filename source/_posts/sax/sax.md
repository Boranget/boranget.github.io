---
title: sax
date: 2023-04-22 11:35:19
updated: 2023-12-10 16:40:19
tags:
  - xml
  - sax
categories:
  - 笔记
---

# sax介绍

sax与dom解析不同的是，他是自顶向下的，边扫描边解析，适用于大数据量的，只有读取需求的时候

# 使用

我们使用的xml源数据为

```xml
<Persons>
    <person>
        <id>14233222322323</id>
        <name>张三</name>
        <age>15</age>
        <isMen>true</isMen>
    </person>
    <person>
        <id>14233222322323</id>
        <name>李四</name>
        <age>15</age>
        <isMen>true</isMen>
    </person>
</Persons>
```

这里我们的需求是将其中的person数据取出,并存入Person对象

```java
@Data
public class Person {
    Long id;
    String name;
    Integer age;
    Boolean isMen;
}
```

sax提供了一个DefaultHandler的父类用于实现扩展, 我们编写一个类继承该类

## 全局变量

```java
public static final String PERSON_TAG = "person";
// 存放解析结果列表
List<Person> personList = null;
// 存放当前解析对象
Person p = null;
// 当前值的内容,由于sax有可能分段读取,所以这里使用了sb
StringBuilder currentValueStringBuilder = null;
```

## startDocument

该方法在解析刚开始时调用，可用于初始化。

```java
/**
 * 在文档开始的操作
 * 可用于初始化
 * @throws SAXException
 */
@Override
public void startDocument() throws SAXException {
    // 初始化结果集
    personList = new ArrayList<>();
    // 初始化拼接value的sb
    currentValueStringBuilder = new StringBuilder();
}
```

## startElement

在解析器遇到开始标签时会调用该方法

```java
@Override
public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
    // 这里判断如果当前标签为"person",则创建一个新的person对象
    if(PERSON_TAG.equals(qName)){
        p = new Person();
    }
    // 这里的操作为清空sb,避免之前的数据对当前数据造成影响
    currentValueStringBuilder.delete(0, currentValueStringBuilder.length());
    // 或者使用
    currentValueStringBuilder.setLength(0);
}
```

## characters

该方法为读取xml标签的内容时所调用的方法, 由于sax的机制, 若当前内容长度过长, 会对内容进行分段读取, 故这里使用sb进行拼接

```java
@Override
    public void characters(char[] ch, int start, int length) throws SAXException {
        currentValueStringBuilder.append(ch,start,length);
    }
```

## endElement

在遇到结束标签时调用的方法, 如果当前标签为我们需要的字段, 可以在此方法中存入实体类, 若当前标签为实体类的结束标签, 可将结果存入结果集.

```java
@Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        // 获取person类的所有属性
        // 判断当前结束的节点是否为person中的一个属性
        Class<Person> personClass = Person.class;
        Set<String> collect = Arrays.stream(personClass.getDeclaredFields()).map(Field::getName).collect(Collectors.toSet());
        if(!collect.contains(qName)){
            // 如果是person标签,则将当前的person对象加入列表
            if(PERSON_TAG.equals(qName)){
                personList.add(p);
            }
            // 如果不是person中的属性返回即可
            return;
        }
        // 将sb转为string
        String value = currentValueStringBuilder.toString();
        try {
            // 反射赋值操作
            // 获取person中的当前字段
            Field declaredField = personClass.getDeclaredField(qName);
            declaredField.setAccessible(true);
            // 获取该字段类型的、以string作为参数的构造器
            final Constructor<?> constructor = declaredField.getType().getConstructor(String.class);
            // 创建一个该类型的值并赋予该字段
            declaredField.set(p,constructor.newInstance(value));
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        }
    }
```

## endDocument

此方法为解析结束调用的方法,这里不进行操作

```java
@Override
public void endDocument() throws SAXException {
    super.endDocument();
}
```



## 调用

```java
public static void main(String[] args) throws IOException, SAXException, ParserConfigurationException {
        // 加载文件返回文件的输入流
        InputStream is = new FileInputStream(Paths.get(".\\demo\\src\\main\\resources\\person.xml").toFile());
        // 创建一个解析器
        MySaxHandler mySaxHandler = new MySaxHandler();
        // SAX解析工厂
        SAXParserFactory saxParserFactory = SAXParserFactory.newInstance();
        // 让工厂生产一个sax解析器
        SAXParser newSAXParser = saxParserFactory.newSAXParser();
        // 传入输入流和handler解析
        newSAXParser.parse(is, mySaxHandler);
        is.close();
        System.out.println(mySaxHandler.personList);

    }
```

# 全部代码

```java
package sax;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author boranget
 * @date 2023/4/22
 */
public class MySaxHandler extends DefaultHandler {
    public static final String PERSON_TAG = "person";
    // 存放解析结果列表
    List<Person> personList = null;
    // 存放当前解析对象
    Person p = null;
    // 当前值的内容,由于sax有可能分段读取,所以这里使用了sb
    StringBuilder currentValueStringBuilder = null;

    /**
     * 在文档开始的操作
     * 可用于初始化
     * @throws SAXException
     */
    @Override
    public void startDocument() throws SAXException {
        personList = new ArrayList<>();
        currentValueStringBuilder = new StringBuilder();
    }

    /**
     * 每当碰到一个开始节点便会触发此方法
     * @param uri
     * @param localName
     * @param qName
     * @param attributes
     * @throws SAXException
     */
    @Override
    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        if(PERSON_TAG.equals(qName)){
            p = new Person();
        }
//        currentValueStringBuilder.delete(0, currentValueStringBuilder.length());
        currentValueStringBuilder.setLength(0);
    }

    /**
     * 读取节点内的数据,此过程有可能由于内容过长而分段读取
     * @param ch
     * @param start
     * @param length
     * @throws SAXException
     */
    @Override
    public void characters(char[] ch, int start, int length) throws SAXException {
        currentValueStringBuilder.append(ch,start,length);
    }

    /**
     * 每当碰到结束标签便调用
     * 在此方法中可以将之前记录的value的StringBuilder转换为字符串,并将其填入对象中
     * @param uri
     * @param localName
     * @param qName
     * @throws SAXException
     */
    @Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        // 获取person类的所有属性
        // 判断当前结束的节点是否为person中的一个属性
        Class<Person> personClass = Person.class;
        Set<String> collect = Arrays.stream(personClass.getDeclaredFields()).map(Field::getName).collect(Collectors.toSet());
        if(!collect.contains(qName)){
            // 如果是person标签,则将当前的person对象加入列表
            if(PERSON_TAG.equals(qName)){
                personList.add(p);
            }
            // 如果不是person中的属性返回即可
            return;
        }
        // 将sb转为string
        String value = currentValueStringBuilder.toString();
        try {
            // 反射赋值操作
            // 获取person中的当前字段
            Field declaredField = personClass.getDeclaredField(qName);
            declaredField.setAccessible(true);
            // 获取该字段类型的、以string作为参数的构造器
            final Constructor<?> constructor = declaredField.getType().getConstructor(String.class);
            // 创建一个该类型的值并赋予该字段
            declaredField.set(p,constructor.newInstance(value));
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void endDocument() throws SAXException {
        super.endDocument();
    }

    public static void main(String[] args) throws IOException, SAXException, ParserConfigurationException {
        // 加载文件返回文件的输入流
        InputStream is = new FileInputStream(Paths.get(".\\demo\\src\\main\\resources\\person.xml").toFile());
        // 创建一个解析器
        MySaxHandler mySaxHandler = new MySaxHandler();
        // SAX解析工厂
        SAXParserFactory saxParserFactory = SAXParserFactory.newInstance();
        // 让工厂生产一个sax解析器
        SAXParser newSAXParser = saxParserFactory.newSAXParser();
        // 传入输入流和handler解析
        newSAXParser.parse(is, mySaxHandler);
        is.close();
        System.out.println(mySaxHandler.personList);

    }
}

```

