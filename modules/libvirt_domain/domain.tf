# Define the base image from the Local storage
resource "libvirt_volume" "base_image" {
  for_each = var.images
  name   = each.value.name
  source = format("%s%s", var.base_image_location, each.value.name)
  pool = each.value.pool
}

# # volume to attach to the "master" domain as main disk
resource "libvirt_volume" "base_image_resized" {
  for_each = var.hosts
  name = format("%s.%s", each.value.name, "image")
  base_volume_id = libvirt_volume.base_image[each.value.os_ver].id
  pool           = each.value.pool
  size           = each.value.disk_size
}


# Use cloudinit config file and forward some variables to cloud_init.cfg
data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.cfg")
  for_each   = var.hosts
  vars     = {
    hostname   = each.value.hostname
    domainname = var.domainname
  }
}

# Use CloudInit to add the instance
resource "libvirt_cloudinit_disk" "commoninit" {
  for_each   = var.hosts
  name      = "commoninit_${each.value.name}.iso"
  user_data = data.template_file.user_data[each.key].rendered
  pool = each.value.pool
}


# Define KVM-Guest/Domain
resource "libvirt_domain" "VM" {
  for_each   = var.hosts
  name   = each.value.name 
  memory = each.value.memory
  vcpu   = each.value.vcpu

#   network_interface {
#     network_name   = var.networkname
#     mac            = each.value.mac
#     # If networkname is host-bridge do not wait for a lease
#     wait_for_lease = var.networkname == "host-bridge" ? false : true
#   }

  disk {
    volume_id = libvirt_volume.base_image_resized[each.key].id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[each.key].id
  # IMPORTANT
  # Ubuntu can hang if an isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why
  console {
    type = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type = "pty"
    target_type = "virtio"
    target_port = "1"
  }

    graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}
## END OF KVM DOMAIN CONFIG