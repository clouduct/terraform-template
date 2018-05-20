resource "aws_s3_bucket" "build_artifacts" {
  bucket = "${var.project_name}-artifacts"
  tags {
    environment = "${var.environment}"
    project = "${var.project_name}"
  }
}
