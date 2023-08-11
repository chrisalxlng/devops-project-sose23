#!/bin/bash

TIMEOUT_SECONDS=180

# Get current timestamp
START_TIME=$(date +%s)

# Wait for the instance to be in the "running" state
echo "Waiting for the instance to be in the running state..."
while true; do
    INSTANCE_ID=$(aws ec2 describe-instances \
        --filters "Name=tag:name,Values=todo-app" "Name=instance-state-name,Values=running" \
        --query "Reservations[0].Instances[0].InstanceId" \
        --output text)
    if [ "$INSTANCE_ID" != "None" ]; then
        break
    fi

    # Calculate elapsed time
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    # Check if timeout has been reached
    if [ $ELAPSED_TIME -ge $TIMEOUT_SECONDS ]; then
        echo "Timeout reached. Instance did not start in time."
        exit 1
    fi

    sleep 5
done

# Wait for SSH to be reachable
echo "Waiting for SSH to be reachable..."
while true; do
    ssh -o StrictHostKeyChecking=no -i infrastructure/.ssh/operator -l ubuntu $AWS_EIP_IPV4 exit 2>/dev/null
    if [ $? -eq 0 ]; then
        break
    fi

    # Calculate elapsed time
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    # Check if timeout has been reached
    if [ $ELAPSED_TIME -ge $TIMEOUT_SECONDS ]; then
        echo "Timeout reached. SSH connection did not become reachable in time."
        exit 1
    fi

    sleep 5
done

sleep 5

# Now the instance is ready, connect via SSH
echo "Instance is ready. Connecting via SSH..."

ssh -o StrictHostKeyChecking=no -i infrastructure/.ssh/operator -l ubuntu $AWS_EIP_IPV4 "
sudo snap install docker &&
git clone https://github.com/chrisalxlng/devops-project-sose23.git &&
cd devops-project-sose23/deployable &&
echo -e \"DATABASE_IMAGE_TAG=$DATABASE_IMAGE_TAG\\nAPP_IMAGE_TAG=$APP_IMAGE_TAG\\nNGINX_IMAGE_TAG=$NGINX_IMAGE_TAG\" > .env &&
source .env &&
echo $GHCR_TOKEN | sudo docker login ghcr.io -u $GHCR_USER --password-stdin &&
sudo docker compose up -d --no-build
"
