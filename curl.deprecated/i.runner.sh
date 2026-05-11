ls /usr/local/bin/gitlab-runner 2>/dev/null || curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 && chmod 0755 /usr/local/bin/gitlab-runner
gitlab-runner restart
gitlab-runner uninstall
userdel -rf gitlab-runner
rm -rf /etc/gitlab-runner /etc/systemd/system/gitlab-runner.service /etc/systemd/system/multi-user.target.wants/gitlab-runner.service
useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
usermod -aGdocker gitlab-runner
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
gitlab-runner restart
gitlab-runner verify
rm -rf /home/gitlab-runner/.*
echo "gitlab-runner register"
echo "https://gitlab.com/"
