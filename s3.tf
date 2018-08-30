resource "aws_s3_bucket" "b" {
  bucket = "me-and-myself-s3-bucket"
  acl    = "private"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }
}