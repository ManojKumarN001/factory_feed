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



############# terraform cloud backend #######################

# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "Terraform_Infra_Automation"

#     workspaces {
#       name = "Terraform_01"
#     }
#   }
# }

