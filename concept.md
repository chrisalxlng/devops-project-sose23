# Project Concept: 932459

## Goal

- Goal of the project work is to deploy an application in a cloud or cloud-simulated environment by providing all the services required for the application to function properly in multiple environments and an automated manner
- The [app](./deployable/) to be deployed is a simple ToDo application cloned from [this repo](https://github.com/lucendio/lecture-devops-app)

## Target Environments

Each of the following environment is represented by its own branch in this repository:

- Production (`prod`)
  - The `prod` environment is the place where real-world customers use and depend on this application which is why this environment needs to be stable
- Development (`dev`)
  - The `dev` environment is is used during development and can therefore be unstable at times

The described target environments and branching strategy influenced by [this article](https://dev.to/preethamsathyamurthy/git-branching-and-branching-strategy-4mci) was chosen because of positive personal experience and their popularity in general.

## Tech Stack

- [GitHub Actions](https://github.com/features/actions)
  - Integrated CI/CD solution by GitHub
  - Represents platform of CI/CD Pipeline
  - Chosen because of personal preference of GitHub
- [Docker](https://www.docker.com)
  - Represents containerization tool and load balancer (Docker Compose `--scale` option)
  - Chosen because its status of being one of the most commonly used containerization tools and therefore being a good skill to have
  - Responsible for containerizing `client` (React), `server` (Node/Express), `database` (MongoDB) and `nginx` to simplify running these on an EC2 instance
    - Also responsible for container networking (e.g. which container uses which port)
- [Nginx](https://www.nginx.com/)
  - Represents web server, & reverse proxy
  - Chosen because its status of being one of the most commonly used web server tools
- [AWS](https://aws.amazon.com/)
  - Represents platform where all environments will be hosted
  - Including AWS CLI to define infrastructure
  - Chosen because of its status as one of the most popular hosting solutions and because it is one of two tools with access to credentials
  - Planned AWS services to use (list might be incomplete due to inexperience with AWS): EC2
- [Terraform](https://www.terraform.io)
  - Represents tool to define infrastructure
  - Chosen because of its status as one of the most popular infrastructure tools
- [Certbot](https://certbot.eff.org/)
  - Represents tool for aquisition of trusted SSL certificates
  - Chosen because of its popularity and availability for no costs

## Automation Processes & Application Lifecycle

- Development workflows
  - `push` -> `master`:
    - Build application image
    - Test application image
    - Release application image
    - Deploy to `dev` environment
      - Create DNS record
      - Create AWS EC2 instance
      - Deploy app to EC2 instance via SSH
      - Re-route traffic to new instance when healthy with AWS Elastic IP
      - Configure SSL certificate with certbot
      - Terminate old EC2 instance

- Production workflows
  - `push` -> `master` + explicit approval:
    - Build application image
    - Test application image
    - Release application image
    - Deploy to `prod` environment
      - Create DNS record
      - Create AWS EC2 instance
      - Deploy app to EC2 instance via SSH
      - Re-route traffic to new instance when healthy with AWS Elastic IP
      - Configure SSL certificate with certbot
      - Terminate old EC2 instance

All triggers that do not appear in the previous section are not allowed.

## Load Balancing

The `app` is running with a replication factor of 2. This is realised through the `--scale` option with `Docker Compose`. This means that two instances of the `app` container are running at all times and requests are distributed between these two in a "round robin" fashion.

## Zero-Downtime Deployment

Zero-Downtime deployment is realised through `AWS Elastic IP`. That means that for each environment there exists an elastic IP that the FQDN (e.g. `prod.christopherlang.me`) is pointing to.

For each new deployment, there will be created a new EC2 instance. This instance gets a random IP address by AWS and is therefore not reachable yet. The application gets deployed on that new instance and as soon as the instance is healthy, the new instance gets assigned the elastic IP for its environment. By doing that, the new instance will be reachable via the FQDN and the old one will be terminated after that.

## Links

- [Repository of Deployable App](https://github.com/lucendio/lecture-devops-app)
- [Project Concept Requirements](https://devops-lecture.as-code.link/assignments/deliverables/project-concept/)
- [Project Grading](https://devops-lecture.as-code.link/grading/)
