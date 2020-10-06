#! /bin/bash
cp /usr/local/nginx/conf/nginx.conf.allow /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload