resource "aws_codebuild_project" "clouduct1" {

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/eb-java-8-amazonlinux-64:2.4.3"
    type = "LINUX_CONTAINER"
  }
  name = "clouduct1-cb"

  source {
    type = "CODECOMMIT"
  }
}
