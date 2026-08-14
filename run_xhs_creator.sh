#!/usr/bin/env bash

set -euo pipefail

# 小红书创作者主页采集脚本（macOS）
#
# 使用前准备：
# 1. 在项目根目录执行 `uv sync` 安装 Python 依赖。
# 2. 默认 CDP 模式需要在 Chrome 中打开 chrome://inspect/#remote-debugging，
#    开启 "Allow remote debugging for this browser instance"，并提前登录小红书。
# 3. 将下面 CREATOR_URL 修改为目标创作者主页的完整链接，尽量保留
#    xsec_token 和 xsec_source 参数。
# 4. CREATOR_DATA_ROOT 设置本次采集的独立保存根目录。
#
# 可按需求修改 config/base_config.py：
# - ENABLE_GET_MEIDAS：True 下载笔记图片和视频；False 只采集结构化信息。
# - ENABLE_GET_COMMENTS：是否采集一级评论。本脚本传入 --get_comment false，会覆盖该配置；如需评论，将脚本参数改为 true。
# - ENABLE_GET_SUB_COMMENTS：是否采集二级评论；不需要时保持 False。
# - CRAWLER_MAX_COMMENTS_COUNT_SINGLENOTES：每篇笔记最多采集的一级评论数。
# - CRAWLER_MAX_SLEEP_SEC：翻页请求间隔秒数，建议设为 3 或更大。
# - SAVE_DATA_OPTION：默认保存格式。本脚本未传该参数，因此使用此配置。
# - SAVE_DATA_PATH：输出根目录；留空时数据默认保存到 data/xhs/。
# - ENABLE_CDP_MODE：True 使用本机 Chrome；False 使用 Playwright 浏览器。
# - CDP_CONNECT_EXISTING：True 连接已开启远程调试的 Chrome。
# - CDP_DEBUG_PORT：Chrome 远程调试端口，默认 9222。
#
# 注意：--crawler_max_notes_count 999999 只是设置一个足够大的上限；
# 当创作者主页没有更多可访问的公开笔记时，程序会自动停止。

CREATOR_URL="https://www.xiaohongshu.com/user/profile/示例用户ID?xsec_token=示例TOKEN&xsec_source=pc_search"
CREATOR_DATA_ROOT="data/xhs/创作者名称"

uv run main.py \
  --platform xhs \
  --lt qrcode \
  --type creator \
  --creator_id "$CREATOR_URL" \
  --save_data_path "$CREATOR_DATA_ROOT" \
  --crawler_max_notes_count 999999 \
  --get_comment false \
  --max_concurrency_num 1
