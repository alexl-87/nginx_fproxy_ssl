#! /bin/bash
cd /root/nginx_fproxy_ssl
git pull https://github.com/alexl-87/nginx_fproxy_ssl
docker build -t nginx_forward_proxy:latest .