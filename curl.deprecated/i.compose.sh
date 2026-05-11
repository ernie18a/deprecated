curl -Ls https://get.docker.com | bash
curl -fsSL "https://gitlab.com/ernie18a/dotfiles/-/raw/main/.sbin/docker-compose" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
systemctl restart docker docker.socket
systemctl enable docker docker.socket
curl -fsSL https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
usermod -aG docker e
