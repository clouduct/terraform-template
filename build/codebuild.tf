resource "aws_codebuild_project" "clouduct" {

  artifacts {
    type = "CODEPIPELINE"
  }

  build_timeout      = "5"
  service_role = "${aws_iam_role.cb_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/eb-java-8-amazonlinux-64:2.4.3"
    type = "LINUX_CONTAINER"
  }
  name = "${var.project_name}-cb"

  source {
    type = "CODEPIPELINE"
  }

  tags {
    environment = "${var.environment}"
    project = "${var.project_name}"
  }
}


resource "aws_iam_role" "cb_role" {
  name = "${var.project_name}-${var.environment}-cb-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# resource "aws_iam_role_policy" "cb_policy" {
#   name        = "${var.project_name}-${var.environment}-cb-pol"
#   role = "${aws_iam_role.cb_role.id}"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents],
#       "Effect": "Allow",
#       "Resource": "*"
#     },
#     {
#       "Action": [
#         "*:*"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:s3:::${var.project_name}-${var.environment}-*",
#         "arn:aws:kms:::${var.project_name}-${var.environment}-*",
#         "arn:aws:codecommit:::${var.project_name}-${var.environment}-*"
#       ]
#     }
#   ]
# }
# EOF
# }