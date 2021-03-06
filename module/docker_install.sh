#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y fuse3 fuse-overlayfs
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
# /etc/apt/sources.listは初回起動時にリセットを食らうので、.dに入れる
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo sh -c "cat << EOF >> /etc/apt/sources.list.d/docker.list
deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF"


sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# dockerの保存形式の設定
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "storage-driver": "fuse-overlayfs"
}
EOF
<< COMMENTOUT
cat <<EOF | sudo tee /etc/docker/daemon.json 
{
  "storage-driver": "vfs"
}
EOF
COMMENTOUT

sudo systemctl restart docker.service 
# composeのインストール
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
