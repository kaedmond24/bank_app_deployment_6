# Create management infrastrucuture
# Configure AWS Provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# Create Instances
# Jenkins  Management Server
resource "aws_instance" "jenkins_management_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.default_security_sg]
  key_name                    = var.key_name
  subnet_id                   = var.default_subnet_id
  associate_public_ip_address = "true"

  user_data = file("jenkins_management_server.sh")

  tags = {
    Name : "jenkins_management_server"
    vpc : "deploy6"
    az : "${var.region}a"
  }

}

# Jenkins Iac Agent Server
resource "aws_instance" "jenkins_iac_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.default_security_sg]
  key_name                    = var.key_name
  subnet_id                   = var.default_subnet_id
  associate_public_ip_address = "true"

  user_data = file("app_server_setup.sh")
  tags = {
    Name : "jenkins_iac_server",
    vpc : "deploy6",
    az : "${var.region}a"
  }
}

output "jenkins_management_server_public_ip" {
  value = aws_instance.jenkins_management_server.public_ip
}

output "jenkins_iac_server_public_ip" {
  value = aws_instance.jenkins_iac_server.public_ip
}
