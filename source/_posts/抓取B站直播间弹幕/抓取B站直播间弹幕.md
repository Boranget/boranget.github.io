---
title: 抓取B站直播间弹幕
date: 2026-01-7 10:35:19
updated: 2026-01-7 10:35:19
tags:
  - bilibili
categories:
  - 笔记
---

# 参考资料

# 代码

```python
import time
import json
from bilibili_api import live, sync
from PIL import Image, ImageDraw, ImageFont

# ===================== 唯一需要修改的配置 =====================
ROOM_ID = 1917432364  # 你的直播间房号，不用改
# =============================================================

MAX_DM_NUM = 10   # 最多显示10条弹幕
FONT_SIZE = 16    # 字体大小
IMG_PATH = "./dm_show.png"  # 弹幕图片路径
FONT_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"

# 全局弹幕列表
dm_list = []

# 初始化空白图片
def init_img():
    img = Image.new("RGB", (640, 480), color=(0, 0, 0))
    draw = ImageDraw.Draw(img)
    try:
        font = ImageFont.truetype(FONT_PATH, FONT_SIZE)
    except:
        font = ImageFont.load_default()
    draw.text((10, 200), "等待观众发弹幕...", font=font, fill=(255, 255, 255))
    img.save(IMG_PATH)
    print("✅ 空白弹幕图片初始化完成！")

# 更新弹幕图片
def update_dm_img():
    global dm_list
    img = Image.new("RGB", (640, 480), color=(0, 0, 0))
    draw = ImageDraw.Draw(img)
    try:
        font = ImageFont.truetype(FONT_PATH, FONT_SIZE)
    except:
        font = ImageFont.load_default()
    # 拼接弹幕（带序号，更清晰）
    dm_text = "\n".join([f"{i+1}. {dm}" for i, dm in enumerate(dm_list)])
    draw.text((10, 10), dm_text, font=font, fill=(255, 255, 255))
    img.save(IMG_PATH)
    print(f"🔄 更新弹幕图片：共{len(dm_list)}条弹幕")

# 兼容所有弹幕格式的监听函数
def on_message(event):
    global dm_list
    try:
        # 解析B站推送的原始数据
        data = event["data"]
        if "cmd" not in data:
            return

        # 只处理弹幕消息（DANMU_MSG）
        if data["cmd"] == "DANMU_MSG":
            # 提取弹幕内容（兼容新旧格式）
            if "info" in data and len(data["info"]) >= 2:
                dm_content = data["info"][1].strip()
            elif "content" in data.get("data", {}):
                dm_content = data["data"]["content"].strip()
            else:
                print(f"⚠️  无法解析弹幕数据：{json.dumps(data, ensure_ascii=False)}")
                return

            if dm_content:
                # 添加最新弹幕，保留10条
                dm_list.insert(0, dm_content)
                if len(dm_list) > MAX_DM_NUM:
                    dm_list.pop()
                # 更新图片
                update_dm_img()
                print(f"📥 捕获弹幕：{dm_content}")
    except Exception as e:
        print(f"❌ 处理弹幕出错：{e}")

# 主函数
def main():
    init_img()
    # 初始化直播间（用更兼容的方式连接）
    room = live.LiveDanmaku(ROOM_ID)
    # 监听所有消息（而非仅DANMAKU事件），兼容B站推送规则
    room.add_event_listener("ALL", on_message)
    print(f"📡 开始监听B站直播间 {ROOM_ID} 弹幕（兼容匿名模式）...")
    print("💡 提示：用非主播账号发弹幕测试（如 123/测试）！")
    try:
        sync(room.connect())
    except KeyboardInterrupt:
        print("\n🛑 停止监听弹幕")
    except Exception as e:
        print(f"\n❌ 连接出错：{e}")

if __name__ == "__main__":
    main()

```

