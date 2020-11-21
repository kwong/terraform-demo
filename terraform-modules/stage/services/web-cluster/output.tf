output "alb_dns_name" {
    value = module.web-cluster.alb_dns_name
    description = "the domain name of the LB"
}