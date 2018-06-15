resource "aws_s3_bucket" "pipeline" {
  bucket = "${var.project_name}-pipe"
  tags {
    project = "${var.project_name}"
  }
}


resource "aws_s3_bucket_policy" "s3_pipeline_bucket_pol" {
  bucket = "${aws_s3_bucket.pipeline.id}"
  policy =<<POLICY
{
    "Version": "2012-10-17",
    "Id": "SSEAndSSLPolicy",
    "Statement": [
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.pipeline.arn}/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "aws:kms"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.cb_role.arn}",
                    "${aws_iam_role.cp_role.arn}"
                ]
            },
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning",
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.pipeline.arn}/*",
                "${aws_s3_bucket.pipeline.arn}"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        }
    ]
}
POLICY
}