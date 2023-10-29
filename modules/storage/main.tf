resource "aws_s3_bucket" "insecure-bucket" {
  bucket = "insecure-bucket"
}

# resource "aws_s3_bucket_public_access_block" "insecure-bucket" {
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 20
  encrypted         = true
  tags = {
    Name = "insecure"
  }
}

resource "aws_s3_bucket_versioning" "insecure-bucket" {
  bucket = aws_s3_bucket.insecure-bucket.id
  versioning_configuration {
    status = "Enabled"
    mfa_delete = "Enabled"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-tf-log-bucket"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "insecure-bucket" {
  bucket = aws_s3_bucket.insecure-bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}