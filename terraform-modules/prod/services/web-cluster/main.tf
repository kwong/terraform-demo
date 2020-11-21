provider "aws" {
    region = "us-east-2"
}

module "web-cluster" {
    source = "github.com/kwong/terraform-demo//terraform-modules/modules/services/web-cluster?ref=v0.01"

    cluster_name = "webcluster-stage"
    db_remote_state_bucket = "terraform-state-bucket-wkngw1009"
    db_remote_state_key = "stage/datastores/mysql/terraform.tfstate"

    instance_type = "t2.micro"
    min_size = 2
    max_size = 2
}

resource "aws_autoscaling_schedule" "scale_out" {
    scheduled_action_name  = "scale_out"
    min_size = 2
    max_size = 10
    desired_capacity = 10
    recurrence = "0 9 * * *"

    autoscaling_group_name = module.web-cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in" {
    scheduled_action_name = "scale_in"
    min_size = 2
    max_size = 10
    desired_capacity = 2
    recurrence = "0 17 * * *"

    autoscaling_group_name = module.web-cluster.asg_name
}