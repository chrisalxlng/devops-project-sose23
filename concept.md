# Project Concept: 932459

> **This concept is an initial version/work-in-progress and will be updated during the lifecycle of this project.**

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
  - Represents containerization tool
  - Chosen because its status of being one of the most commonly used containerization tools and therefore being a good skill to have
  - Responsible for containerizing `client` (React/Nginx), `server` (Node/Express) and `database` (MongoDB) to simplify running these on an EC2 instance
    - Also responsible for container networking (e.g. which container uses which port)
- [Nginx](https://www.nginx.com/)
  - Represents load balancer, web server, & reverse proxy
  - Chosen because its status of being one of the most commonly used web server tools
- [AWS](https://aws.amazon.com/)
  - Represents platform where all environments will be hosted
  - Chosen because of its status as one of the most popular hosting solutions and because it is one of two tools with access to credentials
  - Planned AWS services to use (list might be incomplete due to inexperience with AWS): EC2
- [Terraform](https://www.terraform.io)
  - Represents tool to define infrastructure
  - Chosen because of its status as one of the most popular infrastructure tools

## Automation Processes & Application Lifecycle

- Development workflows
  - `push` -> `master`:
    - Install dependencies
    - Build application
    - Linting
    - Run client tests
    - Run server tests
    - Deploy to `dev` environment
- Production workflows
  - `push` -> `master` + explicit approval:
    - Install dependencies
    - Build application
    - Linting
    - Run client tests
    - Run server tests
    - Deploy to `prod` environment

All triggers that do not appear in the previous section are not allowed.

## Links

- [Repository of Deployable App](https://github.com/lucendio/lecture-devops-app)
- [Project Concept Requirements](https://devops-lecture.as-code.link/assignments/deliverables/project-concept/)
- [Project Grading](https://devops-lecture.as-code.link/grading/)
