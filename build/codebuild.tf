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


resource "aws_iam_role_policy" "cb_policy" {
  name = "${var.project_name}-${var.environment}-cb-pol"
  role = "${aws_iam_role.cb_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:Arn": ["arn:aws:*:::${var.project_name}-${var.environment}-*"]
        }
      }
    },
    {
      "Action": "codecommit:GitPull",
      "Effect": "Allow",
      "Resource": "${aws_codecommit_repository.application.arn}"
    }

  ]
}
EOF
}


resource "aws_iam_role_policy" "cp_policy" {
  name = "${var.project_name}-${var.environment}-cp-pol"
  role = "${aws_iam_role.cp_role.id}"

  policy = <<EOF
{
    "Statement": [
        {
          "Action": "*",
          "Effect": "Allow",
          "Resource": "*",
          "Condition": {
            "StringLike": {
              "aws:Arn": ["arn:aws:*:::${var.project_name}-${var.environment}-*"]
            }
          }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": [
                "${aws_codecommit_repository.application.repository_name}"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:StartBuild",
                "codebuild:BatchGetBuilds",
                "codebuild:StopBuild"
            ],
            "Resource": [
                "${var.aws_codebuild_project.clouduct.arn}"
            ],
            "Effect": "Allow"
        },

        // TODO
        {
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::aws-codestar-eu-central-1-103564381786-clouduct0-pipe",
                "arn:aws:s3:::aws-codestar-eu-central-1-103564381786-clouduct0-pipe/*",
                "arn:aws:s3:::elasticbeanstalk*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:CreateBucket"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudformation:GetTemplate",
                "cloudformation:ListStackResources",
                "cloudformation:UpdateStack",
                "cloudformation:DescribeStack*"
            ],
            "Resource": [
                "arn:aws:cloudformation:eu-central-1:103564381786:stack/awseb-e-*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role" "cp_role" {
  name = "${var.project_name}-${var.environment}-cp-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_codepipeline" "codepipeline" {
  name     = "${var.project_name}-${var.environment}-pipeline"
  role_arn = "${aws_iam_role.cp_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.pipeline.bucket}"
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
      version          = "1"
      input_artifacts  = []
      output_artifacts = ["${var.project_name}-source"]

      configuration {
        // Owner      = "my-organization"
        RepositoryName = "${aws_codecommit_repository.application.repository_name}"
        BranchName     = "master"
      }
    }
  }

  stage {
  name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["${var.project_name}-source"]
      output_artifacts = ["${var.project_name}-deployable"]
      version         = "1"

      configuration {
        ProjectName = "test"
      }
    }
  }
}




