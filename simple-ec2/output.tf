output "instance_ip" {
    value = aws_instance.web.public_ip
}

output "instance_state" {
    value = aws_instance.web.instance_state
}