# Getting started with Terraform with GCP

- Proxy issue while working inside office firewall / vpn
  - set https_proxy=http://[user]:[pwd]@[proxy-ip]:[proxy-port]
  - terraform init # should be the first command before running anything
  - terraform plan or terraform plan -var-file=credentials.tfvars
  - terraform apply or terraform apply -var-file=credentials.tfvars
  - terraform destroy or terraform destroy -var-file=credentials.tfvars
