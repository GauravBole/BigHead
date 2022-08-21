data "aws_iam_policy_document" "ECS_task_assume_role" {

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ECS_task_policy"{
    statement {
      sid = "ecsTaskPolicy"
      actions = [
        "ecr:*"
      ]  # ToDo: define specific actions
      resources = ["*"]
    }
}
output "role_value" {
  value = data.aws_iam_policy_document.ECS_task_policy.json
}

resource "aws_iam_role" "ECS_task_role" {
  name = "ECSTaskRole-tf"
  assume_role_policy = data.aws_iam_policy_document.ECS_task_assume_role.json
  inline_policy {
    name = "ECS_task_policy_tf"
    policy = data.aws_iam_policy_document.ECS_task_policy.json
  }
}