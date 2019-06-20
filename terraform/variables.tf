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