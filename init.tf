# Pool to define Pool for storing Virtual Machines
module "UMA_Pool" {
  source = "./modules/libvirt_pool/"
  pool_name = "UMA2"
  pool_dir = "/tmp/UMA2/"
}
module "Puppet_Server" {
  # load template module
  source = "./modules/libvirt_image_template/"
  pool_name = "UMA"
  domain_name = "puppetserver"
  hostname = "puppet.bitvijays.local"
}

# module "Kafka_Server" {
#   # load template module
#   source = "./modules/libvirt_image_template/"
#   pool_name = "UMA"
#   domain_name = "kafkaserver"
#   hostname = "kafka.bitvijays.local"
# }
