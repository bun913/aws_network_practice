output "bastion_sg_id" {
  value = aws_security_group.allow_https_outbound.id
}
