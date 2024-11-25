provider "local" {}



resource "null_resource" "networking_submodule" {
  # Trigger the null_resource if the submodule is missing or if .gitmodules changes
  triggers = {
    gitmodules_hash = filemd5(".gitmodules")
    submodule_exists = fileexists("modules/example-module/.git")
  }
}

# Use the submodule as a Terraform module
module "network" {
  depends_on = [null_resource.networking_submodule] # Ensure the submodule is initialized first
  source     = "./modules/example-module"
  name = var.name
}

output "vpc_id" {
  value = module.network.uuid
}
