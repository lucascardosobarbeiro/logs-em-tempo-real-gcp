provider "google" {
  project = var.project_id
  region  = var.region
}
# comentando para nao criar novamente
# resource "google_pubsub_topic" "logs_topic" {
#   name = "logs-topic"
# }
# comentando para nao criar novamente
# resource "google_storage_bucket" "function_bucket" {
#   name          = "${var.project_id}-function-code"
#   location      = var.region
#   force_destroy = true
# }

resource "google_cloudfunctions_function" "receive_logs" {
  name        = "receive-logs"
  entry_point = "receive_logs"
  runtime     = "python310"
  trigger_http = true
  available_memory_mb = 128

  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = "receive_logs.zip"

  environment_variables = {
    LOG_TOPIC = google_pubsub_topic.logs_topic.name
  }
}

resource "google_cloudfunctions_function" "process_logs" {
  name        = "process-logs"
  entry_point = "process_logs"
  runtime     = "python310"

  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = "process_logs.zip"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.logs_topic.id
  }

  environment_variables = {
    SENDGRID_API_KEY = "NWGZvAXmTeGF6rUyyNbjqA"
    ALERT_EMAIL_TO   = "lcb.barbeiro@gmail.com"
  }
}
resource "google_storage_bucket_object" "function_code" {
  name   = "receive_logs.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "path/to/your/receive_logs.zip"
}
resource "google_storage_bucket_object" "function_code_process" {
  name   = "process_logs.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "path/to/your/process_logs.zip"
}
resource "google_pubsub_subscription" "logs_subscription" {
  name  = "logs-subscription"
  topic = google_pubsub_topic.logs_topic.id

  ack_deadline_seconds = 10
}

