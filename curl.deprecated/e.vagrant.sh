# should i remove this pc of shht?
	curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/e.id_rsa.pub.sh | bash 
	echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' >> ~/.bash_profile
	echo 'touch ~/.hushlogin' >> ~/.bash_profile
# ls /home/vagrant
	ls /home/vagrant &>/dev/null && echo 'ip a |grep -iE --color "([0-9]{1,3}[\.]){3}[0-9]{1,3}"'  >> /home/vagrant/.bash_profile
	ls /home/vagrant &>/dev/null && echo 'sudo su -'>> /home/vagrant/.bash_profile
	ls /home/vagrant &>/dev/null && echo 'touch ~/.hushlogin' >> /home/vagrant/.bash_profile
#	echo 'ip a |grep -iE --color "([0-9]{1,3}[\.]){3}[0-9]{1,3}"' >> ~/.bash_profile
#	ls /home/vagrant && echo 'curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc' >> /home/vagrant/.bash_profile
#	ls /home/vagrant && echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' >> /home/vagrant/.bash_profile
#	echo 'curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc' >> ~/.bash_profile

