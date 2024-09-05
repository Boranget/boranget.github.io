---
title: vbs脚本
date: 2024-09-04 16:35:19
updated: 2024-09-04 16:35:19
tags:
  - vbs
categories:
  - notes
---

# 使用vbs批量替换文件内容

其中使用到了正则表达式进行搜索

```vbscript
Const ForReading = 1
Const ForWriting = 2

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set folder = objFSO.GetFolder("E:\test\vbtest\testdir")

i = 0

for each file in folder.Files

if lcase(objFSO.getExtensionName(file.path))="xml" then
i=i+1
Set objFile = objFSO.OpenTextFile(file.path, ForReading)

strOriginal = "<a>[^<]*</a>"
strReplacement = "<a>12345</a>"

strText = objFile.ReadAll
objFile.Close

Set objRegExp = New RegExp
objRegExp.Global = True
objRegExp.IgnoreCase = False
objRegExp.Pattern = strOriginal
strReplacement = objRegExp.Replace(strText, strReplacement)

Set objFile = objFSO.OpenTextFile(file.path, ForWriting)
objFile.WriteLine strReplacement
objFile.Close

WScript.Echo file.path
WScript.Echo i
End if

next
WScript.Echo "done"
```

# 将vbs的echo输出到控制台

在命令行中使用CScript执行

```
CScript .\replace.vbs
```

