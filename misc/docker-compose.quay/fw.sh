firewall-cmd --permanent --add-port=8443/tcp
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=8081/tcp
firewall-cmd --reload
