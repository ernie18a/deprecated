# install golang
	apt-get remove -y golang*
	apt-get update
	apt-get install -y apt-transport-https curl
        add-apt-repository ppa:longsleep/golang-backports
        apt update
        apt install -y golang-go
