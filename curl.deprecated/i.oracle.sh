# apt
	apt-get purge -y iptables* ufw* vim* # apparmor* python*
	systemctl disable snapd.apparmor.service apparmor.service
	apt-get update ; apt list > .APT
	apt-get install -y rsync language-pack-en apt-utils neovim dialog tmux python3-pip python3-dev ffmpeg bash-completion git
# ssh
	echo ServerAliveInterval\ 30 >> /etc/ssh/ssh_config
	echo StrictHostKeyChecking\ no >> /etc/ssh/ssh_config
# transmission
	echo '* soft nofile 10240' >> /etc/security/limits.conf
	echo '* hard nofile 10240' >> /etc/security/limits.conf
# shadowsocks-libev
# root.rc
	echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' >> ~/.bashrc
	mkdir -p ~/.config/nvim ; 
	echo set\ paste > ~/.config/nvim/init.vim
# others.rc
	for i in $(ls /home/) ; 
	do mkdir -p $i/.config/nvim ; 
	echo set\ paste > $i/.config/nvim/init.vim ; 
	echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' >> $i/.bashrc
	done
reboot
