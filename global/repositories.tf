resource "aws_codecommit_repository" "infrastructure" {
  repository_name = "${var.project_name}-infra"
}

resource "aws_codecommit_repository" "application" {
  repository_name = "${var.project_name}"

  provisioner "local-exec" {
    command = "./initial-commit.sh ${aws_codecommit_repository.application.clone_url_ssh} "
    working_dir = "../../${var.project_name}"
  }
}

output "application_repository_name" {
  value = "${aws_codecommit_repository.application.repository_name}"
}

