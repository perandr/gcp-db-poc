variable "credentialsPath" {}
variable "project" {}

variable "region" {
  default     = "us-west1"
  description = "Region of resources"
}

variable "usePG" {
  default = true
}

variable "db_user_pwd" {
}

variable "cot_private_subnet" {
  default =  "10.0.2.0/24"
}
variable "cot_public_subnet" {
  default = "10.0.1.0/24"
}
