output "elasticIp" {
  value = aws_eip_association.eip_assoc.public_ip
}