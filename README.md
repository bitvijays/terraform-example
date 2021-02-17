# Terraform Configuration for creating Virtual Machines on KVM Virtualisation

## Virtual Machine Creation Steps

Creating Virtual Machines using Cloud-init contains roughly three steps

### Step 1: Define Pool 

- Pool: A storage pool is a quantity of storage set aside by an administrator, often a dedicated storage administrator, for use by virtual machines.

Pool can be defined to provide the location how and where the Hard Disk of the Virtual Machines will be stored. 

Currently, we define two pools: One for storing the cloudinit images and other for storing the Virtual Machine Hard-disk. We define the pools in variable type of map containing name of the pool and path of the pool. We are using by-default pool type as dir.

```hcl
module "libvirt_Pool" {
  source = "./modules/libvirt_pool/"
  pools = {
    "pool_images" = { name = "OS_Images", path = "/media/bitvijays/Images/" },
    "pool_UMA"    = { name = "UMA5"     , path = "/media/bitvijays/VM_HD/"  },
  }
}
```


### Step 2: Define the Cloudinit Images of required Operating Systems

We define the images in a variable of type map containing the name, pool where it would be stored and the source of the online location. As we want to create the Pool before downloading the images. Hence, we use depends_on `module.libvirt_pool`

```hcl
module "libvirt_Images" {
  source      = "./modules/libvirt_images/"
  pool_images = "OS_Images"
  images = {
    # Debian Base OS image
    "base_debian_10"    = { name = "base_debian_10"   , pool = "OS_Images", source = "https://cdimage.debian.org/cdimage/openstack/current/debian-10-openstack-amd64.qcow2" },
    # Ubuntu Base OS image
    "base_ubuntu_20_04" = { name = "base_ubuntu_20_04", pool = "OS_Images", source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img" },
    # CentOS Base OS image
    "base_centos_8"     = { name = "base_centos_8"    , pool = "OS_Images", source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.3.2011-20201204.2.x86_64.qcow2" },
  }
  depends_on = [module.libvirt_Pool]
}
```

### Step 3: Configure the machine using cloud-init.cfg

Refer [Cloud-Init Modules](https://cloudinit.readthedocs.io/en/latest/topics/modules.html) and [Cloud config examples](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)

Modify [Cloud_init.cfg](modules/libvirt_domain/config/cloud_init.cfg)

### Step 4: Define the Virtual Machine required

```hcl
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
```

#### Variable Definitions:
- base_image_location provides the location where your base-images are stored. Path defined in pool_images.
- domainname defines the domain name for the machines used in cloudinit
- images is a variable of map type containing the name of the base_images (ubuntu, debian, centos). This is important and used in hosts variable os_ver.
- hosts is variable of map type containing the virtual machines to be created with details such as name, hostname, pool, disk_size, vcpu, memory and os_ver.
- os_ver defines the Operating System image currently (base_debian_10, base_ubuntu_20_04, base_centos_8)

