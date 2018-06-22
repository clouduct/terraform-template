resource "aws_elastic_beanstalk_environment" "beanstalk_environment" {
  name = "${var.project_name}-${var.environment}-be"
  application = "${data.terraform_remote_state.global.beanstalk_application_name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.7.2 running Java 8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.ec2_instanceprofile.name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "${aws_iam_instance_profile.ec2_service.name}"
  }
}

output "beanstalk_environment_name" {
  value = "${aws_elastic_beanstalk_environment.beanstalk_environment.name}"
}

//__________

resource "aws_iam_role" "ec2_instanceprofile_role" {
  name = "${var.project_name}-${var.environment}-ec2_instanceprofile_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_instanceprofile_attach" {
  role = "${aws_iam_role.ec2_instanceprofile_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_instance_profile" "ec2_instanceprofile" {
  name = "${var.project_name}-${var.environment}-ec2_instance-profile"
  role = "${aws_iam_role.ec2_instanceprofile_role.name}"
}

//__________

resource "aws_iam_role" "ec2_service_role" {
  name = "${var.project_name}-${var.environment}-ec2-service-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_service_attach" {
  role = "${aws_iam_role.ec2_service_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_instance_profile" "ec2_service" {
  name = "${var.project_name}-${var.environment}-ec2-service-profile"
  role = "${aws_iam_role.ec2_service_role.name}"
}
