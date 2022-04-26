# PhonenixBuilderDockerBuilder
考虑到FB的跨平台编译对很多人来说是非常困难的, 如果你没有一台Linux，有可能完全无法编译  
为了方便有需求的人在 Windows 或者 MacOS (当然 Linux) 上编译全平台的 PhoenixBuilder，特此提供这个项目

## 前置条件:
Docker, 不同系统的安装方式:
 - Windows, Macos: 搜索 Docker-Desktop 下载安装包(应该有几百MB), 并安装
 - Linux: Docker-CE, 安装方式无需赘述，请根据自己的发行版确定

## 构造环境
本项目的主要内容就是提供这个复杂的交叉编译环境的自动构造文件，分两步完成:  
1. 下载 github 上的其它依赖文件(主要是构造ios,macos使用的thoes), 这一步提供了一个简单的脚本:
    ```shell
    bash docker/build/download_deps.sh
    ```
    如果你无法科学上网，很可能会下载失败, 不用担心, 你也可以手动下载:
    - git clone --recursive --depth=1 https://github.com/theos/theos.git
    - https://github.com/sbingner/llvm-project/releases/latest/download/linux-ios-arm64e-clang-toolchain.tar.lzma
    - https://github.com/theos/sdks/archive/master.zip
    - https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX11.0.sdk.tar.xz  
2. 下载完成后，(如果你是手动下载的，请正确放置下载得到的文件)，此时，build 文件夹看起来有这些文件(请务必确保文件成功下载):  
    - Dockerfile
    - download_deps.sh
    - master.zip 
    - MacOSX11.0.sdk.tar.xz
    - linux-ios-arm64e-clang-toolchain.tar.lzma theos
3. 编译环境:  
   调用本项目提供的 Dockerfile 即可
    ```shell 
    docker build -t cma2401pt/phoenixbuilderdockerbuilder build  
    ```
    如果没有错误的话，恭喜，你已经获得一个可以编译 PhoenixBuilder的环境，如果有错误的话，请重试直到成功(因为往往是网络问题)

## 编译项目
在终端中调用
```shell
docker run --rm --name="builder" \
    -v cache文件夹的绝对路径:/root/go \
    -v start.sh的绝对路径:/root/start.sh \
    -v PhoenixBuilder代码的绝对路径:/phoenixbuilder \
    -v 保存编译结果的绝对路径:/phoenixbuilder/build/ \
    cma2401pt/phoenixbuilder:latest /bin/bash /root/start.sh
```
在笔者的电脑上(MacOS)是这样的,你应该根据自己电脑实际情况进行修改:
```shell
docker run --rm --name="builder" \
    -v ${PWD}/cache/:/root/go \
    -v ${PWD}/start.sh:/root/start.sh \
    -v /Users/dai/Develop/projects/PhoenixBuilderOrig/:/phoenixbuilder \
    -v ${PWD}/output/:/phoenixbuilder/build/ \
    cma2401pt/phoenixbuilder:latest /bin/bash /root/start.sh
```
在start.sh 中，列出了所有可能的构建目标, 你可以根据自己的需要删改
完成编译后，你可以在“保存编译结果的绝对路径”下看到所有编译结果