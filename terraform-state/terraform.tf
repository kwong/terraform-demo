terraform {
    backend "s3" {
        bucket = "terraform-wkngw1009-state"
        key = "workspace-example/terraform.tfstate"
        region = "us-east-2"

        dynamodb_table = "terraform-state-wkngw1009-locks"
        encrypt = true
    }
}