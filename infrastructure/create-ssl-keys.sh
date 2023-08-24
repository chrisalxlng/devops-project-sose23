 #!/bin/bash

DOMAIN="$1"

CERTIFICATES_PATH=certbot/conf/live/${DOMAIN}
sudo mkdir -p "$CERTIFICATES_PATH"
sudo openssl req -x509 -nodes -newkey rsa:4098 -days 1 -keyout "$CERTIFICATES_PATH/privkey.pem" -out "$CERTIFICATES_PATH/fullchain.pem" -subj "/CN=localhost"