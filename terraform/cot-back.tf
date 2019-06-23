
resource "google_compute_instance" "cot_back" {
  name         = "cot-back"
  machine_type  = "f1-micro"
  #zone         =   "${element(var.var_zones, count.index)}"
  zone          =   "${format("%s","${var.region}-b")}"
  tags          = ["ssh","http"]
  boot_disk {
    initialize_params {
      image     =  "centos-7-v20180129"     
    }
  }
  labels {
      webserver =  "true"     
    }
  metadata {
        startup-script = <<SCRIPT
        apt-get -y update
        apt-get -y install nginx
        export HOSTNAME=$(hostname | tr -d '\n')
        export PRIVATE_IP=$(curl -sf -H 'Metadata-Flavor:Google' http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip | tr -d '\n')
        echo "Welcome to $HOSTNAME - $PRIVATE_IP" > /usr/share/nginx/www/index.html
        service nginx start
        SCRIPT
  } 
  network_interface {
    subnetwork = "${google_compute_subnetwork.cot_pub_net.name}"
    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_sql_database_instance" "cot_db_instance" {
  name = "cot-db1"
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
      ipv4_enabled = "true"
      private_network = "${google_compute_network.cot_net.self_link}"
    }
  }
}
output "COT-DB-ip" {
  value = "${google_sql_database_instance.cot_db_instance.ip_address.0.ip_address}"
}


output "COT-DB-public_ip" {
  value = "${google_sql_database_instance.cot_db_instance.public_ip_address}"
}

output "COT-DB-private_ip" {
  value = "${google_sql_database_instance.cot_db_instance.private_ip_address}"
}

resource "google_sql_database" "cot_db" {
  name      = "cot_db"
  instance  = "${google_sql_database_instance.cot_db_instance.name}"
}

resource "google_sql_user" "users" {
  name     = "postgres"
  instance = "${google_sql_database_instance.cot_db_instance.name}"
  host     = "*"
  password = "${var.db_user_pwd}"
}
