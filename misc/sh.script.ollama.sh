# bash b.sh ' how to become rich? '
query="$1"  # 從命令行參數獲取查詢
if [ -z "$query" ]; then
    echo "Usage: ./a.sh 'your question here'"
    exit 1
fi
curl -s "http://localhost:11434/api/generate" \
    -H "Content-Type: application/json" \
    -d "{\"model\": \"deepseek-r1:1.5b\", \"prompt\": \"$query\", \"stream\": false}" | jq -r '.response'
