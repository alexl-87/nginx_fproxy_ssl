#! /bin/bash
docker build -t nginx_forward_proxy:latest /home/nginx/nginx
cp /home/nginx/nginx/nginx_api.ts /home/nginx/nodejs
chmod 0755 /home/nginx/nginx/nginx_api.ts
cp /home/nginx/nginx/nginx_api.service /lib/systemd/system
systemctl start nginx_api

