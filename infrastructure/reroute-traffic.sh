#!/bin/bash

TIMEOUT_SECONDS=180
START_TIME=$(date +%s)

echo "Checking if new instance is ready..."
while true; do
    RESPONSE=$(curl -k https://$INSTANCE_IPV4/)

    if [[ $RESPONSE = "<!doctype html>"* ]]; then
        break
    fi

    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    if [ $ELAPSED_TIME -ge $TIMEOUT_SECONDS ]; then
        echo "Timeout reached. Instance was not ready in time."
        exit 1
    fi

    sleep 5
done

echo "Instance is ready. Re-routing traffic..."

aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $EIP_ALLOCATION_ID