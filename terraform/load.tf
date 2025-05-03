# resource "google_cloudfunctions2_function" "load_functions" {
#   for_each = tomap({
#     "export_temperature_to_bigquery" = "get_weather_data",
#     "export_weather_to_bigquery" = "get_weather_data",
#     "export_raw_weather_to_bigquery" = "get_weather_data",
#     "export_raw_pollution_to_bigquery" = "get_pollution_data",
#     "export_raw_geo_to_bigquery" = "get_geo_data"
#   })

#   name        = "${each.key}_tf"
#   description = "Function for data load"
#   location    = var.region

#   build_config {
#     runtime = "python311"
#     entry_point = each.key
#     source {
#       storage_source {
#         bucket = google_storage_bucket.bucket_for_functions.name
#         object = google_storage_bucket_object.archive.name
#       }
#     }
#   }

#   event_trigger {
#     trigger_region = var.region
#     event_type = "google.cloud.pubsub.topic.v1.messagePublished"
#     pubsub_topic = google_pubsub_topic.extract_functions_topics[each.value].id
#     retry_policy = "RETRY_POLICY_UNSPECIFIED"
#   }

#   service_config {
#     max_instance_count = 1
#     available_memory   = "256Mi"
#     environment_variables = {
#       OPEN_WEATHER_API_KEY = var.open_weather_api_key
#     }
#   }
# }
# resource "google_cloudfunctions2_function" "load_functions2" {
#   for_each = tomap({
#     "export_bcp_pollution_to_bigquery" = "export_bcp_pollution_to_bigquery",
#   })

#   name        = "${each.key}_tf"
#   description = "Function for data load"
#   location    = var.region

#   build_config {
#     runtime = "python311"
#     entry_point = each.value
#     source {
#       storage_source {
#         bucket = google_storage_bucket.bucket_for_functions.name
#         object = google_storage_bucket_object.archive.name
#       }
#     }
#   }

#   event_trigger {
#     trigger_region = var.region
#     event_type = "google.cloud.pubsub.topic.v1.messagePublished"
#     pubsub_topic = google_pubsub_topic.extract_historical_pollution.id
#     retry_policy = "RETRY_POLICY_UNSPECIFIED"
#   }

#   service_config {
#     max_instance_count = 1
#     available_memory   = "256Mi"
#     environment_variables = {
#       OPEN_WEATHER_API_KEY = var.open_weather_api_key
#     }
#   }
# }
# resource "google_cloudfunctions2_function" "load_functions3" {
#   for_each = tomap({
#     "export_hist_pollution_to_bigquery" = "export_hist_pollution_to_bigquery",
#   })

#   name        = "${each.key}_tf"
#   description = "Function for data load"
#   location    = var.region

#   build_config {
#     runtime = "python311"
#     entry_point = each.value
#     source {
#       storage_source {
#         bucket = google_storage_bucket.bucket_for_functions.name
#         object = google_storage_bucket_object.archive.name
#       }
#     }
#   }

#   event_trigger {
#     trigger_region = var.region
#     event_type = "google.cloud.pubsub.topic.v1.messagePublished"
#     pubsub_topic = google_pubsub_topic.extract_historical_pollution.id
#     retry_policy = "RETRY_POLICY_UNSPECIFIED"
#   }

#   service_config {
#     max_instance_count = 1
#     available_memory   = "512Mi"
#     environment_variables = {
#       OPEN_WEATHER_API_KEY = var.open_weather_api_key
#     }
#   }
# }
# #########################################################################################################
# ##### invoker permissions for load functions
# resource "google_cloudfunctions2_function_iam_member" "invoker_load_functions" {
#   for_each = google_cloudfunctions2_function.load_functions

#   project        = each.value.project
#   location       = each.value.location
#   cloud_function = each.value.name

#   role   = "roles/cloudfunctions.invoker"
#   member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
# }
# resource "google_cloudfunctions2_function_iam_member" "invoker_load_functions2" {
#   for_each = google_cloudfunctions2_function.load_functions2

#   project        = each.value.project
#   location       = each.value.location
#   cloud_function = each.value.name

#   role   = "roles/cloudfunctions.invoker"
#   member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
# }
# resource "google_cloudfunctions2_function_iam_member" "invoker_load_functions3" {
#   for_each = google_cloudfunctions2_function.load_functions3

#   project        = each.value.project
#   location       = each.value.location
#   cloud_function = each.value.name

#   role   = "roles/cloudfunctions.invoker"
#   member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
# }