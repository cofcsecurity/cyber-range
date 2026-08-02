variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "range_ssh_public_key" {
  type      = string
  sensitive = true
  default   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB+AuArhPfWHFeYGITHvN5svbLgCoGZ/+Jn3bXySGLH+lGAyQSdA5/4A3lq1G/Rq4X03lMGcba2uNvlWRfNiOrPstLS0OGJEkG7QhUh4ggrSw8VcZuBvFbfm2c73WkzidI/PQTyMtSzR8mNRo0F0qph6dJzPQJAeHx1aVIO7A9Eb7TnNNF1fh/a/mOkgGo5lRsO0ENj/VEuPRErcXBgjiYItRQAmzz/MlPoGy50CydzIlraok4Z1Zz/osmiXh6T4wkVqim71T7B4WM9Xu/Ngv9+SwuzImSpBWO36vkZN6NlF4Er3MkKQA46WLO58sP65LY4vFAF4H81A2vhorMCHbCkF40FVmrZ90NezADHHLG9vroY1QLww56y0Xw8lbrtM93sQ6SqpJ5KeKZOQCzzdDbnvmflHSiZDZBkI42mF84VsaX2MZGcWJZ+2gjeA/2v7N3JcobAW/W7AeAq9HyAgNsp5Yr8PbNL/9zUnHAwrdJxDfunIoT6JfZiBv6j5BZmBEEBZIEPhWG8SpzzpgWFbXLLxvBl9cGUR9pxeCaPi9jeK5LHgvLfU6HRcWgG1Ev78Kld3GIYb2OUSL0aNEP08nITRW2bF2Zg24e3MTG6HQo496/UypfxZWOXpAgi7kJwsvmefJrkULb1j80Bba+rg69J9YjkhS1g/e5zw== relay@Igloo"
}
