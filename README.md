# Project README

## Overview

This project automates the deployment of a Dockerized application on an AWS EC2 instance using Terraform for infrastructure provisioning and Ansible for configuration management.

## Prerequisites

- AWS Account
- Terraform installed
- Ansible installed
- Docker installed
- SSH Key Pair

## Setup

### AWS Credentials

Ensure your AWS credentials are configured by setting up the AWS CLI or by configuring Terraform's AWS provider with your `access_key` and `secret_key`.

### SSH Key Pair

Create an SSH key pair in the AWS console. Download the private key (e.g., `Ubuntu.pem`) and set the correct permissions:

```bash
chmod 400 /path/to/Ubuntu.pem
```

### Terraform

Navigate to the Terraform directory and initialize the Terraform environment:

```bash
terraform init
```

Apply the Terraform plan to create the infrastructure:

```bash
terraform apply
```

Confirm the actions by typing `yes` when prompted.

### Ansible

Update the Ansible inventory file (`hosts`) with the EC2 instance's IP address and the path to your SSH private key.

Run the Ansible playbook to configure the EC2 instance:

```bash
ansible-playbook -i hosts playbook.yaml
```

## Docker Application

The Ansible playbook includes tasks for installing Docker and deploying a Dockerized application. Ensure your application's Dockerfile and related source files are located in the specified directory.

## Accessing the Application

After deployment, access your application by navigating to the EC2 instance's public IP address in your browser.

## Clean Up

To avoid incurring unnecessary charges, remember to destroy the resources created by Terraform when they are no longer needed:

```bash
terraform destroy
```

Confirm the destruction by typing `yes` when prompted.

## Security Considerations

- Limit SSH access to your IP address.
- Regularly update your application and infrastructure to patch security vulnerabilities.
- Use IAM roles and policies to provide minimal necessary access to services.

## Support

For support, please open an issue in the project repository or contact the project maintainer directly.

---