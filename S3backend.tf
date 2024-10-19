terraform {
  backend "s3" {
    bucket         = "test-19-24"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"  # You can use DynamoDB for state locking
  }
}
