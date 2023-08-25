#!/bin/bash

DOMAIN="$1"
AWS_ACCESS_KEY_ID="$2"
AWS_SECRET_ACCESS_KEY="$3"
AWS_SESSION_TOKEN="$4"
AWS_DEFAULT_REGION="$5"

sudo aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
sudo aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
sudo aws configure set aws_session_token "$AWS_SESSION_TOKEN"
sudo aws configure set region "$AWS_DEFAULT_REGION"

BUCKETS=($(sudo aws s3api list-buckets --query 'Buckets[].Name' --output text))
MATCHED_BUCKET=""
for BUCKET in "${BUCKETS[@]}"; do
    if [[ "$BUCKET" == "$DOMAIN"* ]]; then
        MATCHED_BUCKET="$BUCKET"
        break
    fi
done

CERTIFICATES_PATH="certbot/conf/live/${DOMAIN}"
TEMP_DIR_PATH="temp"

sudo mkdir -p "$TEMP_DIR_PATH"
sudo mkdir -p "$CERTIFICATES_PATH"

echo "Downloading certificates from S3..."
sudo aws s3 sync "s3://$MATCHED_BUCKET" "$TEMP_DIR_PATH"

if [ -z "$(ls -A "$TEMP_DIR_PATH")" ]; then
    echo "No certificates to download. Creating temporary self-signed one..."
    sudo openssl req -x509 -nodes -newkey rsa:4098 -days 1 -keyout "$CERTIFICATES_PATH/privkey.pem" -out "$CERTIFICATES_PATH/fullchain.pem" -subj "/CN=localhost"
else
    CERT_FILE="$TEMP_DIR_PATH/fullchain.pem"
    THRESHOLD_DAYS=7

    EXPIRATION_DATE=$(openssl x509 -enddate -noout -in "$CERT_FILE" | cut -d "=" -f 2)
    EXPIRATION_EPOCH=$(date -d "$EXPIRATION_DATE" +%s)
    THRESHOLD_EPOCH=$(date -d "+$THRESHOLD_DAYS days" +%s)

    if [ "$EXPIRATION_EPOCH" -le "$THRESHOLD_EPOCH" ]; then
        echo "Certificate expires in 7 days or less. Creating temporary self-signed one..."
        sudo openssl req -x509 -nodes -newkey rsa:4098 -days 1 -keyout "$CERTIFICATES_PATH/privkey.pem" -out "$CERTIFICATES_PATH/fullchain.pem" -subj "/CN=localhost"
    else
        echo "Certificate is still valid. Copying certificates..."
        sudo cp -r "$TEMP_DIR_PATH"/* "$CERTIFICATES_PATH"
    fi
fi