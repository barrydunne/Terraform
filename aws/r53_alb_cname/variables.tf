variable "domain_name" {
  description = "The domain name to create the CNAME record for."
  type        = string
}

variable "alb_name" {
  description = "The name of the Application Load Balancer."
  type        = string
  default     = ""
}
