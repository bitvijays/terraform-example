# Image variable is of the format {name, pool, source}
# - Name: Defines the custom name for the image
# - Pool: Defines the Pool where we want to store the images
# - Source: Defines the location of the image (where to download from)
#     images = {"image_debian" = { name = "base_debian_10"   , pool = "OS_Images", source = "https://cdimage.debian.org/cdimage/openstack/current/debian-10-openstack-amd64.qcow2"},}
variable "images"{
  description = "Define the images which are to be downloaded"
  type = map
}

# Variable to define the pool_images globally
variable "pool_images" {
  type = string
}