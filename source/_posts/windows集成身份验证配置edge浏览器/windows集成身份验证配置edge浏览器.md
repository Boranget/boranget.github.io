---
title: windows集成身份验证配置edge浏览器
date: 2023-06-26 16:50:30
updated: 2023-06-26 16:50:30
tags:
  - windows集成身份验证
  - wia
  - AD FS
categories:
  - experience
---

某系统与windows域控配置了sso，故可以使用计算机用户账号登录该系统。当前已可以使用计算机用户账号登录该系统，期望效果为打开系统登陆页面自动登录而无需手动输入用户名和密码。

# 参考资料

[配置浏览器以将 Windows 集成身份验证 (WIA) 与 AD FS 配合使用 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/identity/ad-fs/operations/configure-ad-fs-browser-wia)

# IE浏览器配置自动登录

打开IE设置菜单中的Internet选项，安全：自定义级别，滑倒最下面，在用户身份验证-登录中旋转自动使用当前用户名和密码登录。

# edge浏览器配置

系统设置Internet属性

开始菜单搜索 ”inetcpl.cpl“，打开internet属性，设置方式同IE

windows server 默认是允许IE发起自动登录请求的，edge需要在域服务器上设置下（也有可能是新版的edge需要设置）

1. 查看

   域管理员权限打开powershell，执行

   ```powershell
   Get-AdfsProperties | select -ExpandProperty WiaSupportedUserAgents
   ```

   可以查看当前支持的浏览器

   ![WIA 支持](windows集成身份验证配置edge浏览器/wiasupport.png)

   虽然结尾是.*Edge，但新版的Edge并不支持，故我猜想或许旧版的Edge浏览器是支持的

2. 添加配置

   -  Windows Server 2012 R2 或更低版本

     ```powershell
     Set-AdfsProperties -WIASupportedUserAgents @("MSIE 6.0", "MSIE 7.0; Windows NT", "MSIE 8.0", "MSIE 9.0", "MSIE 10.0; Windows NT 6", "Windows NT 6.3; Trident/7.0", "Windows NT 6.3; Win64; x64; Trident/7.0", "Windows NT 6.3; WOW64; Trident/7.0", "Windows NT 6.2; Trident/7.0", "Windows NT 6.2; Win64; x64; Trident/7.0", "Windows NT 6.2; WOW64; Trident/7.0", "Windows NT 6.1; Trident/7.0", "Windows NT 6.1; Win64; x64; Trident/7.0", "Windows NT 6.1; WOW64; Trident/7.0","Windows NT 10.0; WOW64; Trident/7.0","MSIPC", "Windows Rights Management Client", "Edg/","Edge/")
     ```

   - Windows Server 2016 或更高版本

     ```powershell
     Set-AdfsProperties -WIASupportedUserAgents @("MSIE 6.0", "MSIE 7.0; Windows NT", "MSIE 8.0", "MSIE 9.0", "MSIE 10.0; Windows NT 6", "Windows NT 6.3; Trident/7.0", "Windows NT 6.3; Win64; x64; Trident/7.0", "Windows NT 6.3; WOW64; Trident/7.0", "Windows NT 6.2; Trident/7.0", "Windows NT 6.2; Win64; x64; Trident/7.0", "Windows NT 6.2; WOW64; Trident/7.0", "Windows NT 6.1; Trident/7.0", "Windows NT 6.1; Win64; x64; Trident/7.0", "Windows NT 6.1; WOW64; Trident/7.0","Windows NT 10.0; WOW64; Trident/7.0", "MSIPC", "Windows Rights Management Client", "=~Windows\s*NT.*Edg.*")
     ```

   该操作将会添加如下配置

   | 用户代理                                                     | 用例                                                         |
   | :----------------------------------------------------------- | :----------------------------------------------------------- |
   | MSIE 6.0                                                     | IE 6.0                                                       |
   | MSIE 7.0；Windows NT                                         | IE 7、Intranet 区域中的 IE。 “Windows NT”片段由桌面操作系统发送。 |
   | MSIE 8.0                                                     | IE 8.0（没有设备发送此内容，因此需要更具体的说明）           |
   | MSIE 9.0                                                     | IE 9.0（没有设备发送此内容，因此不需要更具体的说明）         |
   | MSIE 10.0；Windows NT 6                                      | 适用于 Windows XP 和更高版本的桌面操作系统的 IE 10.0  已排除 Windows Phone 8.0 设备（首选项设置为“移动”），因为它们会发送  用户代理：Mozilla/5.0（兼容；MSIE 10.0；Windows Phone 8.0；Trident/6.0；IEMobile/10.0；ARM；Touch；NOKIA；Lumia 920） |
   | Windows NT 6.3；Trident/7.0  Windows NT 6.3；Win64；x64；Trident/7.0  Windows NT 6.3；WOW64；Trident/7.0 | Windows 8.1 桌面操作系统，不同平台                           |
   | Windows NT 6.2；Trident/7.0  Windows NT 6.2；Win64；x64；Trident/7.0  Windows NT 6.2；WOW64；Trident/7.0 | Windows 8 桌面操作系统，不同平台                             |
   | Windows NT 6.1；Trident/7.0  Windows NT 6.1；Win64；x64；Trident/7.0  Windows NT 6.1；WOW64；Trident/7.0 | Windows 7 桌面操作系统，不同平台                             |
   | Edg/ 和 Edge/                                                | 适用于 Windows Server 2012 R2 或更低版本的 Microsoft Edge (Chromium) |
   | =~Windows\s*NT.*Edg.*                                        | 适用于 Windows Server 2016 或更高版本的 Microsoft Edge (Chromium) |
   | “MSIPC”                                                      | Microsoft 信息保护和控制客户端                               |
   | Windows Rights Management 客户端                             | Windows Rights Management 客户端                             |

# 拓展

## AD

Active Directory，活动目录，是一种由微软开发的目录服务，用于在网络中存储和管理计算机、用户和其他资源的信息。管理员可以用AD创建用户并授权用户访问Windows中断、服务器和应用等。或用于控制系统组、强制执行安全设置和软件更新。

## ADFS

Windows Server的扩展功能，允许企业拓展用户的单点登录。