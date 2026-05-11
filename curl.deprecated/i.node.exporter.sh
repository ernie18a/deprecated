# mkdir /tmp/.node_exporter
# wget $(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest  |grep browser_download_url.*linux-amd |awk "{print\$2}" |sed "s/\"//g") -P/tmp/.node_exporter
# tar xf /tmp/.node_exporter/* -C /tmp/.node_exporter/
# mv /tmp/.node_exporter/*/node_exporter /bin/

LC=/tmp/.node_exporter
mkdir $LC
wget $(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest  |grep browser_download_url.*linux-amd |awk "{print\$2}" |sed "s/\"//g") -P$LC
tar xf /tmp/.node_exporter/* -C$LC
mv $LC/*/node_exporter /bin/
rm -rf $LC
