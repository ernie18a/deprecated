container_info=$(crictl ps -a | awk "{print \$1, \$7}")
while read -r container_id container_name; do
    crictl logs "$container_id" &> "${container_name}.log"
done <<< "$container_info"
