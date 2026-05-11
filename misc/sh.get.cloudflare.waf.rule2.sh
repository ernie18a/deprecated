CF_API_TOKEN="***"
BASE_URL="https://api.cloudflare.com/client/v4"
list_waf_rules() {
    local zone_id=$1
    local zone_name=$2
    echo "$zone_name (ID: $zone_id)"
    response=$(curl -s -X GET "$BASE_URL/zones/$zone_id/firewall/rules" \
                    -H "Authorization: Bearer $CF_API_TOKEN" \
                    -H "Content-Type: application/json")
    echo "$response" | jq -r '.result[] | "\(.id): \(.description) - \(.action)"'
}
page=1
while true; do
    zones=$(curl -s -X GET "$BASE_URL/zones?page=$page&results_per_page=100" \
                 -H "Authorization: Bearer $CF_API_TOKEN" \
                 -H "Content-Type: application/json")
    echo "$zones" | jq -c '.result[]' | while read -r zone; do
        zone_id=$(echo "$zone" | jq -r '.id')
        zone_name=$(echo "$zone" | jq -r '.name')
        list_waf_rules "$zone_id" "$zone_name"
    done
    total_pages=$(echo "$zones" | jq -r '.total_pages')
    current_page=$(echo "$zones" | jq -r '.current_page')
    if [ "$current_page" -eq "$total_pages" ]; then
        break
    else
        ((page++))
    fi
done
