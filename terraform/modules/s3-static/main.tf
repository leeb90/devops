resource "aws_s3_bucket" "s3" {
  bucket = var.bucketName
}

resource "aws_s3_bucket_ownership_controls" "ownershipcontrol" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "publicaccess" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownershipcontrol,
    aws_s3_bucket_public_access_block.publicaccess,
  ]

  bucket = aws_s3_bucket.s3.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "example-config" {
  bucket = aws_s3_bucket.s3.bucket
  index_document  {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "example-policy" {
  bucket = aws_s3_bucket.s3.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
	  "Principal": "*",
      "Action": [ "*" ],
      "Resource": [
        "arn:aws:s3:::${var.bucketName}/*",
        "arn:aws:s3:::${var.bucketName}"

      ]
    }
  ]
}
EOF

depends_on = [
    aws_s3_bucket_ownership_controls.ownershipcontrol,
    aws_s3_bucket_public_access_block.publicaccess,
    aws_s3_bucket.s3,
    aws_s3_bucket_website_configuration.example-config,
    aws_s3_bucket_acl.example

  ]
}