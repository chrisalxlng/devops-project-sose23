#!/bin/bash

mkdir -p infrastructure/.ssh
echo "$SSH_PRIVATE_KEY" > infrastructure/.ssh/operator
echo "$SSH_PUBLIC_KEY" > infrastructure/.ssh/operator.pub
chmod 600 infrastructure/.ssh/operator*