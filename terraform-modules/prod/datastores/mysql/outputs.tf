output "address" {
    value = aws_db_instance.example.address
    description = "db endpoint"
}

output "port" {
    value = aws_db_instance.example.port
    description = "db port"
}