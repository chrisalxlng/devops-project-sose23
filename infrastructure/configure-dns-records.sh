#!/bin/bash

AWS_HOSTED_ZONE_ID=$AWS_HOSTED_ZONE_ID
AWS_EIP_ALLOCATION_ID=$AWS_EIP_ALLOCATION_ID
DOMAIN=$DOMAIN

ELASTIC_IP=$(aws ec2 describe-addresses --allocation-ids $AWS_EIP_ALLOCATION_ID --query "Addresses[0].PublicIp" --output text)

OUTPUT=$(aws route53 change-resource-record-sets \
    --hosted-zone-id ${AWS_HOSTED_ZONE_ID} \
    --change-batch "{\"Changes\":[{\"Action\":\"CREATE\",\"ResourceRecordSet\":{\"Name\":\"${DOMAIN}\",\"Type\":\"A\",\"TTL\":300,\"ResourceRecords\":[{\"Value\":\"${ELASTIC_IP}\"}]}}]}")

if [ $? -eq 0 ]; then
    echo "The record was created successully."
else
    echo "The record was already existing. Skipping creation..."
fi