# for i in $(curl -s https://api.github.com/repos/containerd/containerd/releases/latest |grep browser_download_url |VE sha\|windows\|arm |AWK 2|sed "s/\"//g" ) ; do wget $i ; done
mkdir /tmp/containerd
cd /tmp/containerd
wget $(curl -s https://api.github.com/repos/containerd/containerd/releases/latest |grep browser_download_url |grep -vE cri\|sha256sum |G linux.*amd64 |awk "{print\$2}" |sed "s/\"//g")
tar xf *
cp bin/* /usr/local/
curl -fsSL https://raw.githubusercontent.com/containerd/containerd/main/containerd.service > 
