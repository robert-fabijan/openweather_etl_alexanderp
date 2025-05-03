resource "google_storage_bucket" "bucket_for_functions" {
  name     = "functions-bucket-openweather-etl-alexp"
  location = var.region
}
data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = var.functions_source_dir
  output_path = "${path.module}/functions-source.zip"
}
resource "google_storage_bucket_object" "archive" {
  name   = "functions-source.zip"
  bucket = google_storage_bucket.bucket_for_functions.name
  source = data.archive_file.function_source.output_path
}

resource "google_cloudfunctions2_function" "extract_functions" {
  for_each = toset(var.extract_functions)

  name        = "${each.key}_tf"
  description = "Function for data extraction"
  location    = var.region

  build_config {
    runtime = "python311"
    entry_point = each.key
    source {
      storage_source {
        bucket = google_storage_bucket.bucket_for_functions.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "128Mi"
    environment_variables = {
      OPEN_WEATHER_API_KEY = var.open_weather_api_key
    }
  }
}
### historical_pollution_data
resource "google_cloudfunctions2_function" "extract_historical_pollution" {
  name        = "get_historical_pollution_data_tf"
  description = "Function for data extraction"
  location    = var.region

  build_config {
    runtime = "python311"
    entry_point = "get_historical_pollution_data"
    source {
      storage_source {
        bucket = google_storage_bucket.bucket_for_functions.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256Mi"
    environment_variables = {
      OPEN_WEATHER_API_KEY = var.open_weather_api_key
      get_historical_pollution_data = google_pubsub_topic.extract_historical_pollution.id
      ACCOUNT_API_KEY = var.gcp_credentials
    }
  }
}
### historical_weather_data
resource "google_cloudfunctions2_function" "extract_historical_weather" {
  name        = "get_historical_weather_data_tf"
  description = "Function for data extraction"
  location    = var.region

  build_config {
    runtime = "python311"
    entry_point = "get_historical_weather_data"
    source {
      storage_source {
        bucket = google_storage_bucket.bucket_for_functions.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256Mi"
    environment_variables = {
      OPEN_WEATHER_API_KEY = var.open_weather_api_key
      get_historical_weather_data = google_pubsub_topic.extract_historical_weather.id
      ACCOUNT_API_KEY = var.gcp_credentials
    }
  }
}
# Hey, this is a comment to remind you that the following code is commented out. It is not used in the current configuration but may be useful in the future.
#########################################################################################################
##### pubsub topics for each extract function
resource "google_pubsub_topic" "extract_functions_topics" {
  for_each = toset(var.extract_functions)
  name = "${each.key}-topic"
}
### historical_pollution_data
resource "google_pubsub_topic" "extract_historical_pollution" {
  name = "get_historical_pollution_data"
}
### historical_weather_data
resource "google_pubsub_topic" "extract_historical_weather" {
  name = "get_historical_weather_data"
}
#########################################################################################################
# ##### workflow for extract functions
# resource "google_workflows_workflow" "test_workflow" {
#   name            = "test-workflow"
#   region          = "europe-central2"
#   description     = "A test workflow"
#   service_account = "test-account@totemic-client-447220-r1.iam.gserviceaccount.com"

#   source_contents = <<-EOF
#     - init:
#         assign:
#             - results : {} # result from each iteration keyed by table name
#             - functions:
#                 - get_pollution_data
#                 - get_weather_data
#     - runQueries:
#         parallel:
#             shared: [results]
#             for:
#                 value: func
#                 in: $${functions}
#                 steps:
#                   - call_function:
#                       call: http.get
#                       args:
#                         url: $${"https://europe-central2-totemic-client-447220-r1.cloudfunctions.net/" + func + "_tf"}
#                         auth:
#                           type: OIDC
#                       result: function_response
#                   - publish_to_pubsub:
#                       call: googleapis.pubsub.v1.projects.topics.publish
#                       args:
#                         topic: $${"projects/totemic-client-447220-r1/topics/" + func + "-topic"}
#                         body:
#                           messages:
#                             - data: $${base64.encode(text.encode(function_response.body))}
#                       result: pubsub_response
#                   - returnResult:
#                       assign:
#                           - results[func]: $${pubsub_response}
#     - returnResults:
#         return: $${results}
#   EOF

# }
##### workflow for extract raw geo data
# resource "google_workflows_workflow" "geo_workflow" {
#   name            = "geo-workflow"
#   region          = "europe-central2"
#   description     = "Workflow exporting raw geo data to pubsub"
#   service_account = "kajous-serviceaccount-elexon@elexon-data-project.iam.gserviceaccount.com"

#   source_contents = <<-EOF
#     main:
#       params: [input]
#       steps:
#         - call_function:
#             call: http.get
#             args:
#               url: https://europe-central2-totemic-client-447220-r1.cloudfunctions.net/get_geo_data_tf
#               auth:
#                 type: OIDC
#             result: function_response
#         - publish_to_pubsub:
#             call: googleapis.pubsub.v1.projects.topics.publish
#             args:
#               topic: projects/var.project_id/topics/get_geo_data-topic
#               body:
#                 messages:
#                   - data: $${base64.encode(text.encode(function_response.body))}
#             result: pubsub_response
#         - return_results:
#             return: $${pubsub_response}
#   EOF
#
# }
#########################################################################################################
##### schedules for extract functions
# resource "google_cloud_scheduler_job" "test_workflow" {
#   name        = "test-workflow-schedule"
#   description = "Trigger for the test-workflow"
#   schedule    = "0 * * * *"
#   time_zone   = "Europe/Warsaw"
#   http_target {
#     uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.test_workflow.id}/executions"
#     http_method = "POST"
#     oauth_token {
#       service_account_email = "kajous-serviceaccount-elexon@elexon-data-project.iam.gserviceaccount.com"
#     }
#   }
# }
#########################################################################################################
##### invoker permissions for extract functions
resource "google_cloudfunctions2_function_iam_member" "invoker" {
  for_each = google_cloudfunctions2_function.extract_functions

  project        = each.value.project
  location       = each.value.location
  cloud_function = each.value.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:kajous-serviceaccount-elexon@elexon-data-project.iam.gserviceaccount.com"
}
resource "google_cloudfunctions2_function_iam_member" "invoker_extract_last_month" {
  project        = google_cloudfunctions2_function.extract_historical_pollution.project
  location       = google_cloudfunctions2_function.extract_historical_pollution.location
  cloud_function = google_cloudfunctions2_function.extract_historical_pollution.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:kajous-serviceaccount-elexon@elexon-data-project.iam.gserviceaccount.com"
}