module "s3-static-website" {
  source = "../modules/s3-static"
  bucketName = "${var.environment}-${var.name}"
}