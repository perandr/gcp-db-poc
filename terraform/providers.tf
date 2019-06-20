provider "google" {
  credentials  = "${file(var.credentialsPath)}"
  project      = "${var.project}"
  region       = "${var.region}"
}



provider "random" {}