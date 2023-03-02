
subcategory: ""
layout: "azapi"
page_title: "Azure Resource: azapi_resource"
description: |-
  Manages a Azure resource
---

# azapi_resource

This resource can manage any Azure resource manager resource.

## Example Usage

```hcl
terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "west europe"
}

resource "azurerm_user_assigned_identity" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

// manage a container registry resource
resource "azapi_resource" "example" {
  type      = "Microsoft.ContainerRegistry/registries@2020-11-01-preview"
  name      = "registry1"
  parent_id = azurerm_resource_group.example.id

  location = azurerm_resource_group.example.location
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }

  body = jsonencode({
    sku = {
      name = "Standard"
    }
    properties = {
      adminUserEnabled = true
    }
  })

  tags = {
    "Key" = "Value"
  }

  response_export_values = ["properties.loginServer", "properties.policies.quarantinePolicy.status"]
}

// it will output "registry1.azurecr.io"
output "login_server" {
  value = jsondecode(azapi_resource.example.output).properties.loginServer
}

// it will output "disabled"
output "quarantine_policy" {
  value = jsondecode(azapi_resource.example.output).properties.policies.quarantinePolicy.status
}
```


<!-- BEGIN_TF_DOCS --> 
{ .Content } 
<!-- END_TF_DOCS --> 
