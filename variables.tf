variable "lambda_role_name" {
  type = string
  default = "iac-lambda-role"
}
variable "create_iam_resources" {
  description = "Whether to create new IAM role and policy or use existing ones"
  type        = bool
  default     = true
}