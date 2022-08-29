variable "region" {
    type = string
    default = "us-east-2"
}
variable "usergroups" {
    type = string
    default = "'arn:aws:iam::916547872461:group/Admin'"
}
variable "account_id" {
    type = string
    default = "eks.amazonaws.com/role-arn:aws:iam::916547872461:role/webidentity_role"
}
variable "pub1_az" {
    type = string
    default = "us-east-2a"
}
variable "pub2_az" {
    type = string
    default = "us-east-2b"
}
variable "pv1_az" {
    type = string
    default = "us-east-2a"
}
variable "pv2_az" {
    type = string
    default = "us-east-2b"
}



