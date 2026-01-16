variable "region" {
  default = "us-east-1"
}

variable "app_name" {
  default = "credpal-app"
}

variable "container_image" {
  default = "docker.io/stacko/credpal:1.0"
}

variable "container_port" {
  default = 3000
}
