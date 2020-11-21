variable "server_port" {
    description = "Specifies which port to use for http requests"
    type = number
    default = 8080
}

variable "cluster_name" {
    description = "name of cluster resources"
    type = string
}

variable "db_remote_state_bucket" {
    description = "name of remote s3 bucket"
    type = string
}

variable "db_remote_state_key" {
    description = "name of key in s3 bucket"
    type = string
}

variable "instance_type" {
    description = "the type of ec2 instance"
    type = string
}

variable "min_size" {
    description = "minimum number of ec2 instances in the ASG"
    type = number
}

variable "max_size" {
    description = "maximum number of ec2 instances in the ASG"
    type = number
}