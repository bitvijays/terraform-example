
# Base OS image to use to create a cluster of different nodes
resource "libvirt_volume" "base_debian_10" {
  name = "base_debian_10"
  pool   = var.pool_name
  source = "https://cdimage.debian.org/cdimage/openstack/current/debian-10-openstack-amd64.qcow2"
}

# volume to attach to the "master" domain as main disk
resource "libvirt_volume" "debian_resized" {
  name = format("%s.%s", var.domain_name, "debian_re")
  base_volume_id = libvirt_volume.base_debian_10.id
  pool           = var.pool_name
  size           = var.disk_size
}

# Define the Cloud Init Configuration (For adding users, groups, SSH Keys. Any image related configuration)
# Refer https://cloudinit.readthedocs.io/en/latest/topics/examples.html
data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/config/network_config.cfg")
}

# Refer https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
resource "libvirt_cloudinit_disk" "commoninit" {
  name = format("%s.%s", var.domain_name, "commoninit.iso")
  pool = var.pool_name
  user_data = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}

# Define KVM domain to create
# Refer https://github.com/dmacvicar/terraform-provider-libvirt#using-the-provider
resource "libvirt_domain" "virt-domain" {
# Set the Virtual Machine Properties
  name   = var.domain_name
  memory = var.domain_memory
  vcpu   = var.domain_cpu

# Set the Hard Disk ID
  disk {
    volume_id = libvirt_volume.debian_resized.id
  }


  cloudinit = libvirt_cloudinit_disk.commoninit.id

  # network_interface {
  #   network_name = var.network_name
  #   mac = var.macaddress
  #   hostname = var.hostname
  # }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}