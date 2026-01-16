CredPal DevOps Assessment – Node.js Application

AUTHOR: ADARAMOLA P. OLAMIDE 
ROLE: DevOps Engineer

AIM:
This repository contains a simple Node.js application and a complete production-ready DevOps setup, including containerization, CI/CD automation, and cloud infrastructure provisioning using Terraform on AWS.

APPLICATION OVERVIEW

The application is a basic Node.js (Express) service exposing the following endpoints and running on port 3000:

| Endpoint   | Method | Description                                            |
| ---------- | ------ | ------------------------------------------------------ |
| `/health`  | GET    | Health check endpoint                                  |
| `/status`  | GET    | Returns application status and processed request count |
| `/process` | POST   | Simulates request processing and increments a counter  |

Redis is used to store and track the processed request count.

RUNNING THE APPLICATION LOCALLY

Prerequisites
- Docker
- Docker Compose

STEPS:

- Clone the repository:
git clone https://github.com/bigstacko/credpal-devops-assessment.git
cd credpal-devops-assessment/

- Start the application and Redis using Docker Compose:
docker-compose up --build

- Access the application:
http://localhost:3000/health
http://localhost:3000/status

- Test the /process endpoint:
curl -X POST http://localhost:3000/process

What happens locally?

Docker Compose creates a private network
The Node.js container connects to Redis using the service name redis
Data is persisted using Docker volumes

__________________________________________________________________________________________________________________________________________

CLOUD INFRASTRUCTURE SETUP (AWS)

The infrastructure is provisioned using Terraform and follows AWS best practices.

Internet
   ↓
Application Load Balancer (Public Subnets)
   ↓
ECS Fargate Service (Private Subnets)
   ↓
Redis (External / Managed in production - ElastiCache)

INFRASTRUCTURE COMPONENTS

- Networking

Custom VPC
Public subnets (ALB)
Private subnets (ECS tasks)
Internet Gateway for inbound traffic
NAT Gateway for outbound internet access from private subnets (For Image pull)

- Compute

Amazon ECS (Fargate launch type)
ECS Service with rolling deployments
Tasks run as non-root containers

- Load Balancing

Application Load Balancer
Health checks using /health
Traffic routed only to healthy tasks

- Security

Security Groups with least-privilege access
ALB allows inbound HTTP traffic
ECS tasks only accept traffic from ALB
No secrets stored in source code

- Observability

Logs shipped automatically to CloudWatch Logs
ALB and ECS health checks enable self-healing


CI/CD Pipeline (GitHub Actions)

The CI/CD pipeline is fully automated using GitHub Actions.

Pipeline Triggers:

Push to main
Pull Requests targeting main

CI/CD Flow

Code Push
   ↓
Run Tests
   ↓
Build Docker Image
   ↓
Push Image to Docker Hub
   ↓
Manual Approval (Production)
   ↓
Terraform Apply
   ↓
ECS Rolling Deployment

1. Test Stage

Installs dependencies
Runs basic application tests
Prevents broken builds from being deployed

2. Build & Push Stage

Builds a Docker image
Tags the image with the Git commit SHA (immutable versioning)
Pushes the image to Docker Hub

3. Deployment Stage

Requires manual approval via GitHub Environments
Terraform provisions/updates AWS infrastructure
ECS performs a rolling deployment with zero downtime

- Secrets Management

All secrets are stored in GitHub Actions Secrets
No credentials are committed to the repository
AWS credentials are injected securely using GitHub Actions
Image tagging ensures traceability and easy rollback

- Deployment Strategy

Rolling deployments via ECS
Load balancer health checks ensure zero downtime
Unhealthy tasks are automatically replaced
Manual approval gate protects production deployments