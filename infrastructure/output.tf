output "instance_ipv4" {
  value = aws_instance.vm.public_ip
}

output "instance_id" {
  value = aws_instance.vm.id
}