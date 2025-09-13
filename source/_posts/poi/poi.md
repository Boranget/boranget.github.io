---
title: poi
date: 2023-12-10 16:35:19
updated: 2023-12-10 16:40:19
tags:
  - poi
categories:
  - 笔记
---

# 依赖

```xml
 <!-- https://mvnrepository.com/artifact/org.apache.poi/poi-ooxml -->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>5.2.5</version>
</dependency>
```

# 从文件读入工作簿

```java
fileInputStream = new FileInputStream(frameFile);
XSSFWorkbook xssfWorkbook = new XSSFWorkbook(fileInputStream);
```

# sheet

```java
final int numberOfSheets = xssfWorkbook.getNumberOfSheets();
for (int i = 0; i < numberOfSheets; i++) {
    final XSSFSheet currentSheet = xssfWorkbook.getSheetAt(i);
}
```

# 行操作

```java
// 获取总行数，总行数为最后一个行num+1
int rowCount = currentSheet.getLastRowNum() + 1;
// 读取第一行
XSSFRow currentRow = currentSheet.getRow(0);
// 读取单元格内容
String rootName = currentRow.getCell(0).toString();
```

# 列操作

```java
// 这里不用加1
final int cellCount = currentRow.getLastCellNum();
```

# 导出行限制

老版本的excel行号限制最多65535，相应的当时的poi也有这个限制

```
java.lang.IllegalArgumentException: Invalid row number (65536) outside allowable range (0..65535)
	at org.apache.poi.hssf.usermodel.HSSFRow.setRowNum(HSSFRow.java:239)
	at org.apache.poi.hssf.usermodel.HSSFRow.<init>(HSSFRow.java:85)
	at org.apache.poi.hssf.usermodel.HSSFRow.<init>(HSSFRow.java:69)
	at org.apache.poi.hssf.usermodel.HSSFSheet.createRow(HSSFSheet.java:256)

```

新版本的excel行号限制为

> Excel 2003版：zhi列数dao最大256(IV，2的8次方)列，行数最大65536(2的16次方)行；
>
> Excel 2007版：列数最大16384(XFD，2的14次方)，行数最大1048576(2的20次方)；
>
> Excel 2013版：列数最大16384(XFD，2的14次方)，行数最大1048576(2的20次方)；

可将poi升级，使用 org.apache.poi.xssf下相应的方法