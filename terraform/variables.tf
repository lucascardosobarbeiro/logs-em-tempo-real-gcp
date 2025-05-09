variable "project_id" {
  type = string
  default = "real-time-log-monitor"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "sendgrid_api_key" {
  type = string
}

variable "dest_email" {
  type    = string
  default = "lcb.barbeiro@gmail.com"
}
