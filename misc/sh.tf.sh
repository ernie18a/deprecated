input=$(cat ./key.huawei.rest)
rm -rf ./.terraform* ./terraform.tfstate*
while IFS= read -r line; do
  AK=$(echo $line | awk '{print $1}')
  SK=$(echo $line | awk '{print $2}')
  CLIENT=$(echo $line |awk "{print\$3}" |awk -F.ops "{print\$1}" )
  export AK=$AK
  export SK=$SK
  envsubst < variables.tf.default > variables.tf
  terraform init
  terraform apply -auto-approve &> log.$CLIENT
  rm -rf ./.terraform* ./terraform.tfstate*
done <<< "$input"
