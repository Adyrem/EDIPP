resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "storage.googleapis.com"
  ])

  project = var.project_id
  service = each.key

  disable_on_destroy = false
}

module "hello_world" {
  source      = "./modules/cloud_function"
  project_id  = var.project_id
  region      = var.region
  name        = "hello_world"
  runtime     = "python312"
  entry_point = "hello_world"
  source_dir  = "${path.module}/../src/hello_world"

  depends_on = [google_project_service.required_apis]
}

module "image_downscale" {
  source      = "./modules/cloud_function"
  project_id  = var.project_id
  region      = var.region
  name        = "image_downscale"
  runtime     = "python312"
  entry_point = "image_downscale"
  source_dir  = "${path.module}/../src/image_downscale"

  depends_on = [google_project_service.required_apis]
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Static website bucket
resource "google_storage_bucket" "frontend" {
  name                        = "${var.project_id}-frontend-site"
  location                    = var.region
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
  }
}

# Public read access
resource "google_storage_bucket_iam_member" "frontend_public" {
  bucket = google_storage_bucket.frontend.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Render index.html with injected function URL
data "template_file" "index" {
  template = file("${path.module}/../frontend/index.html.tftpl")

  vars = {
    image_downscale_url = module.image_downscale.url
  }
}

# Upload rendered file
resource "google_storage_bucket_object" "index_html" {
  name   = "index.html"
  bucket = google_storage_bucket.frontend.name
  content = data.template_file.index.rendered
  content_type = "text/html"
}
