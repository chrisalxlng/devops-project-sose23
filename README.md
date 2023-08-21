# DevOps Project (SoSe 2023)

## Deadlines

- 31/05/2023: Submission of [Project Concept](./concept.md)
- 25/08/2023: Submission of Project Implementation

## Steps to reproduce

### Repository secrets

You will need to provide several tokens as repository secrets for this workflow to run successfully. You can add repository secrets under the following path: `Settings` > `Secrets and variables` > `Actions` > `Secrets` > `New repository secret`

1. Create a GitHub token with `package:read` and `package:write` permissions.
    - Put this token in a secret of this repository with the name `GHCR_TOKEN`.
2. Get your AWS credentials `aws_access_key_id`, `aws_secret_access_key` and `aws_session_token`.
    - Put these tokens in secrets of this repository with the names `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` respectively.
3. Create SSH keys locally by running the script in `infrastructure/create-ssh-keys.sh`.
    - Copy the content of the file `.ssh/operator.pub` into a new secret with the name `SSH_PUBLIC_KEY`.
    - Copy the content of the file `.ssh/operator` into a new secret with the name `SSH_PRIVATE_KEY`.

### Repository variables

You will also need to provide some repository variables. Repository variables can be created under the following path:  `Settings` > `Secrets and variables` > `Actions` > `Variables` > `New repository variable`

1. Create a repository variable with the name `AWS_DEFAULT_REGION` and enter your desired region as value (usually: `us-east-1`).

### Environment variables

Some variables differ for each environment. To create an environment variable on GitHub: `Settings` > `Environments` > `[YOUR ENVIRONMENT]` > `Add variable`. All steps must be done for both environments: `Development` and `Production`:

1. Create an `Elastic IP`. To do that: Open the AWS management console and open `EC2` > `Network & Security` > `Elastic IPs`. Now click on `Allocate Elastic IP address`, leave all settings unchanged and click on `Allocate`. You should now see your new elastic IP in the list. Click on it and copy the value `Allocation ID`.
    - Create an environment variable with the name `AWS_EIP_ALLOCATION_ID` and put in your copied allocation ID as the value.
