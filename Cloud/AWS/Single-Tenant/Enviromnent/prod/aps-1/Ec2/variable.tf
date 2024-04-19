
variable "instance_type" {
  description = "Instance types is T2 micro"
  type        = string
  default     = "t2.micro"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"

}

variable "ami" {
  type    = string
  default = "ami-03a6eaae9938c858c"

}

variable "key_name" {
  type    = string
  default = "TF_key"
}


variable "Environment" {
  type    = string
  default = "Prod Environment"

}

variable "Name" {
  type    = string
  default = "factory-feed"
}

variable "region" {
  type    = string
  default = "us-east-2"
}



