resource "aws_key_pair" "main" {
  key_name   = "cloud-native-lab-aws-ohio"
  public_key = file(pathexpand(var.ssh_public_key_path))

  tags = {
    Name = "cloud-native-lab-aws-ohio"
  }
}

resource "aws_instance" "main" {
  ami                         = "ami-03a782d5d8abd6fde"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "cloud-native-lab-root-volume"
    }
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name      = "cloud-native-lab-node01"
    Component = "compute"
  }
}

