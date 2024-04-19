output "vpc_id" {
  value = aws_vpc.factoryfeed_vpc
}

output "subnets_id" {
  value = aws_subnet.factoryfeed-pub_sub
}

output "security_groups" {
  value = aws_security_group.factoryfeed-sg
}