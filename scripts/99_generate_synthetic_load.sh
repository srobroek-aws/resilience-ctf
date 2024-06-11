#!/bin/bash
export MYSITE=$(aws ssm get-parameter --name '/petstore/petsiteurl'  | jq -r .Parameter.Value | tr '[:upper:]' '[:lower:]' | cut -f 3 -d '/')
sed -i "s/URI/$MYSITE/g" ../loadgen/k6petsite.js
curl -o chrome.json https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json
#docker run --rm -i --security-opt seccomp=$(pwd)/chrome.json grafana/k6:latest-with-browser run - <../loadgen/k6petsite.js

docker run --rm -i --security-opt seccomp=$(pwd)/chrome.json grafana/k6:latest-with-browser run - < ../loadgen/k6petsite.js
