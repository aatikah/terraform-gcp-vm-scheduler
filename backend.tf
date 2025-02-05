
terraform {
  backend "gcs" {
    bucket      = "topsy-bucket"
    credentials = "key.json"
  }
}