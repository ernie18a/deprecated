# misc
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
 	swapoff -a ; sed -i '/ swap / s/^/#/' /etc/fstab
# iptables
	ip6tables -F
	ip6tables -P FORWARD ACCEPT
	ip6tables -P INPUT ACCEPT
	ip6tables -P OUTPUT ACCEPT
	ip6tables -t mangle -F
	ip6tables -t nat -F
	ip6tables -X
	iptables -F
	iptables -P FORWARD ACCEPT
	iptables -P INPUT ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -t mangle -F
	iptables -t nat -F
	iptables -X
	iptables-save > /etc/sysconfig/iptables
# yum
	yum install -y yum-utils
	yum remove -y iptables* firewall*
	yum install -y vim bash-completion tmux tree wget open-vm-tools iproute-tc git
	yum autoremove -y
	yum update -y
	yum upgrade -y
#	yum install -y vim podman python3-pip bash-completion mlocate tmux tree wget podman-docker
#	pip3 install podman-compose
#	ln -s /usr/local/bin/podman-compose /bin/docker-compose
#	ln -s /bin/podman  /bin/docker
# personal
#	ls -a ~ |grep -v "ssh$\|.bash_profile" |xargs rm -rf
	curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc 
	curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/e.id_rsa.pub.sh | bash
	echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' >> ~/.bashrc
	curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/.sbin/ccat -o /bin/ccat ;  chmod +x /bin/ccat
# reboot
	reboot
