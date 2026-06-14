---
title: debian11安装python3.10
date: 2026-04-12 13:46:41
updated: 2026-04-12 13:46:41
tags:
  - python
categories:
  - 笔记
---

# 参考资料

[Debian 11上安装Python 3.10，并切换系统默认Python版本 - DouSTN - 博客园](https://www.cnblogs.com/STangQL/p/15647583.html)

[Index of python-local/3.10.0](https://mirrors.huaweicloud.com/python/3.10.0/)

# 注意

- 切换版本后要用python执行而不是python3

- 可使用参考资料中的镜像地址下载python

# 流程

## 一、更新系统包并安装编译依赖环境

首先更新系统软件包，再安装 Python 源码编译必需的依赖库，这是编译安装的基础步骤。

```bash
# 更新软件包索引并升级已安装包
sudo apt update && sudo apt upgrade -y

# 安装编译依赖环境
sudo apt install wget build-essential libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev -y
```

## 二、正式安装 Python 3.10（源码编译）

### 1. 下载 Python 3.10 源码包

切换到用户主目录，下载 Python 3.10.0 官方源码包（可去 Python 官网替换为最新版本）

```bash
# 进入用户主目录
cd ~

# 下载 Python 3.10.0 源码
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
```

### 2. 解压源码包

解压下载的 `.tgz` 压缩包，会自动生成同名文件夹。

```bash
tar xzf Python-3.10.0.tgz
```

### 3. 配置编译选项

进入解压后的源码目录，执行配置命令，开启性能优化。

```bash
# 进入源码目录
cd Python-3.10.0

# 配置编译选项（开启优化）
./configure --enable-optimizations
```

- `--enable-optimizations`：开启 Python 性能优化，推荐必加
- 可选参数：`--prefix=PATH` 自定义安装路径（默认 `/usr/local`）

### 4. 编译并安装

使用 `altinstall` 安装，**避免覆盖系统默认 Python 版本**，这是关键安全操作。

```bash
make altinstall
```

### 5. 验证安装

执行命令检查 Python 3.10 是否安装成功。

```bash
python3.10
```

出现如下界面即安装完成：

```plaintext
Python 3.10.0 (default, Dec  5 2021, 22:46:09) [GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

## 三、查看已安装 Python 版本 & 路径

安装完成后，可通过命令查看系统所有 Python 版本及对应路径。

```bash
# 查看所有 Python 版本及路径
whereis python

# 查看指定版本的安装路径（示例：Python3.10）
which python3.10
```

## 四、切换默认 Python 版本

提供**单用户切换**和**系统级切换**两种方案，按需选择。

### 方案 1：单用户切换（推荐，不影响系统全局）

仅对当前用户生效，修改 `.bashrc` 配置别名即可。

1. 编辑配置文件

```bash
nano ~/.bashrc
```

1. 在文件末尾添加别名（路径替换为你的 Python3.10 实际路径）

```bash
alias python='/usr/local/bin/python3.10'
```

1. 重新加载配置文件生效

```bash
source ~/.bashrc
```

1. 验证：直接执行 `python` 即可启动 Python 3.10

------

### 方案 2：系统级切换（全局生效）

使用 `update-alternatives` 管理系统默认 Python 版本。

#### 1. 添加 Python 版本到替代列表

命令格式：`update-alternatives --install <链接> <名称> <路径> <优先级>`

- 优先级：数字越大，默认优先级越高

```bash
# 添加 Python2.7（优先级1）
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# 添加 Python3.9（优先级2）
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.9 2

# 添加 Python3.10（优先级3，最高）
sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python3.10 3
```

#### 2. 列出所有可用版本

```bash
update-alternatives --list python
```

#### 3. 手动切换版本

```bash
sudo update-alternatives --config python
```

执行后会出现选择菜单，输入对应编号即可切换：

```plaintext
有 3 个候选项可用于替换 python (提供 /usr/bin/python)。

  选择       路径                     优先级  状态
------------------------------------------------------------
* 0            /usr/local/bin/python3.10   3         自动模式
  1            /usr/bin/python2.7          1         手动模式
  2            /usr/bin/python3.9          2         手动模式
  3            /usr/local/bin/python3.10   3         手动模式

要维持当前值[*]请按<回车键>，或者键入选择的编号：
```

#### 4. 验证切换结果

直接执行 `python` 命令，查看默认版本是否生效。

------

### 总结

1. 编译安装核心：依赖安装 → 源码下载 → 配置优化 → `make altinstall`（防覆盖）
2. 单用户切换：修改 `.bashrc` 别名，安全无风险
3. 系统级切换：`update-alternatives` 统一管理，全局生效
4. 验证命令：`python3.10`（固定调用）/ `python`（默认版本）