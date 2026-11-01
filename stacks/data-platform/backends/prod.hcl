bucket       = "beejan-cob-tfstate"
key          = "data-platform/prod/terraform.tfstate"
region       = "eu-west-1"
encrypt      = true
use_lockfile = true # S3-native locking (Terraform >= 1.10), no DynamoDB table
