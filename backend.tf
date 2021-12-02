terraform {
  backend "s3" {
    bucket = "tf-state-inchb-lab3"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
