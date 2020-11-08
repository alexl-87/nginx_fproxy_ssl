#! /bin/bash
docker build -t nginx_forward_proxy:latest /home/nginx/nginx > docker_init.log
cp /home/nginx/nginx/nginx_api.js /home/nginx/nodejs
chmod 0755 /home/nginx/nginx/nginx_api.js
cp /home/nginx/nginx/nginx_api.service /lib/systemd/system
systemctl start nginx_api

