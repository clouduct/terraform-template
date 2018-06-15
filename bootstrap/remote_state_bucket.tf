resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = "${var.bucket}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}
