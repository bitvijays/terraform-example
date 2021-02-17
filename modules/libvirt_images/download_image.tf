# Download the OS images from the internet
resource "libvirt_volume" "download_image" {
  for_each = var.images
  name = each.value.name
  pool = each.value.pool
  source = each.value.source
}

