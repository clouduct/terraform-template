resource "aws_elastic_beanstalk_application" "project" {
  name        = "${var.project_name}-beanstalk"
}

output "beanstalk_application_name" {
  value = "${aws_elastic_beanstalk_application.project.name}"
}
