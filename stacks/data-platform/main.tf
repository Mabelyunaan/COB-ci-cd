locals {
  tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
    Platform    = "cob"
  }
}

# --- Object storage: three buckets, one COB capability, three configurations ---
module "raw" {
  source = "git::https://github.com/beejan-technologies/cob.git//modules/object-storage?ref=v1.0.0"

  project     = var.project
  environment = var.environment
  purpose     = "raw"
  expiry_days = var.raw_expiry_days
}

module "curated" {
  source = "git::https://github.com/beejan-technologies/cob.git//modules/object-storage?ref=v1.0.0"

  project     = var.project
  environment = var.environment
  purpose     = "curated"
}

module "athena_results" {
  source = "git::https://github.com/beejan-technologies/cob.git//modules/object-storage?ref=v1.0.0"

  project     = var.project
  environment = var.environment
  purpose     = "athena-results"
  expiry_days = 7
}

# --- Identity: least-privilege roles for the two kinds of users ---
module "access" {
  source = "git::https://github.com/beejan-technologies/cob.git//modules/identity-access?ref=v1.0.0"

  project     = var.project
  environment = var.environment

  roles = {
    ingestion = {
      trusted_services = ["glue.amazonaws.com"]
      read_write       = [module.raw.bucket_arn, module.curated.bucket_arn]
      read_only        = []
    }
    analyst = {
      trusted_services = ["athena.amazonaws.com"]
      read_write       = [module.athena_results.bucket_arn]
      read_only        = [module.curated.bucket_arn]
    }
  }
}

# --- Data platform: Glue catalog + Athena workgroup over the curated bucket ---
module "analytics" {
  source = "git::https://github.com/beejan-technologies/cob.git//modules/data-platform?ref=v1.0.0"

  project     = var.project
  environment = var.environment

  data_bucket_id         = module.curated.bucket_id
  data_bucket_arn        = module.curated.bucket_arn
  results_bucket_id      = module.athena_results.bucket_id
  crawler_role_arn       = module.access.role_arns["ingestion"]
  enable_crawler         = var.enable_crawler
}
