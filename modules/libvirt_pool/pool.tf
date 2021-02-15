# File to define the Pool for the storage of VM Hard-disks

## A storage pool is a quantity of storage set aside by an administrator, often a dedicated storage administrator, for use by virtual machines.
# Refer https://libvirt.org/storage.html

variable "pool_name"{
  description = "Name of to create pool"
  type = string
}

variable "pool_dir"{
  description = "Dir of the new pool"
  type = string
}

# create pool
resource "libvirt_pool" "uma" {
  name = var.pool_name
  type = "dir"
  path = var.pool_dir
}