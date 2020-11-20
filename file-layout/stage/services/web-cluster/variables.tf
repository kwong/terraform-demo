variable "server_port" {
    description = "Specifies which port to use for http requests"
    type = number
    default = 8080
}

variable "db_remote_state_bucket" {
    description = "name of remote s3 bucket"
    type = string
    default = "terraform-wkngw1009-state"
}

variable "db_remote_state_key" {
    description = "name of key in s3 bucket"
    type = string
    default = "web-cluster"
}