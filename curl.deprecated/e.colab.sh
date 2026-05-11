cat << EOF
# %cd /content/411d3/.deprecated
# !git clone https://gitlab.com/ernie18a/411d3.git
!git clone https://gitlab.com/ernie18a/.git
!apt update ; apt install -y portaudio19-dev python3-dev
!curl -LsSf https://astral.sh/uv/install.sh | sh
%cd /content/411d3
!uv pip install --system -r .requirements.txt
!python3
EOF
