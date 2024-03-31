# Project Zomboid Dedicated Server
[![Deploy Zomboid Server](https://github.com/sddev12/zomboid-server/actions/workflows/deploy_zomboid_server.yml/badge.svg)](https://github.com/sddev12/zomboid-server/actions/workflows/deploy_zomboid_server.yml)

**This project is currently WIP**

**Todo:**
- Finish build/deploy actions workflow
- Build Tear Down Workflow
- Set up EFS for Docker volume in Terraform
- Test Terraform and AWS Infra


## Overview
This project provides a fully automated solution for deploying a dedicated [Project Zomboid](https://pzwiki.net/wiki/Dedicated_server) server to AWS

### Docker Image
The included Dockerfile creates an [Ubuntu](https://ubuntu.com/) container with [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) and the [Project Zomboid Dedicated Server](https://pzwiki.net/wiki/Dedicated_server) installed and ready to run.

We utilise AWS EFS for the docker volume to facilitate persistent storage for the container allowing for server config, gameworld etc to be persisted permanently when the container is re-deployed.

### Infrastructure As Code
We are using [Terraform](https://www.terraform.io/) as our IaC solution which allows for all AWS infrastructure to be deployed and maintained along with the Zomboid Server as code.

### CI/CD Pipelines
We are using [Github Actions](https://github.com/features/actions) to automate the build, deployment and tear down processes. 

This repo incudes two Github Actions Workflows (pipelines)

**Deploy Zomboid Server**
- Builds the docker image
- Pushes to a DockerHub registry
- Provisions AWS infrastructure with Terraform
- Deploys the Zomboid-Server container to ECS (deployment is done as part of the terraform apply although this may change)

<br>

**Tear Down Zomboid Server**
- Removes the Zomboid Server and all related AWS infrastructure from your AWS account.

<br>

## Architecture Design
![Architecture Diagram](/img/zomboid-server-architecture.png)

## CI/CD Pipeline (Workflows) Design
![Github Actions Workflow Diagram](/img/githubactions-workflow-design.png)

## Usage
