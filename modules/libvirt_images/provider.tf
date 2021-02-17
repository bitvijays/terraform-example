## libvirt is currently not officially supported plugin and hence we define libvirt and libvirt provider in the same file
terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

# # Provide the URI for the provider

# ## By default, if virsh is run as a normal user it will connect to libvirt using qemu:///session URI string. This URI allows virsh to manage only the set of VMs belonging to this particular user. 
# ## To manage the system set of VMs (i.e., VMs belonging to root) virsh should be run as root or with qemu:///system URI

# provider "libvirt" {
#   uri = "qemu:///system"
# }