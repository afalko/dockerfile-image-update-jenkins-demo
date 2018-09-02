#!/bin/bash
cp -R web/* /usr/share/nginx/html/
chown -R nginx:nginx /usr/share/nginx/html

cd jenkins
./build_and_start.sh
cd ..
