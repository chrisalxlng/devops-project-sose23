#!/bin/bash

old_key_id=$(aws configure get aws_access_key_id)
printf "AWS Access Key Id [$old_key_id]: "
read -r key_id
if [[ ! -z "$key_id" ]]; then
    aws configure set aws_access_key_id $key_id
fi

old_secret_access_key=$(aws configure get aws_secret_access_key)
printf "AWS Secret Access Key [$old_secret_access_key]: "
read -r secret_access_key
if [[ ! -z "$secret_access_key" ]]; then
    aws configure set aws_secret_access_key $secret_access_key
fi

old_session_token=$(aws configure get aws_session_token)
printf "AWS Session Token [$old_session_token]: "
read -r aws_session_token
if [[ ! -z "$aws_session_token" ]]; then
    aws configure set aws_session_token $aws_session_token
fi