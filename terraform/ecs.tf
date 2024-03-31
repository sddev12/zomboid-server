# Use the template_file data source to allow values in our task definition template to be replaced
# with values from variables on apply
data "template_file" "container-definition" {
  template = file("${path.module}/container_definitions.json.tpl")
  vars = {
    aws_ecr_url = var.aws_ecr_url
    tag         = var.container_image_version
    aws_region  = var.aws_region
  }
}

resource "aws_ecs_cluster" "zomboid_server" {
  name = "zomboid-server"

  tags = var.tags
}

# Define the capacity provider for the cluster as ECS Fargate
resource "aws_ecs_cluster_capacity_providers" "zomboid_server" {
  cluster_name = aws_ecs_cluster.zomboid_server.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# Create the task definition using our templated task definition file
resource "aws_ecs_task_definition" "zomboid_server" {
  family                   = "spitlog"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.container-definition.rendered

  tags = var.tags
}

# Create the ECS service
resource "aws_ecs_service" "zomboid_server" {
  name            = "splitlog"
  cluster         = aws_ecs_cluster.zomboid_server.id
  task_definition = aws_ecs_task_definition.zomboid_server.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.public.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.zomboid_server_16261.arn
    container_name   = var.container_name
    container_port   = 16261
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.zomboid_server_16262.arn
    container_name   = var.container_name
    container_port   = 16262
  }

  tags = var.tags
}
