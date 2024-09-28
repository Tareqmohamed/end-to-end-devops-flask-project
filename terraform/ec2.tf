resource "aws_instance" "depi_task_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.depi_task_key_pair.key_name
  subnet_id     = aws_subnet.publicSubnet1.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  tags = {
    Name = "depi_task_instance"
  }
provisioner "local-exec" {
  command = <<EOT
    echo '[ec2-instance]' > ${var.ansible_path}/inventory.ini
    echo '${aws_instance.depi_task_instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${path.module}/keys/depi_task_private_key.pem' >> ${var.ansible_path}/inventory.ini
    chmod 400 ${path.module}/keys/depi_task_private_key.pem
    sleep 30 
    ansible-playbook -i ${var.ansible_path}/inventory.ini ${var.ansible_path}/playbook.yaml --ssh-extra-args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
  EOT
}

}

