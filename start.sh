#!/bin/bash
set -e

# trigger by:
# bash docker/build/download_deps.sh
# docker build -t cma2401pt/phoenixbuilderdockerbuilder build
# docker run --name="builder" --rm --volume $PWD:/work --volume $PWD/docker/cache:/root/go -e HOST_UID=`id -u $USER` -e HOST_GID=`id -g $USER` -e HOST_USER=$USER cma2401pt/phoenixbuilder:latest  /bin/bash /work/docker/start.sh
cd /phoenixbuilder
source /etc/profile
echo "Pre-Build & configure go-raknet"
make current
make clean
chmod 0644 ~/go/pkg/mod/github.com/sandertv/go-raknet@v1.9.1/conn.go
sed "s/urrentProtocol byte = 10/urrentProtocol byte = 8/g" ~/go/pkg/mod/github.com/sandertv/go-raknet@v1.9.1/conn.go>~/conn.go
cp -f ~/conn.go ~/go/pkg/mod/github.com/sandertv/go-raknet@v1.9.1/conn.go
echo ""
echo "Build"
export THEOS=/theos
echo "build linux"
make build/phoenixbuilder
mv build/phoenixbuilder build/phoenixbuilder-linux
echo "build linux-v8"
make build/phoenixbuilder-v8
mv build/phoenixbuilder-v8 build/phoenixbuilder-v8-linux
echo "build macos"
make build/phoenixbuilder-macos-x86_64
# echo "build macos-v8"
# make build/phoenixbuilder-v8-macos-x86_64
echo "build windows"
make build/phoenixbuilder-windows-executable-x86_64.exe
echo "build ios"
make build/phoenixbuilder-ios-executable
echo "build ios-v8"
make build/phoenixbuilder-v8-ios-executable
echo "build android"
make build/phoenixbuilder-android-executable-arm64
echo "build android-v8"
make build/phoenixbuilder-v8-android-executable-arm64
echo "Build Complete"