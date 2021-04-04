provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "~/.aws.credentials"
}

resource "aws_instance" "web" {
    ami = "ami-05d72852800cbf29e"
    instance_type = "t2.micro"
    security_groups = ["web-sg"]

}

# EC2 instance SG
resource "aws_security_group" "web" {
    name = "web-sg"
    vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "allow_http_inbound" {
    type = "ingress"
    security_group_id = aws_security_group.web.id

    from_port = local.http_port
    to_port = local.http_port
    protocol = local.tcp_protocol
    cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
    type = "ingress"
    security_group_id = aws_security_group.web.id

    from_port = local.ssh_port
    to_port = local.ssh_port
    protocol = local.tcp_protocol
    cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_http_outbound" {
    type = "egress"
    security_group_id = aws_security_group.web.id

    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.all_ips
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

locals {
    http_port = 80
    ssh_port = 22
    any_port = 0
    tcp_protocol = "tcp"
    any_protocol = -1
    all_ips = ["0.0.0.0/0"]
}