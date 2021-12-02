variable "vpc_cidr" { type = string }

variable "vpc_env" { 
    default = "Test"
    type = string 
}

variable "counter" {
  type        = number
  default     = 1
  description = "The number of public and private subnets"
}

variable "public_cidrs" {
  type = list(any)
}

variable "private_cidrs" {
  type = list(any)
}

variable "default_tags" {
  default = {
    Environment = "Test"
    Owner = "inchb"
    Project = "lab3"
  }
  description = "Default Tags for VPCs"
  type = map(string)
}
