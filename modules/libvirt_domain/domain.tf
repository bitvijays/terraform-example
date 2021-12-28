# Define the base image from the Local storage
# Source define the location of the local image (downloaded from internet); we concatenate it with base_image_location and the image name.
resource "libvirt_volume" "base_image" {
  for_each = var.images
  name     = each.value.name
  source   = format("%s%s", var.base_image_location, each.value.name)
  pool     = each.value.pool
  lifecycle {
    ignore_changes = all
  }
}

# We re-define the size of the hard-disk based on the hosts variable
# Refer the https://github.com/dmacvicar/terraform-provider-libvirt/tree/master/examples/v0.13/resize_base 
resource "libvirt_volume" "base_image_resized" {
  for_each       = var.hosts
  name           = format("%s.%s", each.value.name, "image")
  base_volume_id = libvirt_volume.base_image[each.value.os_ver].id
  pool           = each.value.pool
  size           = each.value.disk_size
  depends_on = [ libvirt_volume.base_image ]
  lifecycle {
    ignore_changes = all
  }
}

# Initial configuration file (cloud_init.cfg) for user data for defining Cloud-init configuration and forward some variables to cloud_init.cfg for each instance.
data "template_file" "user_data" {
  template   = file("${path.module}/config/cloud_init.cfg")
  for_each   = var.hosts
  vars       = {
    hostname   = each.value.hostname
    domainname = var.domainname
  }

}


data "template_file" "network_data" {
  template   = file("${path.module}/config/network_config.cfg")
}

# Define the CloudInit for each virtual machine based on the user_data.
resource "libvirt_cloudinit_disk" "commoninit" {
  for_each   = var.hosts
  name       = "commoninit_${each.value.name}.iso"
  user_data  = data.template_file.user_data[each.key].rendered
#  network_config = data.template_file.network_data.rendered
  pool       = each.value.pool
  lifecycle {
    ignore_changes = all
  }
}

# Define KVM-Guest/Domain using libvirt_domain
resource "libvirt_domain" "VM" {
  depends_on = [ libvirt_cloudinit_disk.commoninit, libvirt_volume.base_image_resized ]
  for_each   = var.hosts
  name       = each.value.name 
  memory     = each.value.memory
  vcpu       = each.value.vcpu

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

  network_interface {
    network_name = "ovs-br0"
  }

  boot_device {
    dev = [ "hd", "network"]
  }

  lifecycle {
    ignore_changes = all
  }

}