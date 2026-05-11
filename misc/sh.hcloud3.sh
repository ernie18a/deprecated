input=$(cat ./key.huawei)
echo y | hcloud configure clear
echo y | hcloud configure delete                      
while IFS= read -r line; do
  AK=$(echo $line | awk '{print $1}')
  SK=$(echo $line | awk '{print $2}')
  CLIENT=$(echo $line | awk '{print $3}' | awk -F.ops '{print $1}')
  export AK=$AK
  export SK=$SK
  echo $CLIENT
echo y | hcloud configure clear
echo y | hcloud configure delete                      
hcloud configure set  --cli-access-key=$AK --cli-secret-key=$SK --cli-region=ap-southeast-1
echo y | hcloud ECS NovaListServers |grep id\" >ecs.$CLIENT
done <<< "$input"
