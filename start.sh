#!/bin/bash
set -e

# trigger by:
# bash docker/build/download_deps.sh
# docker build -t cma2401pt/phoenixbuilderdockerbuilder build
# docker run --name="builder" --rm --volume $PWD:/work --volume $PWD/docker/cache:/root/go -e HOST_UID=`id -u $USER` -e HOST_GID=`id -g $USER` -e HOST_USER=$USER cma2401pt/phoenixbuilder:latest  /bin/bash /work/docker/start.sh
git config --global --add safe.directory /phoenixbuilder
cd /phoenixbuilder
source /etc/profile
echo "Pre-Build & configure go-raknet"
make current
make clean
chmod 0644 ~/go/pkg/mod/github.com/sandertv/go-raknet@v1.9.1/conn.go
sed "s/urrentProtocol byte = 10/urrentProtocol byte = 8/g" ~/go/pkg/mod/github.com/sandertv/go-raknet@v1.9.1/conn.go>~/conn.go
cp -f ~/conn.go ~/go/pkg/mod/github.com/sandertv/go-raknet@v1.9.1/conn.go

targets=""
export THEOS=/theos
# Linux
targets=${targets}" build/phoenixbuilder"
# Linux-v8
targets=${targets}" build/phoenixbuilder-v8"
# MacOS
targets=${targets}" build/phoenixbuilder-macos-x86_64"
# Windows
targets=${targets}" build/phoenixbuilder-windows-executable-x86_64.exe"
# ios
targets=${targets}" build/phoenixbuilder-ios-executable"
# ios-v8
targets=${targets}" build/phoenixbuilder-v8-ios-executable"
# android
targets=${targets}" build/phoenixbuilder-android-executable-arm64"
# android-v8
targets=${targets}" build/phoenixbuilder-v8-android-executable-arm64"
echo "Start Build"
make ${targets} -j8
echo "Build Complete"