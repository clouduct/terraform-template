terraform {
  backend "s3" {
    bucket = "cldct-vv-infra-dev-remote-state-bucket"
    key = "build"
    region = "eu-central-1"
  }
}
