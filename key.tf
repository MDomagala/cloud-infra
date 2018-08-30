resource "aws_key_pair" "keypair" {
  key_name = "my_key"
  public_key = "${file("/Users/c8ngal/.ssh/id_rsa.pub")}"
}