# DevOps Project (SoSe 2023)

## Deadlines

- 31/05/2023: Submission of [Project Concept](./concept.md)
- 25/08/2023: Submission of Project Implementation

## Steps to reproduce

### Variables & Secrets

#### Repository secrets

You will need to provide several values as repository secrets for this workflow to run successfully. You can add repository secrets under the following path: `Settings` > `Secrets and variables` > `Actions` > `Secrets` > `New repository secret`

1. Create a GitHub token with `package:read` and `package:write` permissions [here](https://github.com/settings/tokens/new).
    - Put this token in a secret of this repository with the name `GHCR_TOKEN`.
2. Get your AWS credentials `aws_access_key_id`, `aws_secret_access_key` and `aws_session_token`.
    - Put these tokens in secrets of this repository with the names `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` respectively.
3. Create SSH keys locally by running the script in `infrastructure/create-ssh-keys.sh`.
    - Copy the content of the file `.ssh/operator.pub` into a new secret with the name `SSH_PUBLIC_KEY`.
    - Copy the content of the file `.ssh/operator` into a new secret with the name `SSH_PRIVATE_KEY`.

#### Repository variables

You will also need to provide some repository variables. Repository variables can be created under the following path:  `Settings` > `Secrets and variables` > `Actions` > `Variables` > `New repository variable`

1. Create a repository variable with the name `AWS_DEFAULT_REGION` and enter your desired region as value (usually: `us-east-1`).
2. Follow the steps in the `FQDN` section down below.
    - Create a repository variable with the name `AWS_HOSTED_ZONE_ID` and enter your hosted zone id as value.

#### Environment variables

Some variables differ for each environment. To create an environment variable on GitHub: `Settings` > `Environments` > `[YOUR ENVIRONMENT]` > `Add variable`. All steps must be done for both environments: `Development` and `Production`:

1. Create an `Elastic IP`. To do that: Open the AWS management console and open `EC2` > `Network & Security` > `Elastic IPs`. Now click on `Allocate Elastic IP address`, leave all settings unchanged and click on `Allocate`. You should now see your new elastic IP in the list. Click on it and copy the value `Allocation ID`.
    - Create an environment variable with the name `AWS_EIP_ALLOCATION_ID` and put in your copied allocation ID as the value.
    - Note: You will need two different elastic IPs: One for `Development` and one for `Production`.
2. Setup a domain like described down below in the `FQDN` section. Then create an environment variable with the name `DOMAIN` and put in your domain as the value (e.g. `dev.example.com` for development).
    - Note: You will need two subdomains: One for `Development` and one for `Production`.

#### Control check

Here is the list of all variables and secrets that you will need to setup:

- [ ] `GHCR_TOKEN` (Repository secret)
- [ ] `AWS_ACCESS_KEY_ID` (Repository secret)
- [ ] `AWS_SECRET_ACCESS_KEY` (Repository secret)
- [ ] `AWS_SESSION_TOKEN` (Repository secret)
- [ ] `SSH_PUBLIC_KEY` (Repository secret)
- [ ] `SSH_PRIVATE_KEY` (Repository secret)
- [ ] `AWS_DEFAULT_REGION` (Repository variable)
- [ ] `AWS_HOSTED_ZONE_ID` (Repository variable)
- [ ] `AWS_EIP_ALLOCATION_ID` (Environment variable; one for each environment)
- [ ] `DOMAIN` (Environment variable; one for each environment)

### FQDN

This section describes the setup of an FQDN. Unfortunately, the access to the Namecheap API has some requirements that I don't fulfill as you can read [here](https://www.namecheap.com/support/knowledgebase/article.aspx/9739/63/api-faq/#c). That means, that there is some minor manual setup necessary. All necessary steps are explained in the following.

#### Prerequisites

It is assumed that you already own a domain at some domain name registrar. The next section explains the setup for `Namecheap`. Some of the steps may vary for you if you own a domain at a different domain name registrar.

#### Manual setup

1. Open the AWS Management console
2. Navigate to the `Route 53` section and navigate then to `Hosted zones`
3. Click on `Create hosted zone` and type in the name of your domain in the `Domain name` field
4. Leave all other fields unchanged and click on `Create hosted zone`
5. Now your new hosted zone should appear in the list in the `Hosted zones` section
6. Click on it and select the already existing record of type `NS`
7. Copy all the values (a value looks similar to this: `ns-319.awsdns-39.com`)
8. Login into your `Namecheap` account and navigate to `Domain list`
9. Look for your domain and click on `Manage`
10. Look for the `Nameservers` section and make sure that `Custom DNS` is selected
11. Enter your copied values from step 7 as nameservers
12. You're done!

#### Values for variables & secrets

Copy the following values from the manual setup for the `Variables & Secrets` section:

- `DOMAIN`: This is your domain you used for the manual setup (e.g. `example.com`). Note however, that the environment variables need your desired subdomain as prefix (e.g. `dev.example.com`).
- `AWS_HOSTED_ZONE_ID`: Select your hosted zone in the AWS management console and copy the `Hosted zone ID` under `Hosted zone details`

### Deployment review

To have the deployment to the `Production` environment happen in a controlled manner, follow the next steps:

1. Open the settings for your `Production` environment in GitHub under: `Settings` > `Environments` > `Production`
2. Click the `Required reviewers` checkbox in the `Deployment protection rules` section and add your desired reviewers

## Trigger pipeline

Push a new commit to `main` to trigger the pipeline. By default, each commit will be deployed to the `Development` environment. If you have setup `Required reviewers` for your `Production` environment, the deployment will need a manual review for that environment.
