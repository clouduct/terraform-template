provider "aws" {
  region = "${var.region}"
  version = "~> 1.22"
  shared_credentials_file = "~/.aws/credentials"
  profile = "clouduct"
}

terraform {
  backend "s3" {
  }
}

variable "region" {
  default = "eu-central-1"
}

variable "environments" {
  type = "list"
  default = ["dev", "stage", "prod"]
}

variable "project_name" {
}

variable "environment" {
  default = "dev"
}

