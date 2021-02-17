# Variable to define images
variable "images" {
    type = map 
}

# Define the domainname for the Virtual Machines
variable "domainname" {
    default = "bitvijays.local"
}

# Define the hosts to be created
#  hosts = {"Puppet_Server" = {name = "Puppet_Server", hostname = "puppet", os_ver = "base_debian_10"   , pool = "UMA5", disk_size = 10 * 1024 * 1024 * 1024, vcpu = 2, memory = 4096},}
variable "hosts" {
    type = map 
}

# Define the default location where the images are stored
variable "base_image_location" {
    default = "/media/bitvijays/Images/"
    type = string
}