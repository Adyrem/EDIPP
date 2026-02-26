provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "source_bucket" {
  name                        = "${var.project_id}-${var.name}-src"
  location                    = var.region
  uniform_bucket_level_access = true
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/${var.name}.zip"
}

resource "google_storage_bucket_object" "archive" {
  name   = "${var.name}.zip"
  bucket = google_storage_bucket.source_bucket.name
  source = data.archive_file.zip.output_path
}

resource "google_cloudfunctions2_function" "function" {
  name     = var.name
  location = var.region

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.source_bucket.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    ingress_settings = "ALLOW_ALL"
  }
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  project  = var.project_id
  location = var.region
  name     = google_cloudfunctions2_function.function.service_config[0].service
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [
    google_cloudfunctions2_function.function
  ]
}