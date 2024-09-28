
output "ec2_ip" {
  value = aws_instance.depi_task_instance.public_ip
}