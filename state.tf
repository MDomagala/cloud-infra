terraform {
  backend "s3" {
    bucket     = "my-bucket-service-ex.2"
    key        = "terraform.tfstate"
    region     = "eu-central-1"
    dynamodb_table = "lock-table"
  }
}