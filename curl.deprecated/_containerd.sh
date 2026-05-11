apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
apt update && \
apt install -y containerd.io && \
curl -L https://github.com/containerd/containerd/releases/download/v1.7.3/containerd-1.7.3-linux-amd64.tar.gz -o containerd-1.7.3-linux-amd64.tar.gz && \
tar xvf containerd-1.7.3-linux-amd64.tar.gz && \
mv bin/* /usr/local/bin/ && \
containerd config default | tee /etc/apt/trusted.gpg.d/docker.gpg >/dev/null 2>&1 && \
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/apt/trusted.gpg.d/docker.gpg && \
systemctl restart containerd 
systemctl enable containerd 
