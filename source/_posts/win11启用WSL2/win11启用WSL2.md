---
title: win11启用WSL2
date: 2023-10-24 10:35:19
updated: 2023-10-24 10:35:19
tags:
  - wsl
categories:
  - 经验
---

# 参考资料

[如何在 Windows 10 上安装 WSL 2 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/337104547)

# 注意

配置全程在管理员权限的powershell下运行

# 启用WSL

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

> 这段命令是在Windows系统中使用DISM（Deployment Image Servicing and Management）工具来启用Windows Subsystem for Linux (WSL)功能。下面是这段命令的详细解释：
>
> - `dism.exe`: 这是Windows系统中的Deployment Image Servicing and Management工具，用于创建、准备和部署Windows映像。
> - `/online`: 这是一个选项，指示DISM在联机模式下运行，这意味着它直接从原始系统镜像进行操作。
> - `/enable-feature`: 这是告诉DISM要启用某个Windows功能。
> - `/featurename:Microsoft-Windows-Subsystem-Linux`: 这是指示要启用的功能名称，即Windows Subsystem for Linux。
> - `/all`: 这是一个选项，指示启用所有相关的功能配置。
> - `/norestart`: 这是一个选项，指示在完成操作后不需要重新启动计算机。

# 启用“虚拟机平台”

**Windows 10（2004）**

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

>这段命令也是在Windows系统中使用DISM工具来启用一个Windows功能，这里是启用"VirtualMachinePlatform"功能。下面是这段命令的详细解释：
>
>- `dism.exe`: 这是Windows系统中的Deployment Image Servicing and Management工具。
>- `/online`: 指示DISM在联机模式下运行。
>- `/enable-feature`: 指示要启用的Windows功能。
>- `/featurename:VirtualMachinePlatform`: 这是指示要启用的功能名称，即"VirtualMachinePlatform"。这个功能允许在Windows上运行和管理虚拟机。
>- `/all`: 指示启用所有相关的功能配置。
>- `/norestart`: 指示在完成操作后不需要重新启动计算机。
>
>总的来说，这段命令的目的是启用"VirtualMachinePlatform"功能，而不需要重新启动计算机。

**Windows 10（1903，1909）**

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
```

> 这段命令是使用PowerShell来启用"VirtualMachinePlatform"这个Windows功能的。下面是这段命令的详细解释：
>
> - `Enable-WindowsOptionalFeature`: 这是PowerShell的命令，用于启用Windows的可选功能。
> - `-Online`: 这是选项，指示命令在联机模式下运行，直接对原始系统镜像进行操作。
> - `-FeatureName VirtualMachinePlatform`: 这是指示要启用的功能名称，即"VirtualMachinePlatform"。
> - `-NoRestart`: 这是选项，指示在完成操作后不需要重新启动计算机。
>
> 总的来说，这段命令的目的是启用"VirtualMachinePlatform"功能，而不需要重新启动计算机。

**虽然命令里说无需重启计算机，但实测此时还是需要先重启一次**

# 设置WSL2为默认选项

```powershell
wsl --set-default-version 2
```

# 更新到最新版

```powershell
wsl --update
```