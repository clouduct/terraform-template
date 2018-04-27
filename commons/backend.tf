terraform {
  backend "s3" {
    bucket = "clouduct1-infra-dev-remote-state-bucket"
    key    = "build"
    region = "eu-central-1"
  }
}
