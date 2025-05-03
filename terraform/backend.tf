terraform {
  backend "gcs" {
    bucket  = "tf-state-openweather-etl-alexp"
    prefix  = "terraform/state"
  }
}