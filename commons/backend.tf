terraform {
  backend "s3" {
    bucket = "${var.project_name}-infra-${var.environment}-remote-state-bucket"
    key    = "${var.state_key}"
    region = "${var.region}"
  }
}
