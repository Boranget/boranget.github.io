---
title: win11启动自动打开热点
date: 2026-01-7 10:35:19
updated: 2026-01-7 10:35:19
tags:
  - win11
categories:
  - 笔记
---

# 参考资料

https://zhuanlan.zhihu.com/p/1940476356061279329

# 操作步骤

## 修改PS1策略

1. 管理员身份打开 Windows 终端 / PowerShell。
2. 执行命令：`set-executionpolicy remotesigned`。
3. 输入 `a` 确认，关闭窗口。

## 在启动中创建bat

```bat
powershell -executionpolicy remotesigned -file "%appdata%\Microsoft\Windows\Start Menu\Programs\pondsihotspot.ps1"
exit
```

## 创建供bat调用的pondsihotspot.ps1文件

```powershell
# 1. 加载核心依赖程序集
# System.Runtime.WindowsRuntime 是 .NET 与 Windows 运行时（WinRT）交互的关键桥梁
# 热点控制依赖的网络相关 API 属于 WinRT 体系，必须先加载该程序集才能调用后续 API
Add-Type -AssemblyName System.Runtime.WindowsRuntime

# 2. 筛选 WinRT 异步操作转换方法（核心铺垫）
# 目标：获取能将 WinRT 的 IAsyncOperation<T> 异步类型转换为 .NET Task<T> 的泛型 AsTask 方法
$asTaskGeneric = (
    # 从 System.WindowsRuntimeSystemExtensions 类中获取所有方法
    [System.WindowsRuntimeSystemExtensions].GetMethods() | 
    # 筛选条件：
    # - 方法名是 "AsTask"
    # - 仅包含 1 个参数
    # - 参数类型是 IAsyncOperation`1（泛型异步操作类型，`1 表示含 1 个泛型参数）
    Where-Object { 
        $_.Name -eq 'AsTask' -and 
        $_.GetParameters().Count -eq 1 -and 
        $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' 
    }
)[0]  # [0] 取筛选结果的第一个（唯一匹配的方法）

# 3. 定义处理带返回值 WinRT 异步操作的函数
# 作用：将 WinRT 异步操作（IAsyncOperation<T>）转为 .NET 同步任务，等待执行完成并返回结果
Function Await($WinRtTask, $ResultType) {
    # 基于目标结果类型，创建泛型 AsTask 方法的实例（适配具体返回类型）
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    
    # 调用 AsTask 方法，将 WinRT 异步任务转为 .NET Task
    # 第一个参数 $null：静态方法无需实例，传 null；第二个参数：传入 WinRT 异步任务作为参数
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    
    # 等待 Task 完成（-1 表示无限等待，直到操作结束，避免超时）
    # Out-Null 隐藏等待过程的输出信息，仅静默等待
    $netTask.Wait(-1) | Out-Null
    
    # 返回异步操作的最终结果（如热点启动结果、数据等）
    $netTask.Result
}

# 4. 定义处理无返回值 WinRT 异步操作的函数
# 作用：适配无返回值的 WinRT 异步操作（IAsyncAction），仅等待执行完成
Function AwaitAction($WinRtAction) {
    # 筛选无泛型参数的 AsTask 方法（适配无返回值的异步操作）
    $asTask = (
        [System.WindowsRuntimeSystemExtensions].GetMethods() | 
        Where-Object { 
            $_.Name -eq 'AsTask' -and 
            $_.GetParameters().Count -eq 1 -and 
            !$_.IsGenericMethod  # 非泛型方法（无返回值场景）
        }
    )[0]
    
    # 将无返回值的 WinRT 异步操作转为 .NET Task
    $netTask = $asTask.Invoke($null, @($WinRtAction))
    
    # 无限等待任务完成，静默无输出
    $netTask.Wait(-1) | Out-Null
}

# 5. 获取当前活跃的网络连接配置文件
# Windows.Networking.Connectivity.NetworkInformation：系统网络信息核心类（WinRT 类型）
# GetInternetConnectionProfile()：获取当前正在使用的网络连接（如 WiFi、以太网）
# 注：参数格式 [类名, 程序集名, 内容类型] 是 PowerShell 调用 WinRT 类的标准语法
$connectionProfile = [Windows.Networking.Connectivity.NetworkInformation, Windows.Networking.Connectivity, ContentType=WindowsRuntime]::GetInternetConnectionProfile()

# 6. 创建热点管理核心对象
# Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager：热点控制核心类
# CreateFromConnectionProfile()：基于当前网络连接配置，初始化热点管理器
# 后续热点的启动、状态查询等操作，均通过该对象实现
$tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager, Windows.Networking.NetworkOperators, ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile)

# 7. 检查热点状态并执行启动逻辑
# TetheringOperationalState：热点运行状态枚举（关键值说明）
# - 0: Disabled（已禁用） | 1: Enabled（已启用） | 2: Enabling（启动中） | 3: Disabling（禁用中）
if ($tetheringManager.TetheringOperationalState -eq 1) {
    # 若热点已开启，输出空字符串（无操作，避免多余控制台输出）
    ""
}
else {
    # 若热点未开启，执行启动操作
    # StartTetheringAsync()：异步启动热点（返回 IAsyncOperation<NetworkOperatorTetheringOperationResult> 类型）
    # Await 函数：等待启动异步操作完成，指定返回结果类型为热点操作结果类
    # 结果包含启动成功/失败状态码、描述信息（可用于排错）
    Await (
        $tetheringManager.StartTetheringAsync()
    ) ([Windows.Networking.NetworkOperators.NetworkOperatorTetheringOperationResult])
}
```

# 相关

直接将 .ps1 文件放入启动文件夹，可能会遇到**权限不足、执行策略拦截、运行体验差**三大核心问题。