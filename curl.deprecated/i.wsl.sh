# export
	export WIN_USER=`ls /mnt/c/Users 2>/dev/null |grep -v "All\|Default\|desktop.ini\|Public\|USER\|Administrator"`
	export WIN_USER_DIR=/mnt/c/Users/$WIN_USER &>/dev/null
	export WIN_USER_DL=/mnt/c/Users/$WIN_USER/Downloads
	apt-get update ; apt-get install -y tree sshpass unzip git dos2unix
	mkdir ~/.BACKUP
	ls -a ~ |grep -v  "ssh$\|.BACKUP" | xargs -I{} mv  -u {} ~/.BACKUP
	echo "e ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
	echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' >> ~/.bash_profile
	echo ServerAliveInterval\ 30 >> /etc/ssh/ssh_config
	echo StrictHostKeyChecking\ no >> /etc/ssh/ssh_config
	echo TCPKeepAlive\ no >> /etc/ssh/ssh_config
#	curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc
	swapoff -a ; sed -i '/ swap / s/^/#/' /etc/fstab
	unzip  $WIN_USER_DL/ernie-master.zip
# /root/.ssh
	mkdir ~/.ssh 2>/dev/null
	cat ernie-master/.ssh/id_rsa > ~/.ssh/id_rsa
	cat ernie-master/.ssh/id_rsa.pub > ~/.ssh/id_rsa.pub
	chmod 0700 ~/.ssh
	chmod 0600 ~/.ssh/id_rsa
	chmod 0644 ~/.ssh/id_rsa.pub
# /home/e/.ssh
	cp -rf ~/.ssh /home/e/.ssh
	chmod 0700 /home/e/.ssh
	chmod 0600 /home/e/.ssh/id_rsa
	chmod 0644 /home/e/.ssh/id_rsa.pub
# git @ /home/e/
	mkdir /home/e/.G/
	cd /home/e/.G/
	git clone https://github.com/tmux-plugins/tpm /home/e/.G/.tmux_plugins_manager
	git clone https://gitlab.com/ernie18a/dotfiles.git
	git clone git@gitlab.com:ernie18a/misc.git
	sed -i 's/https:\/\/gitlab.com\/ernie18a\/dotfiles.git/git@gitlab.com:ernie18a\/dotfiles.git/g' /home/e/.G/dotfiles/.git/config
	ln -sn /home/e/.G/dotfiles/home/.bash_profile /home/e/.bash_profile
#	ln -sn /home/e/.G/dotfiles/home/.bash_profile /home/e/.bashrc
#	ln -sn ~/.G/dotfiles/home/.bash_profile /home/e/.profile
	ln -sn /home/e/.G/dotfiles/home/.gitconfig /home/e/.gitconfig
	ln -sn /home/e/.G/dotfiles/home/.gitignore /home/e/.gitignore
	ln -sn /home/e/.G/dotfiles/home/.tmux.conf /home/e/.tmux.conf
	ln -sn /home/e/.G/dotfiles/home/.vimrc ~/.vimrc
	ls $WIN_USER_DIR/AppData/Roaming/Hyper/.hyper.js && cat /home/e/.G/dotfiles/home/.hyper.js > $WIN_USER_DIR/AppData/Roaming/Hyper/.hyper.js 2>/dev/null
	chown -R e:e /home/e
