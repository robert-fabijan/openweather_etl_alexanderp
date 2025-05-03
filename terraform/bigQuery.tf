resource "google_bigquery_dataset" "default" {
  dataset_id                  = "openweather_etl"
  friendly_name               = "openweather ETL"
  description                 = "Data set to store data extracted from openweathermap.org"
  location                    = "EU"

  labels = {
    env = "default"
  }
}

resource "google_bigquery_table" "weather_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "weather_raw"
  schema = jsonencode(var.bq_weather_schema)
}

resource "google_bigquery_table" "pollution_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "pollution_raw"
  schema = jsonencode(var.bq_pollution_schema)
}

resource "google_bigquery_table" "pollution_raw_backup" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "pollution_raw_backup"
  schema = jsonencode(var.bq_pollution_schema)
}

resource "google_bigquery_table" "geo_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "geo_raw"
  schema = jsonencode(var.bq_geo_schema)
}
# resource "google_bigquery_data_transfer_config" "geo" {
#   display_name           = "geo"
#   location               = "EU"
#   data_source_id         = "scheduled_query"
#   schedule               = "1 of month 12:30"
#   destination_dataset_id = google_bigquery_dataset.default.dataset_id
#   params = {
#     destination_table_name_template = "geo"
#     write_disposition               = "WRITE_TRUNCATE"
#     query                           = var.geo_query
#   }
# }
# resource "google_bigquery_data_transfer_config" "weather" {
#   display_name           = "weather"
#   location               = "EU"
#   data_source_id         = "scheduled_query"
#   schedule               = "every 60 minutes"
#   destination_dataset_id = google_bigquery_dataset.default.dataset_id
#   params = {
#     destination_table_name_template = "weather"
#     write_disposition               = "WRITE_APPEND"
#     query                           = var.weather_query
#   }
#   schedule_options {
#     start_time           = "2025-04-23T11:10:00Z"
#   }
# }
# resource "google_bigquery_data_transfer_config" "pollution" {
#   display_name           = "pollution"
#   location               = "EU"
#   data_source_id         = "scheduled_query"
#   schedule               = "every 60 minutes"
#   destination_dataset_id = google_bigquery_dataset.default.dataset_id
#   params = {
#     destination_table_name_template = "pollution"
#     write_disposition               = "WRITE_APPEND"
#     query                           = var.pollution_query
#   }
#   schedule_options {
#     start_time           = "2025-04-23T12:10:00Z"
#   }
# }