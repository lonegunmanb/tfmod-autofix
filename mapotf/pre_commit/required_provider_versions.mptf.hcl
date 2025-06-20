data "resource" this {}

locals {
  azurerm_provider_version_valid = try(semvercheck(data.terraform.this.required_providers.azurerm.version, "4.999.999"), false) && !try(semvercheck(data.terraform.this.required_providers.azurerm.version, "3.999.999"), true)
  azapi_provider_version_valid = try(!semvercheck(data.terraform.this.required_providers.azapi.version, "2.3.999"), false)
  required_terraform_version_declared = try(data.terraform.this.required_version != "", false)
  azapi_resource_defined = can([ for k, _ in data.resource.this.result : k if startswith(k, "azapi_") ][0])
  azurerm_resource_defined = can([ for k, _ in data.resource.this.result : k if startswith(k, "azurerm_")][0])
}


transform "update_in_place" azapi_provider_version {
  for_each             = local.azapi_resource_defined && !local.azapi_provider_version_valid ? toset([1]) : toset([])
  target_block_address = "terraform"
  asraw {
    required_providers {
      azapi = {
        source  = "Azure/azapi"
        version = "~> 2.4"
      }
    }
  }
}

transform "update_in_place" azurerm_provider_version {
  for_each             = local.azurerm_resource_defined && !local.azurerm_provider_version_valid ? toset([1]) : toset([])
  target_block_address = "terraform"
  asraw {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 4.30"
      }
    }
  }
  depends_on = [
    transform.update_in_place.azapi_provider_version
  ]
}

transform "update_in_place" required_terraform_version {
  for_each             = !local.required_terraform_version_declared ? toset([1]) : toset([])
  target_block_address = "terraform"
  asraw {
    required_version = "~> 1.0"
  }
  depends_on = [
    transform.update_in_place.azurerm_provider_version
  ]
}