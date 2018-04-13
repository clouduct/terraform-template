resource "aws_codecommit_repository" "infrastructure" {
  repository_name = "${var.project_name}-infra"
}

resource "aws_codecommit_repository" "application" {
  repository_name = "${var.project_name}"
}
