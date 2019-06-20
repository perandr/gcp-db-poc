resource "google_sql_database_instance" "postgres" {
  name = "postgres"
  # count = "${var.usePG ? 1 : 0}"
  database_version = "POSTGRES_9_6"
  region       = "${var.region}"

  settings {
    tier = "db-f1-micro"
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