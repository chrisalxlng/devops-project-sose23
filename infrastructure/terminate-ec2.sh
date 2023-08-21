#!/bin/bash

if [ "$PREVIOUS_INSTANCE_ID" = "None" ]; then
    echo "No previous instance to destroy."

else
    echo "Terminating previous instance..."

    aws ec2 terminate-instances --instance-ids $PREVIOUS_INSTANCE_ID
fi