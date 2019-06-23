resource "google_sql_database_instance" "postgres" {
  name = "postgres"
  # count = "${var.usePG ? 1 : 0}"
  database_version = "POSTGRES_9_6"
  region       = "${var.region}"

  settings {
    tier = "db-f1-micro"
    availability_type = "ZONAL"
    disk_size = 10
    disk_type = "PD_SSD"
    pricing_plan = "PER_USE"
    ip_configuration = {
      rivate_network 
    }
  }
}

resource "google_sql_database" "database" {
  name      = "udb"
  instance  = "${google_sql_database_instance.postgres.name}"
}

resource "google_sql_user" "users" {
  name     = "postgres"
  instance = "${google_sql_database_instance.postgres.name}"
  host     = "*"
  password = "${var.db_user_pwd}"
}

# resource "random_id" "instance_id" {
#  byte_length = 8
# }

# // A single Google Cloud Engine instance
# resource "google_compute_instance" "default" {
#  name         = "flask-vm-${random_id.instance_id.hex}"
#  machine_type = "f1-micro"
#  zone         = "${var.region}-a"

#  boot_disk {
#    initialize_params {
#      image = "debian-cloud/debian-9"
#    }
#  }

# // Make sure flask is installed on all new instances for later steps
#  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

#  network_interface {
#    network = "default"

#    access_config {
#      // Include this section to give the VM an external ip address
#    }
#  }
# }
