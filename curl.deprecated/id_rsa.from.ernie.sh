mkdir ~/.ssh
chmod 0700 ~/.ssh
cat .ssh/id_rsa > ~/.ssh/id_rsa
cat .ssh/id_rsa.pub > ~/.ssh/id_rsa.pub
chmod 0600 ~/.ssh/id_rsa
chmod 0644 ~/.ssh/id_rsa.pub
