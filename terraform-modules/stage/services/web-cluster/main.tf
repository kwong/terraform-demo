provider "aws" {
    region = "us-east-2"
}

module "web-cluster" {
    source = "github.com/kwong/terraform-demo//terraform-modules/modules/services/web-cluster?ref=v0.0.1"

    cluster_name = "webcluster-stage"
    db_remote_state_bucket = "terraform-wkngw1009-state"
    db_remote_state_key = "stage/datastores/mysql/terraform.tfstate"

    instance_type = "t2.micro"
    min_size = 2
    max_size = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
    type = "ingress"
    security_group_id = module.web-cluster.alb_security_group_id

    from_port = 10009
    to_port = 10009
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}