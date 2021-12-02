locals {
  vpc_envs = {
    Shared : {
      vpc_cidr      = "10.1.0.0/16"
      public_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
      private_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
    }
  }
}

variable "default_tags" {
  default = {

    Environment = "Test"
    Owner       = "inchb"
    Project     = "lab3"

  }
  description = "Default Tags for Lab 3"
  type        = map(string)
}
