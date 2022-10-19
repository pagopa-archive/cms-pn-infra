# Cluster
resource "aws_ecs_cluster" "main" {
  name = local.ecs_cluster_name
  tags = { Name = local.ecs_cluster_name }
}

# IAM
data "aws_iam_policy_document" "task_execution" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}