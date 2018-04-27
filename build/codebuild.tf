resource "aws_codebuild_project" "" {

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/eb-java-8-amazonlinux-64:2.4.3"
    type = "LINUX_CONTAINER"
  }
  name = ""

  source {
    type = "CODECOMMIT"
  }
}


resource "aws_codebuild_project" "foo" {
  name         = "test-project"
  description  = "test_codebuild_project"
  build_timeout      = "5"
  service_role = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = "${aws_s3_bucket.foo.bucket}"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/nodejs:6.3.1"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "SOME_KEY1"
      "value" = "SOME_VALUE1"
    }

    environment_variable {
      "name"  = "SOME_KEY2"
      "value" = "SOME_VALUE2"
    }
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/mitchellh/packer.git"
  }

  vpc_config {
    vpc_id = "vpc-725fca"

    subnets = [
      "subnet-ba35d2e0",
      "subnet-ab129af1",
    ]

    security_group_ids = [
      "sg-f9f27d91",
      "sg-e4f48g23",
    ]
  }

  tags {
    "Environment" = "Test"
  }
}
