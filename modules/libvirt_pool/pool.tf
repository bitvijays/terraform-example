# Resource to define a pool. We read the pools variable (of type map).
# Refer https://www.terraform.io/docs/language/meta-arguments/for_each.html#basic-syntax

# We have added lifecycle as we only want to either create or delete the pool. We don't want Terraform to 
# monitor the changes such as availble disk space etc. As it deletes and creates it the resource again

# Refer https://www.terraform.io/docs/language/meta-arguments/lifecycle.html
resource "libvirt_pool" "libvirt_pool_x" {
  for_each = var.pools
  name = each.value.name
  type = "dir"
  path = each.value.path

  lifecycle {
    ignore_changes = all
  }  
}