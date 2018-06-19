data "terraform_remote_state" "global" {
  backend = "s3"
  config {
    bucket = "${var.bucket}"
    key = "global"
    region = "${var.region}"
  }
}
