#!/bin/bash

INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:name,Values=todo-app" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)

if [ "$INSTANCE_ID" = "None" ]; then
    echo "EC2 instance is not running. Creating..."
    
    terraform -chdir=infrastructure init

    terraform -chdir=infrastructure apply \
        -var 'SSH_PUBLIC_KEY_PATH=./.ssh/operator.pub' \
        -auto-approve

else
    echo "EC2 instance is already running. Skipping creation."
fi
