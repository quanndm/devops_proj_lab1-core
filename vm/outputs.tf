output "QA_instance_id" {
  value = aws_instance.QA.id
}

output "QA_private_IP" {
  value = aws_instance.QA.private_ip
}

output "QA_public_IP" {
  value = aws_instance.QA.public_ip
}

output "Staging_instance_id" {
  value = aws_instance.Staging.id
}

output "Staging_private_IP" {
  value = aws_instance.Staging.private_ip
}

output "Staging_public_IP" {
  value = aws_instance.Staging.public_ip
}

output "Jenkins_Server_instance_id" {
  value = aws_instance.Jenkins-server-instance.id
}

output "Jenkins_Server_private_IP" {
  value = aws_instance.Jenkins-server-instance.private_ip
}

output "Jenkins_Server_public_IP" {
  value = aws_instance.Jenkins-server-instance.public_ip
}