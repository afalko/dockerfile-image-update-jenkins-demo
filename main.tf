provider "aws" {
  region = "us-west-2"
}

variable "az" {
  type = "string"
  default = "us-west-2b"
}