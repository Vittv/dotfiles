#!/usr/bin/env bash
sudo /opt/mudfish/6.5.0/bin/mudrun-headless &
sleep 1
xdg-open http://127.0.0.1:8282/
