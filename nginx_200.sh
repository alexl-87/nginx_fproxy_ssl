#! /bin/bash
cp /usr/local/nginx/conf/nginx_conf_200 /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload