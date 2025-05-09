provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_pubsub_topic" "logs_topic" {
  name = "logs-topic"
}

resource "google_storage_bucket" "function_bucket" {
  name          = "${var.project_id}-function-code"
  location      = var.region
  force_destroy = true
}

resource "google_cloudfunctions_function" "receive_logs" {
  name        = "receive-logs"
  entry_point = "receive_logs"
  runtime     = "python310"
  source_directory = "../functions/receive_logs"
  trigger_http = true
  available_memory_mb = 128
  environment_variables = {
    LOG_TOPIC = google_pubsub_topic.logs_topic.name
  }
}

resource "google_cloudfunctions_function" "process_logs" {
  name        = "process-logs"
  entry_point = "process_logs"
  runtime     = "python310"
  source_directory = "../functions/process_logs"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.logs_topic.id
  }
  environment_variables = {
  SENDGRID_API_KEY = "NWGZvAXmTeGF6rUyyNbjqA"
  ALERT_EMAIL_TO   = "lcb.barbeiro@gmail.com"
}

}