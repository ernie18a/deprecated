	mkdir /tmp/iso /ISO
	mount /dev/sr0 /tmp/iso
	cp -r /tmp/iso/* /ISO
	cat << EOF > /etc/yum.repos.d/ISO.repo
[dvd-BaseOS]
name=DVD for RHEL - BaseOS
baseurl=file:///ISO/BaseOS
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[dvd-AppStream]
name=DVD for RHEL - AppStream
baseurl=file:///ISO/AppStream
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF
# after repo
	yum remove -y firewall*
	sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config
	swapoff -a ; sed -i '/ swap / s/^/#/' /etc/fstab
	yum clean all
	rm -rf ~/.*
	echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' |tee ~/.bash_profile &
	curl -LfsS https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc &
	curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/e.authorized_keys.sh | bash &
	yum install -y tmux vim bash-completion
