provider "aws" {
  region = "${var.region}"
  version = "~> 1.22"
  shared_credentials_file = "~/.aws/credentials"
  profile = "clouduct"
}

variable "region" {
  default = "eu-central-1"
}

variable "project_name" {
}

variable "environment" {
  default = "dev"
}

variable "bucket" {
}

