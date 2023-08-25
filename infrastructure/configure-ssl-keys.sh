#!/bin/bash

TIMEOUT_SECONDS=180
START_TIME=$(date +%s)

sleep 10

echo "Waiting for SSH to be reachable..."
while true; do
    ssh -o StrictHostKeyChecking=no -vvv -i infrastructure/.ssh/operator -l ubuntu $DOMAIN exit 2>/dev/null
    if [ $? -eq 0 ]; then
        break
    fi

    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    if [ $ELAPSED_TIME -ge $TIMEOUT_SECONDS ]; then
        echo "Timeout reached. SSH connection did not become reachable in time."
        exit 1
    fi

    echo "Connection refused. Retrying..."
    sleep 5
done

sleep 5

echo "Instance is ready. Configuring SSL certificates..."

ssh -o StrictHostKeyChecking=no -i infrastructure/.ssh/operator -l ubuntu $DOMAIN "
cd devops-project-sose23/deployable &&
source .env &&
chmod +x ../infrastructure/certbot.sh && ../infrastructure/certbot.sh \"$DOMAIN\"
"