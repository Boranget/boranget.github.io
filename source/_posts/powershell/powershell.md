---
title: powershell
date: 2024-09-12 15:58:19
updated: 2024-09-12 15:58:19
tags:
  - powershell
categories:
  - experience
---

# 批量重命名文件

`-replace`可使用正则表达式

注意必须使用单引号

```powershell
Get-ChildItem -Filter "*.txt" -File | ForEach-Object{
    $newname = $_.Name -replace '-(.*)-', '$1'
    Rename-Item $_.FullName $newname
}
```

# 统计

## 统计行数

`Measure-Object -Line`

```
ls|findstr "cgr" |Measure-Object -Line
```

## 统计字符数

`Measure-Object -Character`

## 字数

`Measure-Object -Word`

# 获取文件内容

`Get-Content`

```powershell
Get-Content .\pom.xml
```

