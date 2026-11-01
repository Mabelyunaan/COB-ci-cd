variable "environment" {
  description = "Deployment environment."
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "project" {
  type    = string
  default = "data-platform"
}

variable "owner" {
  description = "Owning team, used for the Owner tag."
  type        = string
  default     = "data-engineering"
}

variable "raw_expiry_days" {
  description = "Days before raw objects are expired."
  type        = number
  default     = 90
}

variable "enable_crawler" {
  description = "Run the Glue crawler on a schedule."
  type        = bool
  default     = true
}
