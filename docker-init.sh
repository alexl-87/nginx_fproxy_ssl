#! /bin/bash
docker build -t nginx_forward_proxy:latest /home/harmonic/nginx
cp /home/harmonic/nginx/nginx_api.js /home/harmonic/nodejs
chmod 0755 /home/harmonic/nginx/nginx_api.js
cp /home/harmonic/nginx/nginx_api.service /lib/systemd/system
systemctl start nginx_api

