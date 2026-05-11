input=$(cat ./key.huawei)
while IFS= read -r line; do
  AK=$(echo $line | awk '{print $1}')
  SK=$(echo $line | awk '{print $2}')
  CLIENT=$(echo $line | awk '{print $3}' | awk -F.ops '{print $1}')
  export AK=$AK
  export SK=$SK
  envsubst < variables.tf.default > variables.tf
  echo "Processing client: $CLIENT" &> log.$CLIENT
  hcloud configure set --cli-access-key=$AK --cli-secret-key=$SK --cli-region=ap-southeast-1 &>> log.$CLIENT
done <<< "$input"
