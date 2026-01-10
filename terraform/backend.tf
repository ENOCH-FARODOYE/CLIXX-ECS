terraform {
  backend "s3" {
    bucket  = "clixx-terraform-state-enoch"
    key     = "clixx-ecs/prod/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
