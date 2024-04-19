variable "region" {
  type    = string
  default = "us-east-1"
}

variable "Environment" {
  type    = string
  default = "Prod Environment"

}

variable "Name" {
  type    = string
  default = "factory-feed"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"

}

variable "Subnetpub" {
  type    = string
  default = "Public-Sub"
}

variable "Subnetprv" {
  type    = string
  default = "Private-sub"
}

variable "Sg" {
  type    = string
  default = "Factoryfeed-pubsg"
}

variable "sg-mysql" {
  type    = string
  default = "Factoryfeed-DB"
}