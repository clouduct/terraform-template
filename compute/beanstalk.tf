resource "aws_key_pair" "beanstalk_ssh" {
  key_name = "${var.project_name}-${var.environment}-beanstalk_ssh"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkGsR1EK6I0prq5pSR6ln1i1pZ2A0LG7Z9M2fWSMrEjdPCb7lw7jgqFYt6Uv7wmAAtmxMm9Gz8csd2FBHkLxJxuK6Nu+vxBb96h9CTGR9frhXcpEULKG1oIIvboqnse7ds0gHlv8lTyX3ypdITj95y1aZQW3pnpadCgvG7HsaW99Lh12lJ7Hfj40k9uCgcn/Vqw5eLgf1Wm/p0LgxG0fVZ12oxlw3n4ZH35FGukhQEQ3SzMZWpB0WhrL9A5JX/DlMrO8Z7gpF+mNlsCgEP9jx3d5Hb4F96jfpPjC4xAfSXF0WmLAd1bCIVxkZyyiNy2u5xioEKaP2Y+fgwkA/NY1Qr dev@clouduct.org"
  # public_key = "${file("/Users/vivo/.ssh/id_rsa.pub")}"
}

resource "aws_elastic_beanstalk_environment" "beanstalk_environment" {
  name = "${var.project_name}-${var.environment}-be"
  application = "${data.terraform_remote_state.global.beanstalk_application_name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.7.4 running Java 8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.ec2_instanceprofile.name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "${aws_iam_role.eb_service_role.name}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "EC2KeyName"
    value = "${aws_key_pair.beanstalk_ssh.id}"
  }
}

output "beanstalk_environment_name" {
  value = "${aws_elastic_beanstalk_environment.beanstalk_environment.name}"
}

//__________

resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.project_name}-${var.environment}-ec2_instance_role"
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

resource "aws_iam_role_policy_attachment" "ec2_instanceprofile_poweruser" {
  role = "${aws_iam_role.ec2_instance_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_instanceprofile_beanstalk" {
  role = "${aws_iam_role.ec2_instance_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_instance_profile" "ec2_instanceprofile" {
  name = "${var.project_name}-${var.environment}-ec2_instance-profile"
  role = "${aws_iam_role.ec2_instance_role.name}"
}

//__________

resource "aws_iam_role" "eb_service_role" {
  name = "${var.project_name}-${var.environment}-eb-service-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
           "Service": "elasticbeanstalk.amazonaws.com"
        },
        "Effect": "Allow",
        "Condition": {
          "StringEquals": {
            "sts:ExternalId": "elasticbeanstalk"
          }
        }
     }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eb_service_attach_service" {
  role = "${aws_iam_role.eb_service_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_role_policy_attachment" "eb_service_attach_health" {
  role = "${aws_iam_role.eb_service_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}
