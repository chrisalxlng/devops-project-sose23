resource "aws_key_pair" "ssh" {
  public_key = file(var.SSH_PUBLIC_KEY_PATH)
}

resource "aws_instance" "vm" {
  instance_type = "t2.nano"
  ami = data.aws_ami.image.id

  key_name = aws_key_pair.ssh.key_name

  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.allow-ssh-inbound.id,
    aws_security_group.allow-http-inbound.id,
    aws_security_group.allow-all-outbound.id
  ]

  tags = {
    name = "todo-app"
  }
}

resource "aws_security_group" "allow-ssh-inbound" {
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-http-inbound" {
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-all-outbound" {
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.vm.id
  allocation_id = var.EIP_ALLOCATION_ID
}
