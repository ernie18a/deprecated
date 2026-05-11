curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/misc/emoji > /tmp/.EMOJI
while read emoji ; do touch /tmp/$emoji ; done < /tmp/.EMOJI
ls -l /tmp/
