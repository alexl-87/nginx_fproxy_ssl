FROM        ubuntu:18.04
MAINTAINER  Alexander Latyshev <latyshevmb@gmail.com>

WORKDIR /app

RUN apt update && apt upgrade

RUN apt install -y gcc g++ make gawk perl wget libssl-dev git

# Download sources:
RUN cd /app && wget \
    https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz \
    http://zlib.net/zlib-1.2.11.tar.gz \
    http://www.openssl.org/source/openssl-1.1.1g.tar.gz \
    https://nginx.org/download/nginx-1.18.0.tar.gz

# Untar sources
RUN for f in *.tar.gz; do tar zxf "$f"; done
RUN rm *.tar.gz

# PCRE – Supports regular expressions. Required by the NGINX Core and Rewrite modules.
RUN cd /app/pcre-8.44 && ./configure && make && make install

# zlib – Supports header compression. Required by the NGINX Gzip module.
RUN cd /app/zlib-1.2.11 && ./configure && make && make install

# OpenSSL – Supports the HTTPS protocol. Required by the NGINX SSL module and others.
RUN cd /app/openssl-1.1.1g && ./Configure linux-x86_64 --prefix=/usr && make && make install

# Patch NGINX to support ssl forwarding
RUN cd /app/nginx-1.* && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module && \
    patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_1018.patch

# Configure and install NGINX
RUN cd /app/nginx-1.* && \
 ./configure \
--with-http_stub_status_module \
--with-http_realip_module \
--with-threads \
--with-http_ssl_module \
--with-stream \
--with-pcre=../pcre-8.44 \
--with-zlib=../zlib-1.2.11 \
--add-module=./ngx_http_proxy_connect_module && \
make && make install