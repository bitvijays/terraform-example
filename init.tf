# Pool to define Pool for storing Virtual Machines
module "libvirt_Pool" {
  source = "./modules/libvirt_pool/"
  pools = {
    "pool_images" = { name = "OS_Images", path = "/media/bitvijays/Images/" },
    "pool_UMA"    = { name = "UMA5", path = "/media/bitvijays/VM_HD/" },
  }
}

module "libvirt_Images" {
  source      = "./modules/libvirt_images/"
  pool_images = "OS_Images"
  images = {
    # Debian Base OS image
    "base_debian_10" = { name = "base_debian_10", pool = "OS_Images", source = "https://cdimage.debian.org/cdimage/openstack/current/debian-10-openstack-amd64.qcow2" },
    # Ubuntu Base OS image
    "base_ubuntu_20_04" = { name = "base_ubuntu_20_04", pool = "OS_Images", source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img" },
    # CentOS Base OS image
    "base_centos_8" = { name = "base_centos_8", pool = "OS_Images", source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.3.2011-20201204.2.x86_64.qcow2" },
  }
  depends_on = [module.libvirt_Pool]
}

module "libvirt_domain" {
  source              = "./modules/libvirt_domain/"
  domainname          = "bitvijays.local"
  base_image_location = "/media/bitvijays/Images/"
  depends_on          = [module.libvirt_Images]
  images = {
    # Debian Base OS image
    "base_debian_10" = { name = "base_debian_10", pool = "UMA5" },
    # Ubuntu Base OS image
    "base_ubuntu_20_04" = { name = "base_ubuntu_20_04", pool = "UMA5" },
    # CentOS Base OS image
    "base_centos_8" = { name = "base_centos_8", pool = "UMA5" },
  }

  hosts = {
#            "Puppet_Server" = {name = "Puppet_Server", hostname = "puppet", os_ver = "base_debian_10"   , pool = "UMA5", disk_size = 10 * 1024 * 1024 * 1024, vcpu = 2, memory = 4096},
#            "Kafka_Server"  = {name = "Kafka_Server" , hostname = "kafka" , os_ver = "base_ubuntu_20_04", pool = "UMA5", disk_size = 10 * 1024 * 1024 * 1024, vcpu = 2, memory = 4096},
#            "IPA_Server"    = {name = "IPA_Server"   , hostname = "ipa"   , os_ver = "base_centos_8"    , pool = "UMA5", disk_size = 10 * 1024 * 1024 * 1024, vcpu = 2, memory = 4096},            
  }

}