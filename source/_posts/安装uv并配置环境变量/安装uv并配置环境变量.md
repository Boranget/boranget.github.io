---
title: 安装uv并配置环境变量
date: 2026-04-12 13:54:01
updated: 2026-04-12 13:54:01
tags:
  - uv
categories:
  - 笔记
---

# 参考资料

[Installation | uv](https://docs.astral.sh/uv/getting-started/installation/#standalone-installer)

# 安装

```
curl -LsSf https://astral.sh/uv/install.sh | sh
```

# 配置

### 一、先确认 uv 是否真的安装成功

uv 默认安装到：`~/.local/bin/uv` 或 `~/.cargo/bin/uv`，先检查文件是否存在：

```bash
# 检查两个常见路径
ls ~/.local/bin/uv
ls ~/.cargo/bin/uv
```

只要其中一个有输出，说明安装成功，只是**PATH 没生效**；如果都没有，重新运行安装脚本。

### 二、立即生效（临时解决，当前终端可用）

```bash
# 把uv所在目录加入当前会话PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
# 验证
uv --version
```

### 三、永久配置（重启终端也生效）

#### 1. 确定你的 shell（bash/zsh）

```bash
echo $SHELL
```

- 输出 `/bin/bash` → 改 `~/.bashrc`
- 输出 `/bin/zsh` → 改 `~/.zshrc`

#### 2. 写入 PATH 配置

```bash
# bash用户
echo 'export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# zsh用户
echo 'export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### 3. 重启终端 / 新开窗口（最稳妥）

关闭当前终端，重新打开，再执行：

```bash
uv --version
```

### 四、如果还是不行（排查进阶）

1. 检查是否用了

   ```
   UV_NO_MODIFY_PATH=1
   ```

   安装（禁用自动改 PATH）：

   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

   重新运行

   不带环境变量

   的安装脚本，让它自动配置 PATH。

2. 系统级权限问题（不推荐，除非必须）：

   ```bash
   sudo ln -s ~/.local/bin/uv /usr/local/bin/uv
   ```