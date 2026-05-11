# all
	rm -rf ~/.* /home/e/.* /home/ubuntu/.*
	apt-get purge -y iptables* ufw* apparmor* firewall* git* unattended-upgrades &>/dev/null
	apt-get update ; apt-get install -yq apt-utils bash-completion tmux vim bsdmainutils dos2unix file jq software-properties-common tree unzip autossh # needrestart dialog
	add-apt-repository ppa:git-core/ppa
	apt-get update ; apt-get install -yq git
	apt-get autoremove -y ; dpkg -l | grep "^rc" | awk "{print\$2}" | xargs apt-get purge -y
	curl -LfsS https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc
#	echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' |tee ~/.bash_profile /home/e/.bash_profile /home/ubuntu/.bash_profile # tee -a
	for i in ~/.bash_profile /home/e/.bash_profile /home/ubuntu/.bash_profile ; do echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' > $i ; done
	echo "e ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
	echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
	echo ServerAliveInterval\ 30 >> /etc/ssh/ssh_config
	echo StrictHostKeyChecking\ no >> /etc/ssh/ssh_config
	echo TCPKeepAlive\ no >> /etc/ssh/ssh_config
	echo ForwardAgent\ yes >> /etc/ssh/ssh_config
        chown -R e:e /home/e ; chown -R ubuntu:ubuntu /home/ubuntu
#	swapoff -a ; sed -i '/ swap / s/^/#/' /etc/fstab &
	swapoff -a ; sed -i '/swap/ s/^/#/' /etc/fstab &
# vm
if uname -r | grep -Evi oracl\|wsl ; then
	echo gv\ oracle\ wsl # TS
	curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/e.authorized_keys.sh | bash & # current user(root) only # 4 vm?
	sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &
	apt-get install -yq open-vm-tools
# wsl
elif uname -r | grep -iE wsl\|Microsoft ; then
	echo g wsl # TS
	export WIN_USER=`ls /mnt/c/Users 2>/dev/null |grep -v "All\|Default\|desktop.ini\|Public\|USER\|Administrator"`
	export WIN_USER_DIR=/mnt/c/Users/$WIN_USER &>/dev/null
	export WIN_USER_DL=/mnt/c/Users/$WIN_USER/Downloads
	unzip $WIN_USER_DL/ernie-master.zip
# /root/.ssh
#       mkdir ~/.ssh /home/e/.ssh 2>/dev/null
        mkdir ~/.ssh
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
        git clone git@gitlab.com:ernie18a/dotfiles.git
        git clone git@gitlab.com:ernie18a/misc.git
        git clone https://github.com/tmux-plugins/tpm /home/e/.G/.tmux_plugins_manager
#       sed -i 's/https:\/\/gitlab.com\/ernie18a\/dotfiles.git/git@gitlab.com:ernie18a\/dotfiles.git/g' /home/e/.G/dotfiles/.git/config
        ln -snf /home/e/.G/dotfiles/home/.bash_profile /home/e/.bash_profile
        ln -snf /home/e/.G/dotfiles/home/.gitconfig /home/e/.gitconfig
        ln -snf /home/e/.G/dotfiles/home/.tmux.conf /home/e/.tmux.conf
        ln -snf /home/e/.G/dotfiles/home/.vimrc /home/e/.vimrc
        chown -R e:e /home/e
        cat /home/e/.G/dotfiles/home/.hyper.js > $WIN_USER_DIR/AppData/Roaming/Hyper/.hyper.js 2>/dev/null
# python
	apt-get purge -y libpython* python* &>/dev/null
fi
