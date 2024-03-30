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
