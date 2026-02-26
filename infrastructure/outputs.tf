output "hello_world_url" {
  value = module.hello_world.url
}

output "image_downscale_url" {
  value = module.image_downscale.url
}

output "frontend_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.frontend.name}/index.html"
}