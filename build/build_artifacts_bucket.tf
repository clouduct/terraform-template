resource "aws_s3_bucket" "pipeline" {
  bucket = "${var.project_name}-pipe"
  tags {
    project = "${var.project_name}"
  }
}
