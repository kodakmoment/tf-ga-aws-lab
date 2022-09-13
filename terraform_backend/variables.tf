variable "environments" {
  description = "Name of the different terraform environments in use (folders under the terraform folder)"
  default     = ["demo", "blah"]
}

variable "prefix" {
  description = "Used as a prefix on resource names"
  default     = "kodak-lab"
}

variable "github_org" {
  description = "Name of the github org where the oidc provider will get access"
  default     = "kodakmoment"
}

variable "github_repo" {
  description = "Name of the github repo where the oidc provider will get access"
  default     = "tf-ga-lab"
}
