resource "aws_elastic_beanstalk_application" "project" {
  name        = "${var.project_name}-beanstalk"
}

output "beanstalk_application" {
  value = "${aws_elastic_beanstalk_application.project.name}"
}
