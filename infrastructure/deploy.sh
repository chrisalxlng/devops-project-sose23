#!/bin/bash

TIMEOUT_SECONDS=180
START_TIME=$(date +%s)

echo "Waiting for the instance to be in the running state..."
while true; do
    INSTANCE_ID=$(aws ec2 describe-instances \
        --filters "Name=tag:name,Values=todo-app" "Name=tag:environment,Values=${ENVIRONMENT}" "Name=instance-state-name,Values=running" \
        --query "Reservations[0].Instances[0].InstanceId" \
        --output text)
    if [ "$INSTANCE_ID" != "None" ]; then
        break
    fi

    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    if [ $ELAPSED_TIME -ge $TIMEOUT_SECONDS ]; then
        echo "Timeout reached. Instance did not start in time."
        exit 1
    fi

    sleep 5
done

echo "Waiting for SSH to be reachable..."
while true; do
    ssh -o StrictHostKeyChecking=no -i infrastructure/.ssh/operator -l ubuntu $INSTANCE_IPV4 exit 2>/dev/null
    if [ $? -eq 0 ]; then
        break
    fi

    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    if [ $ELAPSED_TIME -ge $TIMEOUT_SECONDS ]; then
        echo "Timeout reached. SSH connection did not become reachable in time."
        exit 1
    fi

    sleep 5
done

sleep 5

echo "Instance is ready. Connecting via SSH..."

sleep 3

ssh -o StrictHostKeyChecking=no -i infrastructure/.ssh/operator -l ubuntu $INSTANCE_IPV4 "
sudo snap install docker &&
git clone https://github.com/chrisalxlng/devops-project-sose23.git &&
cd devops-project-sose23/deployable &&
echo -e \"DATABASE_IMAGE_TAG=$DATABASE_IMAGE_TAG\\nAPP_IMAGE_TAG=$APP_IMAGE_TAG\\nNGINX_IMAGE_TAG=$NGINX_IMAGE_TAG\\nDOMAIN=$DOMAIN\" > .env &&
source .env &&
chmod +x ../infrastructure/create-ssl-keys.sh && ../infrastructure/create-ssl-keys.sh \"$DOMAIN\" &&
echo $GHCR_TOKEN | sudo docker login ghcr.io -u $GHCR_USER --password-stdin &&
sudo docker compose up -d --no-build --scale app=2
"