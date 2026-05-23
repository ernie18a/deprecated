curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR=/usr/local/bin sh
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
VENV_PYTHON=$(readlink -f /usr/local/lib/hermes-agent/venv/bin/python)
PYTHON_VERSION_DIR=$(basename $(dirname $(dirname $VENV_PYTHON)))
PYTHON_BIN_NAME=$(basename $VENV_PYTHON)
mkdir -p /usr/local/share/uv/python/
cp -r $(dirname $(dirname $VENV_PYTHON)) /usr/local/share/uv/python/
NEW_PYTHON=/usr/local/share/uv/python/${PYTHON_VERSION_DIR}/bin/${PYTHON_BIN_NAME}
ln -sf $NEW_PYTHON /usr/local/lib/hermes-agent/venv/bin/python
ln -sf $NEW_PYTHON /usr/local/lib/hermes-agent/venv/bin/python3
ln -sf $NEW_PYTHON /usr/local/lib/hermes-agent/venv/bin/${PYTHON_BIN_NAME}
chmod -R o+rX /usr/local/lib/hermes-agent/
chmod -R o+rX /usr/local/share/uv/
rm -f /root/.local/bin/uv
rm -rf /root/.local/share/uv/
#echo "=== 驗證 symlink ==="
#ls -la /usr/local/lib/hermes-agent/venv/bin/python
#echo "=== 驗證普通用戶可用 ==="
#su - e -c "hermes --version"
