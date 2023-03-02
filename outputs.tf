
// output all properties for the resource container_app_environment
output "container_app_environment" {
  value = jsondecode(azapi_resource.container_app_environment.output)
}

// output all properties for the resource aca
output "aca" {
  value = jsondecode(azapi_resource.aca.output)
}

// output all properties for the resource run_acr_task
output "run_acr_task" {
  value = jsondecode(azapi_resource.run_acr_task.output)
}

// output all properties for the resource aca_registry
output "aca_registry" {
  value = jsondecode(azapi_resource.aca_registry.output)
}
