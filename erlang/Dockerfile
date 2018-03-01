FROM centos:6.7
MAINTAINER wudeng256@gmail.com

ENV LANG="en_US.UTF-8"

RUN set -xe \
    && yum -y groupinstall "Development Tools" \
    && yum -y install ncurses \
        ncurses-devel \
        unixODBC \
        unixODBC-devel \
        openssl-devel \
        tar

RUN set -xe \
    && curl -fSL -o openssl.tar.gz https://www.openssl.org/source/openssl-1.0.1j.tar.gz \
    && mkdir -p /usr/src/openssl-src \
    && tar -zxf openssl.tar.gz -C /usr/src/openssl-src --strip-components=1 \
    && rm openssl.tar.gz
    && cd /usr/src/openssl-src \
    && ./config --prefix=/usr shared -fPIC \
    && make \
    && make install \
    && rm -rf /usr/src/openssl-src

COPY otp_src_R16B03-1.tar.gz otp-src.tar.gz

RUN set -xe \ 
    && mkdir -p /usr/src/otp-src \
    && tar -zxf otp-src.tar.gz -C /usr/src/otp-src --strip-components=1 \
    && rm otp-src.tar.gz \
    && cd /usr/src/otp-src \
    && ./otp_build autoconf \
    && ./configure --disable-dynamic-ssl-lib --with-ssl=/usr/ --enable-smp-support \
    && make \
    && make install \
    && find /usr/local -name examples | xargs rm -rf \
    && cd /usr/src \
    && rm -rf /usr/src/otp-src

CMD ["erl"]
