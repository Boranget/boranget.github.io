---
title: powershell
date: 2024-09-12 15:58:19
updated: 2024-09-12 15:58:19
tags:
  - powershell
categories:
  - experience
---

# Powershell后缀

powershell文件后缀为`*.ps1`

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

# 发送请求

```
echo "mantain wifi"
if ( Test-Connection -ComputerName  www.baidu.comnn -Quiet ){
	echo "test ok"
}else{
	echo "test fail, begin connect"
	$body = 'url=https%3A%2F%2Fwww.hand-china.com&opcode=cp_auth&user=1&password=1'
	$uri = 'http://securelogin.arubanetworks.com/auth/index.html/u'
	 try {
        # 将 MaximumRedirection 设置为 0 以完全禁止重定向
        $Response = Invoke-WebRequest -Method Post -Uri $uri -Body $body -MaximumRedirection 0
    } catch {
        # 捕获并处理 Invoke-WebRequest 抛出的异常
        # Write-Error "Failed to send request: $_"
    }finally{
        
    }
}
```

# 计划任务调用ps1

在计划任务中创建基本任务，触发器可以先选择一天保存后可选择重复频率，进行的操作运行程序为`PowerShell`，参数为`-NonInteractive 脚本地址`

![image-20241108110031556](powershell/image-20241108110031556.png)