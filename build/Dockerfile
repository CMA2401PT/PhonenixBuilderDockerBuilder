FROM ubuntu:20.04 AS unpacker
COPY theos /theos
COPY linux-ios-arm64e-clang-toolchain.tar.lzma /linux-ios-arm64e-clang-toolchain.tar.lzma
COPY master.zip /master.zip
COPY MacOSX11.0.sdk.tar.xz /MacOSX11.0.sdk.tar.xz

# note: http, but not https
RUN export DEBIAN_FRONTEND=noninteractive && export DEBIAN_FRONTEND=teletype \
    && echo 'deb http://mirrors.bfsu.edu.cn/ubuntu/ focal main restricted universe multiverse' > /etc/apt/sources.list \
    && echo 'deb http://mirrors.bfsu.edu.cn/ubuntu/ focal-updates main restricted universe multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.bfsu.edu.cn/ubuntu/ focal-backports main restricted universe multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.bfsu.edu.cn/ubuntu/ focal-security main restricted universe multiverse' >> /etc/apt/sources.list \
    && apt-get update -yq && apt-get upgrade --fix-missing -yq && apt-get install --fix-missing -yq --no-install-recommends \
    unzip xz-utils wget curl\
    ca-certificates \
    bzip2 \
    openssl \
    && apt clean -yq && apt autoclean -yq && apt autoremove -yq && rm -rf /var/lib/apt/lists/*

RUN  echo "export THEOS=/theos" >> /etc/profile \
    && . /etc/profile \
    && TMP=$(mktemp -d) \
    && tar -xf /linux-ios-arm64e-clang-toolchain.tar.lzma -C $TMP \
    && mkdir -p $THEOS/toolchain/linux/iphone \
    && mv $TMP/ios-arm64e-clang-toolchain/* $THEOS/toolchain/linux/iphone/ \
    && rm -r /linux-ios-arm64e-clang-toolchain.tar.lzma $TMP \
    && TMP=$(mktemp -d) \
    && unzip -q /master.zip -d $TMP \
    && mv $TMP/sdks-master/*.sdk $THEOS/sdks \
    && rm -r /master.zip $TMP

RUN tar -xf /MacOSX11.0.sdk.tar.xz \
    && mv /MacOSX11.0.sdk /theos/sdks/MacOSX11.0.sdk \
    && rm /MacOSX11.0.sdk.tar.xz

RUN curl https://dl.google.com/go/go1.18.1.linux-amd64.tar.gz -o go.tar.gz \
    && tar -C /usr/local/ -xzf go.tar.gz \
    && rm go.tar.gz 

RUN curl https://dl.google.com/android/repository/android-ndk-r20b-linux-x86_64.zip?hl=zh_cn -o ndk.zip \
    && unzip ndk.zip -d ${HOME} \
    && rm ndk.zip 


FROM ubuntu:20.04
# note: http, but not https
RUN export DEBIAN_FRONTEND=noninteractive && export DEBIAN_FRONTEND=teletype \
    && echo 'deb http://mirrors.bfsu.edu.cn/ubuntu/ focal main restricted universe multiverse' > /etc/apt/sources.list \
    && echo 'deb http://mirrors.bfsu.edu.cn/ubuntu/ focal-updates main restricted universe multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.bfsu.edu.cn/ubuntu/ focal-backports main restricted universe multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.bfsu.edu.cn/ubuntu/ focal-security main restricted universe multiverse' >> /etc/apt/sources.list \
    && apt-get update -yq && apt-get upgrade --fix-missing -yq && apt-get install --fix-missing -yq --no-install-recommends \
    ca-certificates \
    bzip2 \
    openssl \
    git \
    locales \
    curl \
    jq \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    software-properties-common \
    fakeroot git perl unzip build-essential libtinfo5 libplist-utils brotli \
    unzip xz-utils\
    gcc-mingw-w64-i686 gcc-mingw-w64-x86-64 gcc gcc-aarch64-linux-gnu libgl1-mesa-dev xorg-dev \
    libreadline-dev \
    && apt clean -yq && apt autoclean -yq && apt autoremove -yq && rm -rf /var/lib/apt/lists/*

# configuration language settings, root login not allowed by default
RUN export LC_ALL=en_US.UTF-8 \
    && export SHELL=/bin/bash \
    && locale-gen en_US.UTF-8 \
    && passwd -d root

COPY --from=unpacker /usr/local/go /usr/local/go
RUN echo 'GOROOT=/usr/local/go' >> /etc/profile \
    && echo 'export PATH=/usr/local/go/bin:$PATH' >> /etc/profile  \
    && echo 'export GO111MODULE=auto' >> /etc/profile \
    && echo 'export GOPROXY=https://goproxy.cn,direct' >> /etc/profile \
    && . /etc/profile \
    && go version

COPY --from=unpacker /root/android-ndk-r20b /root/android-ndk-r20b 
RUN echo 'export ANDROID_NDK_HOME=${HOME}/android-ndk-r20b' >> /etc/profile \
    && echo 'export PATH=$PATH:$ANDROID_NDK_HOME/bin' >> /etc/profile \
    && . /etc/profile

# Install theos && Macos-sdk 11.0
RUN  echo "export THEOS=/theos" >> /etc/profile
COPY --from=unpacker /theos/ /theos/
