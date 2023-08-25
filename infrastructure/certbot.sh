#!/bin/bash

DOMAIN="$1"
AWS_ACCESS_KEY_ID="$2"
AWS_SECRET_ACCESS_KEY="$3"
AWS_SESSION_TOKEN="$4"
AWS_DEFAULT_REGION="$5"

UNIQUE_BUCKET_NAME=$DOMAIN-$(uuidgen | tr '[:upper:]' '[:lower:]')

sudo aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
sudo aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
sudo aws configure set aws_session_token $AWS_SESSION_TOKEN
sudo aws configure set region $AWS_DEFAULT_REGION

CERTIFICATES_PATH=certbot/conf/live/${DOMAIN}

SSL_CN=$(sudo openssl x509 -noout -subject -in $CERTIFICATES_PATH/fullchain.pem | grep -oE 'CN = [^ ,]+' | sed 's/CN = //')

if [ "$SSL_CN" = "localhost" ]; then
    echo "Deleting temporary self-signed certificates..."
    sudo rm -rf sudo rm -rf $CERTIFICATES_PATH

    echo "Requesting new certificate..."
    sudo docker compose run --rm  certbot certonly --register-unsafely-without-email --webroot --webroot-path /var/www/certbot/ --agree-tos -d $DOMAIN

    echo "Creating new bucket..."
    sudo aws s3api create-bucket --bucket $UNIQUE_BUCKET_NAME

    echo "Uploading certificates to s3..."
    sudo aws s3 sync $CERTIFICATES_PATH s3://$UNIQUE_BUCKET_NAME

    echo "Reloading nginx..."
    sudo docker compose exec nginx nginx -s reload
else
    echo "Certificates already configured correctly. Skipping request..."
fi

echo "Setting up auto-renewal of certificate..."
echo "37 3 * * * sudo docker compose run --rm certbot renew --renew-hook 'sudo docker compose exec nginx nginx -s reload'" > temp-cron.txt && crontab temp-cron.txt && rm temp-cron.txt

