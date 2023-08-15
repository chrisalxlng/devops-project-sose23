#!/bin/bash

mkdir -p ./.ssh
yes | ssh-keygen -t rsa -b 4096 -C "operator" -N "" -f ./.ssh/operator
chmod 600 ./.ssh/operator*