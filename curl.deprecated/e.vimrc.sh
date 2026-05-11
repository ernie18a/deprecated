# which /usr/bin/nvim
# if [ $? == 0 ]
# then
# mkdir -p ~/.config/nvim
# echo set\ paste >> ~/.config/nvim/init.vim
# else
# echo set\ paste >> ~/.vimrc
# fi
##############################
if which /usr/bin/nvim &>/dev/null ; then
	mkdir -p ~/.config/nvim
	echo set\ paste >> ~/.config/nvim/init.vim
else
#	echo set\ paste >> ~/.vimrc
	curl -LfsS https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc
fi
