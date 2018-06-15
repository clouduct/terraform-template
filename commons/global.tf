resource "aws_codecommit_repository" "infrastructure" {
  repository_name = "${var.project_name}-infra"
}

resource "aws_codecommit_repository" "application" {
  repository_name = "${var.project_name}"
}

resource "aws_elastic_beanstalk_application" "project" {
  name        = "${var.project_name}-beanstalk"
}

output "application_repository_name" {
  value = "${aws_codecommit_repository.application.repository_name}"
}

output "beanstalk_application" {
  value = "${aws_elastic_beanstalk_application.project.name}"
}
