#!/usr/bin/env sh

MIHOMO_VERSION="v1.19.30"

git clone --branch "$MIHOMO_VERSION" --depth 1 /tmp/mihomo
cd /tmp/mihomo
make

sudo groupadd mihomo
sudo usermod -aG mihomo $USER

sudo install -Dm755 bin/mihomo/linux-amd64-v3 /usr/local/bin/mihomo
cd -
rm -rf /tmp/mihomo

sudo cp mihomo@.service /etc/systemd/system/
sudo cp 90-mihomo.rules /etc/polkit-1/rules.d/90-mihomo.rules
