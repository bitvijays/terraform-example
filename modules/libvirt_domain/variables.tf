variable "images" {
    
}

variable "domainname" {
    default = "bitvijays.local"
}

variable "hosts" {
    type = map 
}

# Provide the default location where the images are stored
variable "base_image_location" {
    default = "/media/bitvijays/Images/"
    type = string
}