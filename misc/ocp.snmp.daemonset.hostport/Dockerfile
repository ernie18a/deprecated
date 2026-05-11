FROM alpine:latest
EXPOSE 161/udp
RUN apk update && \
    apk add curl bash bash-completion vim net-snmp-tools net-snmp
#   echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' > ~/.bashrc
CMD ["sh", "-c", "snmpd -f -Lf /dev/null -LnUDP:161,161 -p /var/run/snmpd.pid"]
