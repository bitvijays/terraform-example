# File to define the Pool for the storage of VM Hard-disks

## A storage pool is a quantity of storage set aside by an administrator, often a dedicated storage administrator, for use by virtual machines.
# Refer https://libvirt.org/storage.html

# create pool
resource "libvirt_pool" "libvirt_pool_x" {
  for_each = var.pools
  name = each.value.name
  type = "dir"
  path = each.value.path

  lifecycle {
    ignore_changes = all
  }  
}