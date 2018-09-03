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
 
# Once your environment is up

 1. Create a git personal access token for your org. Give it access to `repo` and `delete_repo`
 1. In Jenkins credentials register this token as Username-Password, where the username is your org name and password is the token
 1. Create another personal access token that has permissions to `admin:repo_hook` and `repo:status`
 1. In Jenkins credentials register this token as Secret text with only the token bearing it.
 1. Go to `jenkins/configure` and create a GitHub Server
 1. Next, create an ssh key `ssh-keygen -f <mydomain>`
 1. In Jenkins credentials, register this as an `SSH Username with private key`. Username should be `ec2-user`
 1. Register this key in EC2 as a new key pair
 1. Add a `secret text` credential: `DOCKER_PASSWORD`. This is your password for your docker registry
 1. Add another `secret text` credential: `DOCKERFILE_IMAGE_UPDATE_TOKEN`. This is your git token to the 
 service user for dockerfile-image-update. If you do not use a service user, dockerfile-image-update will 
 not be able to fork projects from the target org you are setting up. No forking, mean no pull requests. 

## How it works
Terraform launches two autoscale groups: One for Jenkins master and another for
Jenkins nodes. 
The Jenkins master has a userdata script that ensures that docker gets installed
with git and other dependencies. 
