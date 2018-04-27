resource "aws_iam_policy" "s3" {
  name   = "s3"
  policy = "${data.aws_iam_policy_document.s3.json}"
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.build_artifacts.arn}",
      "${aws_s3_bucket.build_artifacts.arn}/*",
//      "arn:aws:s3:::elasticbeanstalk*",
    ]

    effect = "Allow"
  }
}




resource "aws_iam_role_policy_attachment" "codebuild_s3" {
  role       = "${module.build.role_arn}"
  policy_arn = "${aws_iam_policy.s3.arn}"
}

resource "aws_codepipeline" "foo" {
  name     = "tf-test-pipeline"
  role_arn = "${aws_iam_role.foo.arn}"

  artifact_store {
    location = "${aws_s3_bucket.build_artifacts.bucket}"
    type     = "S3"
//    encryption_key {
//      id   = "${data.aws_kms_alias.s3kmskey.arn}"
//      type = "KMS"
//    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "10"
      output_artifacts = ["${var.project_name}"]
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["${var.project_name}"]
      version         = "10"

      configuration {
        ProjectName = "test"
      }
    }
  }
}
