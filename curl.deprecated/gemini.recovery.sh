#!/bin/bash

# =================================================================
# 1. 設定區域 (User Configuration)
# =================================================================
RECOVERY_SOURCE_DIR="/tmp"
GEMINI_DIR="$HOME/.gemini"

# =================================================================
# 2. 核心邏輯 (Fail Fast)
# =================================================================
set -euo pipefail

PREFIX=${1:-""}
if [ -z "$PREFIX" ]; then
    echo "錯誤: 請指定 Prefix (例如: bash $0 oo)"
    exit 1
fi

# 定義檔案路徑
SRC_OAUTH="$RECOVERY_SOURCE_DIR/$PREFIX.oauth_creds.json"
SRC_ACCOUNTS="$RECOVERY_SOURCE_DIR/$PREFIX.google_accounts.json"
SRC_TMP_DATA="$RECOVERY_SOURCE_DIR/$PREFIX.tmp" # 假設歷史紀錄備份在這個資料夾

echo "--- 準備合併還原 Prefix: [$PREFIX] ---"

# [Step 1] 驗證憑證是否存在
if [[ ! -f "$SRC_OAUTH" || ! -f "$SRC_ACCOUNTS" ]]; then
    echo "錯誤: 找不到憑證檔案 ($SRC_OAUTH)"
    exit 1
fi

echo "[Step 2] 清理狀態與快取 (保留 settings, GEMINI.md, 歷史數據)..."
# 這裡我們不刪除 tmp/，因為我們要疊加歷史
for item in "$GEMINI_DIR"/* "$GEMINI_DIR"/.*; do
    [ -e "$item" ] || [ -L "$item" ] || continue
    name=$(basename "$item")
    
    # 排除清單：保留設定檔、腳本本身，以及我們要疊加的 tmp 資料夾
    if [[ "$name" == "." || "$name" == ".." || \
          "$name" == "settings.json" || "$name" == "GEMINI.md" || \
          "$name" == "recovery.sh" || "$name" == "tmp" ]]; then
        continue
    fi
    rm -rf "$item"
done

echo "[Step 3] 還原目前帳號憑證 (覆寫)..."
cp "$SRC_OAUTH" "$GEMINI_DIR/oauth_creds.json"
cp "$SRC_ACCOUNTS" "$GEMINI_DIR/google_accounts.json"

# [Step 4] 歷史紀錄疊加邏輯
if [ -d "$SRC_TMP_DATA" ]; then
    echo "[Step 4] 偵測到歷史備份，開始疊加合併..."
    
    # 遍歷備份中的每個專案 (例如 aicand, app...)
    for project_path in "$SRC_TMP_DATA"/*; do
        [ -d "$project_path" ] || continue
        project_name=$(basename "$project_path")
        
        echo " > 合併專案: $project_name"
        TARGET_PROJ="$GEMINI_DIR/tmp/$project_name"
        mkdir -p "$TARGET_PROJ/chats"
        
        # A. 合併 shell_history (Append + Unique)
        if [ -f "$project_path/shell_history" ]; then
            cat "$project_path/shell_history" >> "$TARGET_PROJ/shell_history" 2>/dev/null || true
            if [ -f "$TARGET_PROJ/shell_history" ]; then
                sort -u "$TARGET_PROJ/shell_history" -o "$TARGET_PROJ/shell_history"
            fi
        fi
        
        # B. 合併 logs.json (使用 Python 處理 JSON 陣列去重)
        if [ -f "$project_path/logs.json" ]; then
            if [ -f "$TARGET_PROJ/logs.json" ]; then
                # 本地已有紀錄，進行合併
                python3 -c "
import json, sys
def merge():
    try:
        with open(sys.argv[1], 'r') as f: a = json.load(f)
        with open(sys.argv[2], 'r') as f: b = json.load(f)
        # 以 sessionId + messageId 作為 key 去重
        combined = { (i.get('sessionId'), i.get('messageId')): i for i in a }
        for i in b:
            combined[(i.get('sessionId'), i.get('messageId'))] = i
        # 依照時間排序 (如果有 timestamp 的話)
        res = sorted(combined.values(), key=lambda x: x.get('timestamp', 0))
        with open(sys.argv[1], 'w') as f: json.dump(res, f, indent=2)
    except Exception as e: print(f'Merge error: {e}')
merge()
" "$TARGET_PROJ/logs.json" "$project_path/logs.json"
            else
                # 本地無紀錄，直接拷貝
                cp "$project_path/logs.json" "$TARGET_PROJ/logs.json"
            fi
        fi
        
        # C. 合併 chats/ 目錄 (只拷貝不存在的檔案)
        if [ -d "$project_path/chats" ]; then
            cp -n "$project_path/chats"/* "$TARGET_PROJ/chats/" 2>/dev/null || true
        fi

        # D. 重建 history/ 下的專案標記，讓 CLI 認得
        mkdir -p "$GEMINI_DIR/history/$project_name"
        touch "$GEMINI_DIR/history/$project_name/.project_root"
    done
else
    echo "[Step 4] 未偵測到 $PREFIX.tmp 資料夾，跳過歷史疊加。"
fi

echo "================================================="
echo " 合併還原完成！"
echo " 目前帳號: $PREFIX"
echo " 歷史紀錄已嘗試疊加至 ~/.gemini/tmp/"
echo "================================================="
ls -A "$GEMINI_DIR"
