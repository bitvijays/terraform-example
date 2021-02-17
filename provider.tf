## libvirt is currently not officially supported plugin and hence we define libvirt
terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

# Provide the URI for the provider

# There can be two values for uri
## qemu:///session For running as a normal user. The URI allows virsh to manage only the set of VMs belonging to this particular user. 
## qemu:///system  For running as a root to manage the system set of VMs (i.e., VMs belonging to root).

provider "libvirt" {
  uri = "qemu:///system"
}