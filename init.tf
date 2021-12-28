# Step 1: Define Pool to provide the location how and where the Hard Disk of the Virtual Machines will be stored.
# Pool: A storage pool is a quantity of storage set aside by an administrator, often a dedicated storage administrator, for use by virtual machines.
# Refer https://libvirt.org/storage.html

# Here we create two pools: One for storing the cloudinit images and other for storing the Virtual Machine Hard-disk.
# We define the pools in variable type of map containing name of the pool and path of the pool. We are using by-default pool type as dir.

module "libvirt_Pool" {
  source = "./modules/libvirt_pool/"
  pools = {
    "pool_base_image" = { name = "base_image", path = "/var/lib/libvirt/images/base_image/" },
    "pool_vm_image"    = { name = "vm_image" , path = "/var/lib/libvirt/images/vm_image/"  },
  }
}

# Step 2: Define the Cloudinit Images or the base images of different Operating Systems
# We define the images in a variable of type map containing the name, pool where it would be stored and the source of the online location.
# As we want to create the Pool before downloading the images. Hence, we use depends_on module.libvirt_pool

module "libvirt_Images" {
  source      = "./modules/libvirt_images/"
  pool_images = "base_image"
  images = {
    # Debian Base OS image
    "base_debian_10"    = { name = "base_debian_10"   , pool = "base_image", source = "https://cdimage.debian.org/cdimage/cloud/buster/latest/debian-10-genericcloud-amd64.qcow2" },
    "base_debian_11"    = { name = "base_debian_11"   , pool = "base_image", source = "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2" },

    # Ubuntu Base OS image
    "base_ubuntu_20_04" = { name = "base_ubuntu_20_04", pool = "base_image", source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img" },

    # CentOS Base OS image
    "base_centos_7"     = { name = "base_centos_7"    , pool = "base_image", source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1907.qcow2" },
    "base_centos_8"     = { name = "base_centos_8"    , pool = "base_image", source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2" },
    "base_centos_9"     = { name = "base_centos_9"    , pool = "base_image", source = "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20211216.1.x86_64.qcow2" },
    "base_fedora_34"     = { name = "base_fedora_34"    , pool = "base_image", source = "https://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/fedora/linux/releases/34/Cloud/x86_64/images/Fedora-Cloud-Base-34-1.2.x86_64.qcow2" },
  }
  depends_on = [module.libvirt_Pool]
}

# Step 3: Create the Virtual Machines based on the requirement.

# Variable Definitions:
# base_image_location provides the location where your base-images are stored. Path defined in pool_images.
# domainname defines the domain name for the machines used in cloudinit
# images is a variable of map type containing the name of the base_images (ubuntu, debian, centos). This is important and used in hosts variable os_ver.
# hosts is variable of map type containing the virtual machines to be created with details such as name, hostname, pool, disk_size, vcpu, memory and os_ver.
# os_ver defines the Operating System image currently (base_debian_10, base_ubuntu_20_04, base_centos_8)

# To define a virtual machine just copy one entry and make the necessary changes
module "libvirt_domain" {
  source              = "./modules/libvirt_domain/"
  domainname          = "bitvijays.local"
  base_image_location = "/var/lib/libvirt/images/base_image/"
  depends_on          = [module.libvirt_Images]
  images = {
    # Debian Base OS image
    "base_debian_10" = { name = "base_debian_10", pool = "base_image" },
    "base_debian_11" = { name = "base_debian_11", pool = "base_image" },    
    # Ubuntu Base OS image
    "base_ubuntu_20_04" = { name = "base_ubuntu_20_04", pool = "base_image" },
    # CentOS Base OS image
    "base_centos_7" = { name = "base_centos_7", pool = "base_image" },
    "base_centos_8" = { name = "base_centos_8", pool = "base_image" },
    "base_centos_9" = { name = "base_centos_9", pool = "base_image" },

    # Fedora Base OS image
    "base_fedora_34" = { name = "base_fedora_34", pool = "base_image" },
  }

  hosts = {
           "Puppet_Server"     = {name = "Puppet_Server"    , hostname = "puppet"    , os_ver = "base_debian_10"   , pool = "vm_image", disk_size = 40 * 1024 * 1024 * 1024, vcpu = 2, memory = 8 * 1024},
           "Cloudcore_Server"  = {name = "Cloudcore_Server" , hostname = "cloudcore" , os_ver = "base_debian_10"   , pool = "vm_image", disk_size = 40 * 1024 * 1024 * 1024, vcpu = 2, memory = 8 * 1024},
            "IPA_Server"       = {name = "IPA_Server"       , hostname = "ipa"      , os_ver = "base_centos_8"    , pool = "vm_image", disk_size = 40 * 1024 * 1024 * 1024, vcpu = 2, memory = 8 * 1024},
            "Rancher_Server"    = {name = "Rancher_Server"  , hostname = "rancher"  , os_ver = "base_debian_10"   , pool = "vm_image", disk_size = 20 * 1024 * 1024 * 1024, vcpu = 2, memory = 4 * 1024},
             "ceph_server"       = {name = "ceph_server1"  , hostname = "cephserver"  , os_ver = "base_centos_8"   , pool = "vm_image", disk_size = 40 * 1024 * 1024 * 1024, vcpu = 4, memory = 8 * 1024},
             "K8S_Worker1"       = {name = "K8S_Worker1"  , hostname = "k8sworker1"  , os_ver = "base_debian_10"   , pool = "vm_image", disk_size = 40 * 1024 * 1024 * 1024, vcpu = 2, memory = 8 * 1024},
             "K8S_Worker2"       = {name = "K8S_Worker2"  , hostname = "k8sworker2"  , os_ver = "base_debian_10"   , pool = "vm_image", disk_size = 40 * 1024 * 1024 * 1024, vcpu = 2, memory = 8 * 1024},
            # "KeyCloak"          = {name = "Keycloak"  , hostname = "keycloak"  , os_ver = "base_debian_10"   , pool = "vm_image", disk_size = 10 * 1024 * 1024 * 1024, vcpu = 2, memory = 2 * 1024},
#            "Teleport_Server"   = {name = "Teleport_Server"  , hostname = "teleport"  , os_ver = "base_debian_10"   , pool = "vm_image", disk_size = 40 * 1024 * 1024 * 1024, vcpu = 2, memory = 8 * 1024},
#            "NFS_Server"        = {name = "NFS_Server"  , hostname = "nfs"  , os_ver = "base_centos_8"   , pool = "vm_image", disk_size = 40 * 1024 * 1024 * 1024, vcpu = 2, memory = 4 * 1024},
#            "K3S_Server"        = {name = "K3S_Server"  , hostname = "k3sserver"  , os_ver = "base_debian_10"   , pool = "vm_image", disk_size = 20 * 1024 * 1024 * 1024, vcpu = 2, memory = 8 * 1024},
#           "Kafka_Server"      = {name = "Kafka_Server"     , hostname = "kafka"     , os_ver = "base_debian_10"   , pool = "vm_image", disk_size = 40 * 1024 * 1024 * 1024, vcpu = 2, memory = 8 * 1024},
  }

}
