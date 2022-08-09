variable "efs-sg" {
  type        = list
  description = "security group for the file system"

}

variable "account_no" {
  type        = string
  description = "account number for the aws"
} 


variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}