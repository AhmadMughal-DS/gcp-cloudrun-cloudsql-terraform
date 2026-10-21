locals {
  name_prefix = var.project_name
}

module "cloudrun" {
  source          = "./modules/cloudrun"
  name_prefix     = local.name_prefix
  region          = var.region
  environment     = var.environment
  container_image = var.container_image
  db_tier         = var.db_tier
  db_user         = var.db_user
  db_password     = var.db_password
}
