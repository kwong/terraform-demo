provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "~/.aws.credentials"
}

resource "aws_instance" "web" {
    ami = "ami-05d72852800cbf29e"
    instance_type = "t2.micro"
    security_groups = ["web-sg"]

    # set instance profile(role-policy)
    iam_instance_profile = aws_iam_instance_profile.web.name

    user_data = local.userdata
    key_name = "ec2-keypair"

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


resource "aws_iam_instance_profile" "web" {
    name = "web-instance-profile"
    role = aws_iam_role.web.name
}

resource "aws_iam_role_policy_attachment" "web" {
    count = length(local.role_policy_arns)
    role = aws_iam_role.web.name
    policy_arn = element(local.role_policy_arns, count.index)
}

# Role policy
resource "aws_iam_role_policy" "ssm" {
    name = "ec2-ssm-policy"
    role = aws_iam_role.web.id
    policy = jsonencode(
    {
        "Version" : "2012-10-17",
        "Statement" : [
        {
            "Effect" : "Allow",
            "Action" : [
            "ssm:GetParameter"
            ],
        "Resource" : "*"
        }]
    })
}

# Role allows
resource "aws_iam_role" "web" {
    name = "ec2-web-role"
    path = "/"

    assume_role_policy = jsonencode(
    {
        "Version" : "2012-10-17",
        "Statement" : [
        {
            "Action" : "sts:AssumeRole",
            "Principal" : {
                "Service" : "ec2.amazonaws.com"
            },
            "Effect" : "Allow"
        }]
    })
}

#SSM
resource "aws_ssm_parameter" "cwagent" {
    name = "/cwagent/config"
    type = "String"
    value = file("cwagent_config.json")
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

    userdata = templatefile("user-data.sh", {
        ssm_cw_config = aws_ssm_parameter.cwagent.name
    })

    role_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    ]
}