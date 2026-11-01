output "raw_bucket" {
  value = module.raw.bucket_id
}

output "curated_bucket" {
  value = module.curated.bucket_id
}

output "athena_workgroup" {
  value = module.analytics.workgroup_name
}

output "glue_database" {
  value = module.analytics.database_name
}
