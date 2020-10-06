#! /bin/bash

git clone https://github.com/alexl-87/nginx_fproxy_ssl
docker build -t nginx_forward_proxy:latest - < ./nginx_fproxy_ssl/Dockerfile