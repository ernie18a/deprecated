for dir in ~/*/; do
  if [[ -f "${dir}enius-art/enius-art/docker-compose.yml" ]]; then
    echo "Stopping docker-compose in ${dir}enius-art/enius-art"
    sudo docker-compose -f "${dir}genius-cart-stage/enius-art/docker-compose.yml" down
  fi
done
