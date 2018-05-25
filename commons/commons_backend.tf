terraform {
  backend "s3" {
    bucket = "cldct-vv-infra-dev-remote-state-bucket"
    region = "eu-central-1"
  }
}
