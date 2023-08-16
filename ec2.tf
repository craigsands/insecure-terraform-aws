data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "web" {
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  security_groups = [
    aws_security_group.allow_ssh.name,
    aws_security_group.allow_https.name
  ]
  user_data = <<EOF
#!/bin/bash
sudo yum update
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras enable nginx1
sudo amazon-linux-extras install nginx1
nginx -v
sudo systemctl start nginx.service
sudo systemctl enable httpd.service

sudo su ec2-user
mkdir -p ~/.ssh
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
aws s3api put-object --bucket ${aws_s3_bucket.example.id} --key id_rsa --body ~/.ssh/id_rsa
EOF
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
}
