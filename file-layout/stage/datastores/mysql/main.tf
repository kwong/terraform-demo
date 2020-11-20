provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "~/.aws/credentials"
}

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-demo"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    name = "example_database"
    username = "admin"
    password = var.db_password

}

terraform {
    backend "s3" {
        bucket = "terraform-wkngw1009-state"
        key = "stage/datastores/mysql/terraform.tfstate"
        region = "us-east-2"

        dynamodb_table = "terraform-state-wkngw1009-locks"
        encrypt = true
    }
}