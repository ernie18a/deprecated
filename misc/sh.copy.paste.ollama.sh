# copy paste to current session
curl -s "http://localhost:11434/api/generate" \
    -H "Content-Type: application/json" \
    -d '{"model": "deepseek-r1:1.5b", "prompt": "ubuntu reboot command", "stream": false}' | jq -r '.response'
