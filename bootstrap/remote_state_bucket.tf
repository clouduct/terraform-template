resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = "${var.project_name}-clouduct-terraform"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}
