#!/bin/bash

path=certs
sudo mkdir -p "$path"
sudo openssl req -x509 -nodes -newkey rsa:4098 -keyout "$path/privkey.pem" -out "$path/fullchain.pem" -subj "/CN=localhost"