cat ~/.55H |grep "^[^#]" -B1 | grep ^#
set -euo pipefail
CONFIG_FILE="$HOME/.55H"
if [[ ! -f "$CONFIG_FILE" ]]; then
    exit 1
fi
mapfile -t all_key_lines < <(grep "export GEMINI_API_KEY=" "$CONFIG_FILE")
if [[ ${#all_key_lines[@]} -eq 0 ]]; then
    exit 1
fi
active_index=-1
for i in "${!all_key_lines[@]}"; do
    if [[ ! "${all_key_lines[$i]}" =~ ^\s*# ]]; then
        active_index=$i
        break
    fi
done
next_index=$(( (active_index + 1) % ${#all_key_lines[@]} ))
key_to_activate_line="${all_key_lines[$next_index]}"
key_value_to_activate="${key_to_activate_line##*=}"
sed -i -E 's/^(export GEMINI_API_KEY=.*)/# \1/' "$CONFIG_FILE"
sed -i -E "/${key_value_to_activate}/s/^# //" "$CONFIG_FILE"
cat ~/.55H |grep "^[^#]" -B1 | grep ^#
source ~/.bash_profile
cd -
exit 0
