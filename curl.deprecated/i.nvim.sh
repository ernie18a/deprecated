sudo apt-get purge -y vim* 2>/dev/null ; dpkg -l | grep "^rc" | awk "{print\$2}" | xargs sudo apt-get purge -y vim* ; sudo apt-get autoremove -y
which vim || \
sudo sh -c " curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim.appimage > /bin/vim " && \
sudo chmod 0755 /bin/vim
mkdir -p ~/.config/nvim
echo set\ paste > ~/.config/nvim/init.vim
