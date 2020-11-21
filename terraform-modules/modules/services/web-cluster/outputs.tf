output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "the domain name of the LB"
}

output "asg_name" {
    value = aws_autoscaling_group.example.name
    description = "name of the ASG"
}

output "alb_security_group_id" {
    value = aws_security_group.alb.id
    description = "the ID of the security group attached to the load balancer"
}