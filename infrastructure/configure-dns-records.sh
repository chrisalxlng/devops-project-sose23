#!/bin/bash

ELASTIC_IP=$(aws ec2 describe-addresses --allocation-ids "$AWS_EIP_ALLOCATION_ID" --query "Addresses[0].PublicIp" --output text)

echo "Elastic IP to use as value: $ELASTIC_IP"

OUTPUT=$(aws route53 change-resource-record-sets \
    --hosted-zone-id ${AWS_HOSTED_ZONE_ID} \
    --change-batch "{\"Changes\":[{\"Action\":\"CREATE\",\"ResourceRecordSet\":{\"Name\":\"${DOMAIN}\",\"Type\":\"A\",\"TTL\":300,\"ResourceRecords\":[{\"Value\":\"${ELASTIC_IP}\"}]}}]}" 2>&1)

echo "Change record output: $OUTPUT"

if echo "$OUTPUT" | grep -q "An error occurred"; then
    echo "The record was already existing. Skipping creation..."
else
    echo "The record was created successfully."
fi