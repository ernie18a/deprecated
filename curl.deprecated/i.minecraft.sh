# CDZ && CMC
ls -a ~ |grep -v "ssh$\|.kube$\|.MC.SERVER" |xargs rm -rf
echo ' source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)" ' > ~/.bash_profile
sudo usermod  -aGroot $(whoami)
sudo apt-get update
sudo apt-get install -y apt-utils
sudo apt-get purge -y apparmor* iptable* ufw* && sudo reboot
sudo apt-get install -y vim bash-completion tmux glances
mkdir ~/.MC.SERVER
wget https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar -P ~/.MC.SERVER
#
echo 'java -Xmx896M -Xms896M -jar server.jar nogui' > ~/.MC.SERVER/run.sh
#
echo 'eula=true' > ~/.MC.SERVER/eula.txt
#
# swap
sudo dd if=/dev/zero of=/MYSWAP bs=1M count=4096
sudo mkswap /MYSWAP
sudo swapon /MYSWAP
sudo echo '/MYSWAP none swap sw 0 0' >> /etc/fstab
# openjdk-8-jre-headless
# openjdk-14-jre-headless
# ls |grep -v "server.jar\|run.sh\|eula.txt\|server.properties" |xargs rm -rf
