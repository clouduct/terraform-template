resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = "${var.project_name}-infra-${var.environment}-remote-state-bucket"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
