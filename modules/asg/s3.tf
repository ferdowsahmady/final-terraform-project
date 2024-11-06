resource "aws_s3_bucket" "s3-test" {
  bucket = "ferdows-test-bucket-2024"

  tags = {
    Name        = "ferdows-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.s3-test.id

  rule {
    id = "Allow small object transitions"

    filter {
      object_size_greater_than = 1
    }

    status = "Enabled"

    transition {
      days          = 15
      storage_class = "GLACIER_IR"
    }
  }
}