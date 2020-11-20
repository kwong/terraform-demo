provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "~/.aws/credentials"
}

resource "aws_s3_bucket" "terraform_state" {
    # name of our bucket
    bucket = "terraform-wkngw1009-state"

    # prevent bucket from being destroyed
    lifecycle {
        prevent_destroy = true
    }

    # we want versioning for our files
    versioning {
        enabled = true
    }

    # we want SSE
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-state-wkngw1009-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S" # string type
    }
}

