output "svc_access_key" {
    value = module.iam.svc_user_access_key
}

output "svc_secret_key" {
    value = module.iam.svc_user_secret_key
    sensitive = true
}

output "user_access_key" {
    value = module.iam.user_access_key
}

output "user_secret_key" {
    value = module.iam.user_secret_key
    sensitive = true
}

output "user_name" {
    value = module.iam.user_name
}

output "user_password" {
    value = module.iam.user_password
    sensitive = true
}