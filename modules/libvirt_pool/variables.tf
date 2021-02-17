# We define the pools in variable type of map containing name of the pool and path of the pool. We are using by-default pool type as dir.
variable "pools" {
    type = map
    default = {
        "pool_UMA" = { name = "UMA4", path = "/tmp/UMA4"},
    }
}