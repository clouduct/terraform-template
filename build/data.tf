data "terraform_remote_state" "commons" {
  backend = "s3"
  config {
    bucket = "${var.bucket}"
    key = "commons"
    region = "${var.region}"
  }
}