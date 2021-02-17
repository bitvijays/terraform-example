# Download the OS images from the internet
# Resource to define a libvirt_volume. We read the image variable containing the name, pool (where to be stored) and where to download from
#  images = {"base_debian_10" = { name = "base_debian_10", pool = "OS_Images", source = "https://cdimage.debian.org/cdimage/openstack/current/debian-10-openstack-amd64.qcow2" }, }

# Refer https://www.terraform.io/docs/language/meta-arguments/for_each.html#basic-syntax
resource "libvirt_volume" "download_image" {
  for_each = var.images
  name = each.value.name
  pool = each.value.pool
  source = each.value.source
}

