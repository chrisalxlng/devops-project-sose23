#!/bin/bash

PREVIOUS_INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:name,Values=todo-app" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)

echo "previous_instance_id=$PREVIOUS_INSTANCE_ID" >> "$GITHUB_OUTPUT"

echo "Creating new EC2 instance..."

terraform -chdir=infrastructure init

terraform -chdir=infrastructure apply \
    -var 'SSH_PUBLIC_KEY_PATH=./.ssh/operator.pub' \
    -auto-approve

INSTANCE_IPV4=$(terraform -chdir=infrastructure output -raw 'instance_ipv4')
echo "instance_ipv4=$INSTANCE_IPV4" >> "$GITHUB_OUTPUT"
INSTANCE_ID=$(terraform -chdir=infrastructure output -raw 'instance_id')
echo "instance_id=$INSTANCE_ID" >> "$GITHUB_OUTPUT"    