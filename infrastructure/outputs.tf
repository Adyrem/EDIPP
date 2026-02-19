output "function_url" {
  value = google_cloudfunctions2_function.hello.service_config[0].uri
}
