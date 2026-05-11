[[_TOC_]]
# 下載 binary
```bash
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
```
# 解壓縮
```bash
tar -xzf postman.tar.gz -C /opt
```
# 建立捷徑(ln -s)
```bash
ln -s /opt/Postman/Postman /usr/bin/postman
```
# 執行
```bash
postman
```
### 設定postman.desktop權限
```bash
chmod +x ~/Desktop/postman.desktop
```
# 執行
## 方法一
- 在GUI環境的桌面中執行(click)postman.desktop
- 需前置作業"建立捷徑(icon)"
## 方法二
- 再GUI環境開啟terminal，輸入" postman " Enter
```bash
[vm001 ~ ] $ postman
```
# 非必要
## 解決相依性的問題
```bash
yum install -y libXScrnSaver
```
## 建立捷徑(icon)
- 方法一的前置作業
```bash
cat << EOF >> ~/Desktop/postman.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF
```
## 從 pstmn.io 下載檔案安全嗎？
- Registrant Organization: Postman Inc.
- 可用whois指令查詢
```bash
[C23011-ErnieHo ~ ] $ whois pstmn.io |grep -i postman
Registrant Organization: Postman Inc.
[C23011-ErnieHo ~ ] $ 
```
