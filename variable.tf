variable "type" {
  type = string
  default = "application" // application, network
}

variable "name" {
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

variable "internal" {
  type = bool
  default = true
}

variable "waf_acl_id" { // application only
  type    = string
  default = ""
}

variable "https_only" {
  default = false
}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
# ELBSecurityPolicy-2016-08 => Most accessible, >=TLS 1.0
# ELBSecurityPolicy-TLS-1-1-2017-01 => Most accessible, >=TLS 1.1
# ELBSecurityPolicy-TLS-1-2-2017-01 => Most secure, >=TLS 1.2, !SHA
variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS-1-1-2017-01"
}

variable "certificate_arn" {
  type = string
}

# ECS
variable "ports" {
  type    = list(number)
  default = [443, 80]
}

variable "autoscaling_group_name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "logging_bucket" {
  type    = string
  default = ""
}

