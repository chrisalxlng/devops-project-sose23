#!/bin/bash

CERTIFICATES_PATH=certbot/conf/live/dev.christopherlang.me

echo "Deleting temporary self-signed certificates..."
sudo rm -rf sudo rm -rf certbot/conf/live/dev.christopherlang.me/

echo "Requesting new certificate..."
sudo docker compose run --rm  certbot certonly --register-unsafely-without-email --webroot --webroot-path /var/www/certbot/ --agree-tos -d dev.christopherlang.me

echo "Reloading nginx..."
sudo docker compose exec nginx nginx -s reload

echo "Setting up auto-renewal of certificate..."
echo "37 3 * * * sudo docker compose run --rm certbot renew --renew-hook 'sudo docker compose exec nginx nginx -s reload'" > temp-cron.txt && crontab temp-cron.txt && rm temp-cron.txt