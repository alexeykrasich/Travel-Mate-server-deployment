
terraform {
  cloud {
    organization = "devprod"

    workspaces {
      name = "kub"
    }
  }
}


provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
}

