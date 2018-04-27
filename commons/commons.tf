provider "aws" {
  region = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile = "clouduct"
}

variable "region" {
  default = "eu-central-1"
}

variable "environments" {
  type = "list"
  default = ["dev", "stage", "prod"]
}

variable "project_name" {
  default = "clouduct1"
}

variable "environment" {
  default = "dev"
}

