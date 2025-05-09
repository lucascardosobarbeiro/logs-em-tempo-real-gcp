output "receive_logs_url" {
  value = google_cloudfunctions_function.receive_logs.https_trigger_url
}