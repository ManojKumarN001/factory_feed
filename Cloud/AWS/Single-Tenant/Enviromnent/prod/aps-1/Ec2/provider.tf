########################## terraform Provider #########################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

############# Configure the AWS Provider #################

provider "aws" {
  alias  = "aps"
  region = var.region
}



############## terraform workspace connection ##############

# data "terraform_remote_state" "vpc" {
#   backend = "remote"
#   config = {
#     organization = "Terraform_Infra_Automation"
#     workspaces = {
#       name = "Terraform_01"
#     }
#   }
# }
