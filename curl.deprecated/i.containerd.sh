# apt remove
	for pkg in golang* podman* docker* docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get -y remove $pkg; done
# containerd
	curl -s https://api.github.com/repos/containerd/containerd/releases/latest |grep browser_download_url | grep -E -v cri\|static\|sha256sum |grep linux-amd64 |awk "{print\$2}" | xargs curl -fsSL | tar -C /tmp/ -xzf -
	mv -f /tmp/bin/* /bin/
	apt update ; apt install -y libc6
# serivice
	cat << EOF > /lib/systemd/system/containerd.service
	[Unit]
	Description=containerd container runtime
	Documentation=https://containerd.io
	After=network.target local-fs.target
	[Service]
	ExecStartPre=-/sbin/modprobe overlay
	ExecStart=/usr/bin/containerd
	Type=notify
	Delegate=yes
	KillMode=process
	Restart=always
	RestartSec=5
	LimitNPROC=infinity
	LimitCORE=infinity
	LimitNOFILE=infinity
	TasksMax=infinity
	OOMScoreAdjust=-999
	[Install]
	WantedBy=multi-user.target
EOF
# golang
	apt-get update
	apt-get install -y apt-transport-https curl
        add-apt-repository ppa:longsleep/golang-backports
        apt update
        apt install -y golang-go
# runc
	go install github.com/opencontainers/runc@latest
# containernetworking-plugins
	cd /tmp
	git clone https://github.com/containernetworking/plugins.git
	cd plugins
	./build_linux.sh
	mkdir -p /opt/cni/bin
	cp bin/* /opt/cni/bin/
# systemctl
	sysctl --system
	systemctl daemon-reload
	systemctl enable containerd
	systemctl restart containerd
