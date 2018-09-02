# Demo environment setup for Jenkins that includes
[Docker Image Update](https://github.com/salesforce/dockerfile-image-update) and [Argus Notifier plugin](https://plugins.jenkins.io/argus-notifier)

Scripts and automation to set up the following:
* [Jenkins](https://jenkins.io/) with the [Argus Notifier plugin](https://plugins.jenkins.io/argus-notifier)
* [Argus](https://github.com/salesforce/Argus)

## Getting Started

# Dependencies
You need the following installed on your system:
* AWS
* Terraform

# Step by step deploy process

 1. Setup your `~/.aws/config` and `~/.aws/credentials`
 1. [Install terraform](https://terraform.io)
 1. Configure the target from the root of the repo: `echo 'TF_domain=example.com' >> env.conf`
 1. `terraform init`
 1. `terraform apply`

## How it works
Terraform launches two autoscale groups: One for Jenkins master and another for
Jenkins nodes. 
The Jenkins master has a userdata script that ensures that docker gets installed
with git and other dependencies. 
