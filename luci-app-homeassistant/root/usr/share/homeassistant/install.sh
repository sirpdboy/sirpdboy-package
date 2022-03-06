#!/bin/sh

docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ="Asia/Shanghai" \
  -v /root/homeassistant/config:/config \
  --network=host \
  homeassistant/home-assistant:latest
