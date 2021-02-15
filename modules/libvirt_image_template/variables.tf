variable "pool_name"{
  description = "Name of to create pool"
  type = string
}

# Variable to define Name, Memory, CPU, hostname of the Virtual Machine
variable "domain_name"{
  description = "name of the image including the format"
  type = string
}

variable "domain_memory"{
  description = "Memory allocated to the Virtual Machine in MB"
  type = number
  default = 8192
}

variable "domain_cpu"{
  description = "CPU allocated to the Virtual Machine"
  type = number
  default = 2
}

variable "disk_size" {
  description = "Size of the hard disk in GB"
  type = number
  default = 5 * 1024 * 1024 * 1024
  
}

variable "hostname"{
  description = "Define hostname for the Virtual Machine"
  type = string
}


# variable "image_name"{
#   description = "name of the image including the format"
#   type = string
# }

# variable "common_name"{
#   description = "name of cloud init disk"
#   type = string
# }

# variable "image_source"{
#   description = "path to image source"
#   type = string
# }

# variable "user_data_source"{
#   description = "path to use data"
#   type = string
# }

# variable "network_config_source"{
#   description = ""
# }



# variable "network_name"{
#   description = "name of virtual network"
#   type = string
# }



# variable "macaddress"{
#   description = "machine address"
#   type = string
# }
