FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive apt-get -q update && apt-get -qy install \
        nano \
        wget \
        build-essential \
        libcurl4-openssl-dev libev-dev libxml2-dev libjansson-dev pkg-config \
        libcunit1 zlib1g-dev libjemalloc-dev libevent-openssl-2.0-5 libssh2-1-dev \
        libssl-dev libxml2-dev make autoconf automake autotools-dev libtool \
        libboost-dev libboost-thread-dev libboost-iostreams-dev \
    && apt-get -qy autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://github.com/tatsuhiro-t/nghttp2/releases/download/v1.3.4/nghttp2-1.3.4.tar.gz && tar -zxvf nghttp2* && rm -f *.gz
RUN wget http://curl.haxx.se/download/curl-7.44.0.tar.gz && tar -zxvf curl* && rm -f *.gz
RUN wget http://www.openssl.org/source/openssl-1.0.2d.tar.gz && tar -zxvf openssl* && rm -f *.gz

ENV TERM=xterm

RUN cd openssl* && ./config && make -j4 && make install && ldconfig
RUN cd nghttp2* && ./configure && make -j4 && make install && ldconfig
RUN cd curl* && ./configure --disable-shared --enable-static && make -j4 && make install && ldconfig

RUN rm -rf /opt/*

CMD /usr/local/bin/curl
