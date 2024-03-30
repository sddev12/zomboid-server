variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "task_cpu" {
  type    = number
  default = 1024
}

variable "task_memory" {
  type    = number
  default = 2048
}

variable "aws_ecr_url" {
  type = string
}

variable "container_image_version" {
  type    = string
  default = "latest"
}

variable "tags" {
  type = map(string)

  default = {
    "app" = "zomboid-server"
  }
}
