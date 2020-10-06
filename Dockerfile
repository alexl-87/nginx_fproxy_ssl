FROM        ubuntu:18.04
MAINTAINER  Alexander Latyshev <latyshevmb@gmail.com>

WORKDIR /app

RUN apt-get update && apt-get upgrade

RUN apt-get install -y gcc g++ make gawk perl wget libssl-dev openssl git vim 

# Download sources:
RUN cd /app && wget \
    https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz \
    http://zlib.net/zlib-1.2.11.tar.gz \
    https://nginx.org/download/nginx-1.18.0.tar.gz

# Untar sources
RUN for f in *.tar.gz; do tar zxf "$f"; done
RUN rm *.tar.gz

# PCRE – Supports regular expressions. Required by the NGINX Core and Rewrite modules.
RUN cd /app/pcre-8.44 && ./configure && make && make install

# zlib – Supports header compression. Required by the NGINX Gzip module.
RUN cd /app/zlib-1.2.11 && ./configure && make && make install

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

# Create SSL certificate files
# RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# Add scripts for controlling NGINX configurations
ADD nginx_allow.sh /usr/local/nginx/sbin/
ADD nginx_deny.sh  /usr/local/nginx/sbin/

# Add ssl forwarding configuration
ADD nginx.conf.allow /usr/local/nginx/conf/

# Add force return 503 configuration
ADD nginx.conf.deny /usr/local/nginx/conf/