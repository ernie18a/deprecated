	rm -rf $(which docker-compose)
	curl -Ls https://get.docker.com | bash
	curl -s https://api.github.com/repos/docker/compose/releases/latest |grep browser_download_url |grep linux.*$(uname -m)\" |awk "{print\$2}" |xargs wget -O /bin/docker-compose
	chmod 0755 /bin/docker-compose
	for i in $(ls /home/) ;	do usermod -aG docker $i ; done
	systemctl restart docker docker.socket
	systemctl enable docker docker.socket
	docker completion bash > /etc/bash_completion.d/docker 1>/dev/null
