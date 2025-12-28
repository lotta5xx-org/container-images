# Terraform fmt
fmt *args='':
    cd {{ invocation_directory() }} && \
    terraform fmt

# Terraform init
init *args='': fmt
    cd {{ invocation_directory() }} && \
    terraform init $@

# Terraform plan
plan *args='': fmt
    cd {{ invocation_directory() }} && \
    terraform plan -out ./tf.plan $@

# Terraform apply
apply *args='': fmt
    cd {{ invocation_directory() }} && \
    terraform apply ./tf.plan

# Terraform state
state *args='': fmt
    cd {{ invocation_directory() }} && \
    terraform state $@

# Terraform console
console *args='': fmt
    cd {{ invocation_directory() }} && \
    terraform console $@

# Terraform import
import *args='': fmt
    cd {{ invocation_directory() }} && \
    terraform import $@

# Terraform init for Yandex Cloud
yc-init *args='': fmt
    cd {{ invocation_directory() }} && \
    terraform init $@ \
        -backend-config="access_key=$YC_STORAGE_ACCESS_KEY" \
        -backend-config="secret_key=$YC_STORAGE_SECRET_KEY"
