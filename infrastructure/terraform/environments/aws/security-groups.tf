# ---------------------------------------------------------
# EC2 Security Group
# ---------------------------------------------------------

resource "aws_security_group" "ec2" {
  name        = "cloud-native-lab-ec2-sg"
  description = "Security group for Cloud Native Lab EC2 instances"
  vpc_id      = aws_vpc.main.id

  # No inbound rules initially.
  # Access will be explicitly configured when required.

  egress {
    description = "Allow outbound IPv4 traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "cloud-native-lab-ec2-sg"
    Component = "security"
  }
}

