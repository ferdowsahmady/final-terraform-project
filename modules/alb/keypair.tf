## TF resource, NOT AWS, creates a key in backend
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

## AWS creates the SSH Key with this. Must add "public_key_openssh" at the end 
resource "aws_key_pair" "rsa-key-deployer" {
  key_name   = "project-ssh-keypair"
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

## Pushing the RSA Key to SSM PS. Must add "private_key_pem" at the end  
resource "aws_ssm_parameter" "rsa-private-ssh-key" {   
  name  = "project-ssh-keypair"                        
  type  = "SecureString"                              
  value = tls_private_key.rsa-4096.private_key_pem     
}