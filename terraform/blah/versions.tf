terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  backend "s3" {
    bucket         = "kodak-lab-tfstate"
    key            = "kodak-lab-blah"
    region         = "eu-north-1"
    encrypt        = true
    kms_key_id     = "alias/kodak-lab-terraform-state-key"
    dynamodb_table = "kodak-lab-blah"
  }

  required_version = "~> 1.2.0"
}
