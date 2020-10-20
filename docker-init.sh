#! /bin/bash
docker build -t nginx_forward_proxy:latest /home/harmonic/nginx
mv /home/harmonic/nginx/nginx_api.js /home/harmonic/nodejs/nginx_api.js 
mv /home/harmonic/nginx/nginx_api.service /etc/systemd/system/nginx_api.service
systemctl start nginx_api

