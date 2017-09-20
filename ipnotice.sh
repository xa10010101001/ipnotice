#!/bin/bash
while :
do
  curl ipinfo.io > now.json
  ruby ./main.rb
  cp now.json old.json
  sleep 300
done
