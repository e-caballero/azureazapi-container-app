
terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
}


#resource "azurerm_user_assigned_identity" "ac_identity" {
#  name                = "${var.application_id}-${var.environment}-${var.location}-aci-identity"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#}


resource "azurerm_container_registry" "aca_registry" {
  name                = "${var.environment}${var.location}acr01"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
  tags               = local.common_tags
}


resource "azapi_resource" "run_acr_task" {
  type      = "Microsoft.ContainerRegistry/registries/taskRuns@2019-06-01-preview"
  name      = "${var.application_id}-${var.environment}-${var.location}-acr01"
  parent_id = azurerm_container_registry.aca_registry.id
  location  = var.location
  body = jsonencode({
    properties = {
      runRequest = {
        type           = "DockerBuildRequest"
        sourceLocation = var.source_location
        dockerFilePath = "Dockerfile"
        platform = {
          os = "Linux"
        }
        arguments = [{
          isSecret = true
        name = "PRIVATE_KEY"
        value = "${var.PRIVATE_KEY}"
        }, {        
        name = "LALATINA_ADDRESS"
        value = "${var.LALATINA_ADDRESS}"
        }]
        imageNames = ["DEMOAPP:{{.Run.ID}}", "DEMOAPP:latest"]
      }
    }
  })
}

resource "azapi_resource" "container_app_environment" {
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  name      = "${var.environment}-entapp-01"
  parent_id = var.resource_group_id
  location  = var.location
  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = var.law_workspace_id
          sharedKey  = var.law_primary_shared_key
        }
      }
    }
    tags = local.common_tags
  })

  // properties/appLogsConfiguration/logAnalyticsConfiguration/sharedKey contains credential which will not be returned,
  // using this property to suppress plan-diff
  ignore_missing_property = true
}



resource "azapi_resource" "aca" {
  for_each  = { for ca in var.container_apps: ca.name => ca}
  type      = "Microsoft.App/containerApps@2022-03-01" 
  parent_id = azurerm_resource_group.rg.id
  location  = azurerm_resource_group.rg.location
  name      = each.value.name
  
  body = jsonencode({
    properties: {
      managedEnvironmentId = azapi_resource.container_app_environment.id
      configuration = {
        ingress = {
          external = each.value.ingress_enabled
          targetPort = each.value.ingress_enabled?each.value.containerPort: null
        }
        /*
        It supports authentication with service principle, by replacing the `admin_username` and `admin_password`
        with client id and client secret.
        */
        secrets = [
          {
            name  = "registry-password"
            value = azurerm_container_registry.aca_registry.admin_password
          }
        ]
        registries = [
          {
            passwordSecretRef = "registry-password"
            server            = azurerm_container_registry.aca_registry.login_server
            username          = azurerm_container_registry.aca_registry.admin_username
          }
        ]
      }
      template = {
        containers = [
          {
            name = each.value.name
            image = "${azurerm_container_registry.test.login_server}/${each.value.image}:${each.value.tag}"
            resources = {
              cpu = each.value.cpu_requests
              memory = each.value.mem_requests
            }
          }         
        ]
        scale = {
          minReplicas = each.value.min_replicas
          maxReplicas = each.value.max_replicas
        }
      }
    }
  })
  tags = local.common_tags
  ignore_missing_property = true
  depends_on = [
    azapi_resource.run_acr_task
  ]
}



