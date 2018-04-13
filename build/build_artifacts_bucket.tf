resource "aws_s3_bucket" "build_artifacts" {
  bucket = "${var.project_name}-artifacts"
}
