if uname -r |grep ^3 &>/dev/null
then
# swapoff
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	swapoff -a ; sed -i '/ swap / s/^/#/' /etc/fstab
# repo
	yum remove -y container* cri* docker* docker-ce docker-ce-cli firewall* git* iptable* kernel* kube* kubectl
	yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm https://repo.ius.io/ius-release-el7.rpm https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
	yum install -y yum-utils
	yum-config-manager --enable elrepo-kernel && yum install kernel-ml-devel kernel-ml-headers kernel-ml-tools kernel-ml -y && grub2-mkconfig  -o /etc/grub2.cfg && grub2-set-default 0 && reboot
#	yum-config-manager --enable elrepo-kernel remi # redis
# else
fi

yum list |grep mlocate.*@ &>/dev/null
if ! [ 0 == 2 ]
then
	yum remove -y kernel
	yum update -y
	yum install -y bash-completion bash-completion-extras cargo curl git2cl glances golang iproute mlocate nmap sshpass tmux tree vim-common vim-enhanced wget yum-utils NetworkManager-tui
# ccat
	mkdir ~/.GO
	export GOPATH=~/.GO
	go get -u github.com/owenthereal/ccat
	sudo cp ~/.GO/bin/ccat /bin/
fi
curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc
git clone https://github.com/tmux-plugins/tpm ~/.G/.tmux_plugins_manager
