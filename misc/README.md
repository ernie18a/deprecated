[[_TOC_]]
# 命名原則
## 資料夾
- docker-compose.<服務或OS>/：內含相依性檔案
- kube.<服務或OS>/：內含.yaml或相依性檔案
- ocp.<服務或OS>/：內含.yaml或相依性檔案
## 單一檔案
- Dockerfile.<服務或OS>：無相依性檔案
- docker-compose.yml.<服務或OS>：無重要相依性檔案
- service.<服務>.conf：OS 上的服務
- sh.<腳本用途>.sh：bash script
