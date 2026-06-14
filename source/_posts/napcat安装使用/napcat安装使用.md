---
title: napcat安装使用
date: 2026-04-12 18:04:07
updated: 2026-04-12 18:04:07
tags:
  - 
categories:
  - 笔记
---

# 参考资料

[Shell | NapCatQQ](https://napneko.github.io/guide/boot/Shell#napcat-installer-linux-一键使用脚本-支持ubuntu-20-debian-10-centos9)

[[BUG\] 如何完全卸载或者更新napcat · Issue #77 · NapNeko/NapCat-Installer

[[使用 Docker 部署 AstrBot | AstrBot](https://docs.astrbot.app/deploy/astrbot/docker.html)](https://github.com/NapNeko/NapCat-Installer/issues/77)

# 过程

最终是没成功，wifi棒子性能太低了，跑两个服务后ssh连接都断断续续的

# OpenStick 部署 AstrBot+NapCat 完整教程（终极稳定版）

适用设备：OpenStick 小主机（已安装 Docker、Docker Compose） 部署目标：一键启动 AstrBot（机器人本体）+ NapCat（QQ 协议端），彻底解决网络报错、镜像拉取失败、容器启动卡死等问题 核心优势：适配 OpenStick 老旧内核，绕开 iptables 限制，国内镜像秒拉取，数据持久化不丢失

## 一、前期准备（必做）

确保 OpenStick 已安装 Docker 和 Docker Compose，若未安装，先执行以下命令（直接复制）：

```bash
# 更新系统软件包
apt update && apt upgrade -y

# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# 安装 Docker Compose（自动适配版本）
apt install docker-compose-plugin -y

# 验证安装成功
docker --version
docker compose version
```

出现版本号即代表安装成功，进入下一步。

## 二、终极部署步骤（一步不差，直接复制执行）

### 步骤 1：创建工作目录并进入

```bash
mkdir -p /home/user/astrbot && cd /home/user/astrbot
```

### 步骤 2：写入适配 OpenStick 的 Compose 配置（核心！绕开网络报错）

直接复制整段命令，一键生成 astrbot.yml 配置文件（已适配 host 网络，避开 iptables 限制）：

```bash
cat > astrbot.yml << EOF
services:
  napcat:
    image: docker.1ms.run/mlikiowa/napcat-docker:latest
    container_name: napcat
    network_mode: host
    restart: always
    environment:
      - ACCOUNT=
      - TOKEN=
    volumes:
      - ./napcat/data:/app/napcat/data
      - ./napcat/config:/app/napcat/config

  astrbot:
    image: docker.1ms.run/soulter/astrbot:latest
    container_name: astrbot
    network_mode: host
    restart: always
    volumes:
      - ./astrbot:/app/data
EOF
```

### 步骤 3：配置 Docker 国内镜像源（解决镜像拉取失败）

配置国内镜像源，避免境外仓库连不上、拉取超时：

```bash
mkdir -p /etc/docker && cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": [
    "https://docker.1ms.run",
    "https://mirror.baidubce.com"
  ]
}
EOF
```

### 步骤 4：配置系统 DNS（解决域名解析失败）

写入国内公共 DNS，彻底解决「no such host」报错：

```bash
echo -e "nameserver 223.5.5.5\nnameserver 114.114.114.114" > /etc/resolv.conf
```

### 步骤 5：重启 Docker 并启动容器（最终启动）

```bash
# 重启 Docker，使镜像源、DNS 配置生效
systemctl restart docker

# 启动 AstrBot+NapCat，后台运行
docker compose -f astrbot.yml up -d
```

### 启动成功标志

执行后出现以下内容，即代表部署成功：

```bash
[+] up 4/4
 ✔ Image docker.1ms.run/soulter/astrbot:latest        Pulled
 ✔ Image docker.1ms.run/mlikiowa/napcat-docker:latest Pulled
 ✔ Container astrbot                                  Started
 ✔ Container napcat                                   Started
```

## 三、QQ 机器人登录（两步激活）

### 步骤 1：获取 QQ 登录二维码

```bash
docker logs -f napcat
```

执行后会输出二维码链接/图片，用手机 QQ 扫码登录，登录成功后按 `Ctrl+C` 退出日志查看。

### 步骤 2：验证机器人是否正常运行

```bash
docker logs -f astrbot
```

看到「连接 NapCat 成功」「机器人已就绪」等提示，即代表机器人可正常使用。

## 四、日常管理命令（收藏备用）

```bash
# 1. 查看容器运行状态
docker compose -f astrbot.yml ps

# 2. 启动机器人（已停止时使用）
docker compose -f astrbot.yml start

# 3. 停止机器人（不删除数据）
docker compose -f astrbot.yml stop

# 4. 重启机器人（配置修改后使用）
docker compose -f astrbot.yml restart

# 5. 查看实时日志（排错用）
docker compose -f astrbot.yml logs -f

# 6. 彻底删除容器（保留镜像和配置数据）
docker compose -f astrbot.yml down

# 7. 备份配置（永久保存当前环境）
mkdir -p /home/user/astrbot/config_backup && \
echo -e "========== Docker 镜像源配置 ==========\n" > /home/user/astrbot/config_backup/backup.txt && \
cat /etc/docker/daemon.json >> /home/user/astrbot/config_backup/backup.txt && \
echo -e "\n========== 系统 DNS 配置 ==========\n" >> /home/user/astrbot/config_backup/backup.txt && \
cat /etc/resolv.conf >> /home/user/astrbot/config_backup/backup.txt && \
echo -e "\n========== Compose 配置 ==========\n" >> /home/user/astrbot/config_backup/backup.txt && \
cat /home/user/astrbot/astrbot.yml >> /home/user/astrbot/config_backup/backup.txt
```

## 五、常见问题排查（避坑指南）

### 问题 1：Docker 启动失败（Job for docker.service failed）

```bash
# 修复命令（删除损坏的网络配置）
sudo service docker stop
sudo rm -rf /var/lib/docker/network
sudo service docker start
```

### 问题 2：容器启动报错（iptables: can't initialize iptables table `raw`）

无需修复 iptables，本教程的 Compose 配置已用 `network_mode: host` 绕开此问题，重新执行启动命令即可。

### 问题 3：镜像拉取超时、无法解析域名

重新执行「步骤 3（配置镜像源）」和「步骤 4（配置 DNS）」，重启 Docker 后再启动容器。

### 问题 4：容器启动后卡死（无进度）

OpenStick 性能较弱，镜像解压需 3-10 分钟，耐心等待即可；若超 15 分钟无动静，执行：

```bash
docker compose -f astrbot.yml down && docker compose -f astrbot.yml up -d
```

## 六、配置备份与恢复

### 备份

执行「日常管理命令」中的第 7 条，配置会保存到 `/home/user/astrbot/config_backup/backup.txt`，可复制到本地电脑备份。

### 恢复（设备重装/容器异常时）

重新执行本教程「二、终极部署步骤」的所有命令，即可快速恢复到当前稳定环境，无需重新配置。

## 七、核心说明

- 本教程专为 OpenStick 优化，用 `host` 网络彻底绕开老旧内核不支持 Docker 虚拟网络的问题，是 OpenStick 唯一稳定的部署方案。
- QQ 登录数据保存在 `./napcat/data`，机器人配置保存在 `./astrbot`，重启、重装容器不会丢失数据。
- 镜像源使用 `docker.1ms.run`（国内高速），无需登录即可拉取，避开官方源和其他镜像源的访问限制。
- 官方文档中的 `docker run` 命令仅启动 AstrBot 本体，缺少 NapCat QQ 协议端，无法登录 QQ，不适合本设备使用。

