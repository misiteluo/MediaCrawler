#!/usr/bin/env bash

set -euo pipefail

# 微博创作者主页采集及图片下载脚本（macOS）
#
# 使用前准备：
# 1. 在项目根目录执行 `uv sync` 安装 Python 依赖。
# 2. 默认 CDP 模式需要在 Chrome 中打开 chrome://inspect/#remote-debugging，
#    开启 "Allow remote debugging for this browser instance"，并提前登录微博。
# 3. 将下面 WEIBO_CREATOR_ID 修改为目标创作者的微博数字用户 ID。
#    例如主页为 https://weibo.com/u/5756404150，用户 ID 就是 5756404150。
# 4. WEIBO_DATA_ROOT 设置本次采集的独立保存根目录。
#
# 需要在 config/base_config.py 中确认：
# - ENABLE_GET_MEIDAS = True：下载微博图片；False 只采集结构化信息。
# - ENABLE_GET_COMMENTS：是否采集一级评论。本脚本传入 --get_comment false，会覆盖该配置；如需评论，将脚本参数改为 true。
# - ENABLE_GET_SUB_COMMENTS：是否采集二级评论；不需要时保持 False。
# - CRAWLER_MAX_COMMENTS_COUNT_SINGLENOTES：每条微博最多采集的一级评论数。
# - CRAWLER_MAX_SLEEP_SEC：请求及图片下载间隔秒数，建议设为 3 或更大。
# - SAVE_DATA_OPTION：结构化数据保存格式。本脚本未传该参数，因此使用此配置。
# - SAVE_DATA_PATH：输出根目录；留空时图片默认保存到 data/weibo/images/。
# - ENABLE_CDP_MODE：True 使用本机 Chrome；False 使用 Playwright 浏览器。
# - CDP_CONNECT_EXISTING：True 连接已开启远程调试的 Chrome。
# - CDP_DEBUG_PORT：Chrome 远程调试端口，默认 9222。
#
# 微博专用配置 config/weibo_config.py：
# - ENABLE_WEIBO_FULL_TEXT：True 会额外请求微博全文，但可能提高触发风控的概率；
#   如果只需要图片或普通微博信息，可以设置为 False。
#
# 创作者模式会持续翻页，直到没有更多当前账号可访问的公开微博。

WEIBO_CREATOR_ID="示例微博数字用户ID"
WEIBO_DATA_ROOT="data/weibo/创作者名称"

uv run main.py \
  --platform wb \
  --lt qrcode \
  --type creator \
  --creator_id "$WEIBO_CREATOR_ID" \
  --save_data_path "$WEIBO_DATA_ROOT" \
  --get_comment false \
  --max_concurrency_num 1
