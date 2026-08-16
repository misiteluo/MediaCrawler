#!/usr/bin/env bash

set -euo pipefail

# 抖音创作者主页采集及媒体下载脚本（macOS）
#
# 使用前准备：
# 1. 在项目根目录执行 `uv sync` 安装 Python 依赖，并确保 Node.js >= 16。
# 2. 默认 CDP 模式需要在 Chrome 中打开 chrome://inspect/#remote-debugging，
#    开启 "Allow remote debugging for this browser instance"，并提前登录抖音。
# 3. 将下面 CREATOR_URL 修改为目标创作者主页的完整链接，也可以填写 sec_user_id。
# 4. CREATOR_DATA_ROOT 设置本次采集的独立保存根目录。
#
# 需要在 config/base_config.py 中确认：
# - ENABLE_GET_MEIDAS = True：下载视频和图文图片；False 只采集结构化信息。
# - ENABLE_GET_COMMENTS：是否采集一级评论。本脚本传入 --get_comment false，会覆盖该配置；如需评论，将脚本参数改为 true。
# - ENABLE_GET_SUB_COMMENTS：是否采集二级评论；不需要时保持 False。
# - CRAWLER_MAX_COMMENTS_COUNT_SINGLENOTES：每个作品最多采集的一级评论数。
# - CRAWLER_MAX_SLEEP_SEC：请求及媒体下载间隔秒数，建议设为 3 或更大。
# - SAVE_DATA_OPTION：结构化数据保存格式。本脚本未传该参数，因此使用此配置。
# - ENABLE_CDP_MODE：True 使用本机 Chrome；False 使用 Playwright 浏览器。
# - CDP_CONNECT_EXISTING：True 连接已开启远程调试的 Chrome。
# - CDP_DEBUG_PORT：Chrome 远程调试端口，默认 9222。
#
# 保存结构：
# CREATOR_DATA_ROOT/douyin/videos/<作品ID>_video.mp4
# CREATOR_DATA_ROOT/douyin/images/<作品ID>_000.jpeg
# CREATOR_DATA_ROOT/douyin/jsonl/creator_contents_<日期>.jsonl（默认 JSONL）
#
# 创作者模式会持续翻页，直到没有更多当前账号可访问的公开作品。

CREATOR_URL="https://www.douyin.com/user/示例SEC_USER_ID"
CREATOR_DATA_ROOT="data/douyin/创作者名称"

uv run main.py \
  --platform dy \
  --lt qrcode \
  --type creator \
  --creator_id "$CREATOR_URL" \
  --save_data_path "$CREATOR_DATA_ROOT" \
  --crawler_max_notes_count 999999 \
  --get_comment false \
  --max_concurrency_num 1
