terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "required" {
  for_each = toset([
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com"
  ])
  service = each.key
}

# Bucket to store function source
resource "google_storage_bucket" "source_bucket" {
  name     = "${var.project_id}-hello-world"
  location = var.region
  uniform_bucket_level_access = true
}

# Archive the Python function
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/hello-world"
  output_path = "${path.module}/function.zip"
}

resource "google_storage_bucket_object" "source_archive" {
  name   = "function.zip"
  bucket = google_storage_bucket.source_bucket.name
  source = data.archive_file.function_zip.output_path
}

# Cloud Function v2 (Python)
resource "google_cloudfunctions2_function" "hello" {
  name     = "hello-world-python"
  location = var.region

  build_config {
    runtime     = "python312"
    entry_point = "hello_world"

    source {
      storage_source {
        bucket = google_storage_bucket.source_bucket.name
        object = google_storage_bucket_object.source_archive.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    ingress_settings   = "ALLOW_ALL"
  }

  depends_on = [google_project_service.required]
}

# Allow public HTTP access
resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloudfunctions2_function.hello.location
  service  = google_cloudfunctions2_function.hello.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
