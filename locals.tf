module "defaults" {
  source = "git@github.com:willfarrell/terraform-defaults?ref=v0.1.0"
  name   = var.name
  tags   = var.default_tags
}

locals {
  account_id     = module.defaults.account_id
  name           = "${module.defaults.name}-${substr(var.type, 0, 1)}lb"
  tags           = module.defaults.tags
  ports_no_https = concat(slice(var.ports, 0, index(var.ports, 443)), slice(var.ports, (index(var.ports, 443)+1), length(var.ports)))

  logging_bucket = "${var.logging_bucket != "" ? var.logging_bucket : "${module.defaults.name}-${terraform.workspace}-${module.defaults.region}-logs"}}"
}

