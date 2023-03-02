
variable "location" {
type = object({ 
   location= string,  
   identity= string,  
   tags= string,  
   response_export_values= string,  
   locks= string,  
   ignore_casing= string,  
   ignore_missing_property= string,  
   schema_validation_enabled= string  
})

default = { 
    location = "" 
 //(Optional) The Azure Region where the azure resource should exist. 

    identity = "" 
 //(Optional) A `identity` block as defined below. 

    tags = "" 
 //(Optional) A mapping of tags which should be assigned to the azure resource. 

    response_export_values = "" 
 //(Optional) A list of path that needs to be exported from response body. 

    locks = "" 
 //(Optional) A list of ARM resource IDs which are used to avoid create/modify/delete azapi resources at the same time. 

    ignore_casing = "" 
 //(Optional) Whether ignore incorrect casing returned in `body` to suppress plan-diff. Defaults to `false`. 

    ignore_missing_property = "" 
 //(Optional) Whether ignore not returned properties like credentials in `body` to suppress plan-diff. Defaults to `true`. 

    schema_validation_enabled = "" 
 //(Optional) Whether enabled the validation on `type` and `body` with embedded schema. Defaults to `true`. 

}

}

variable "source_location" {
  description = "- (Optional) The location of the source file. It can be a local file path or a remote URL. If it is a remote URL, it must be in the format of `https://<domain>/<path>`. It is required if `source` is not specified."
}

variable "run_type" {
  description = "- (Optional) The type of the run. It can be `local` or `remote`. Defaults to `local`."
  default    = "DockerBuildRequest"
}

variable "container_apps" {
  type = list(object({
    name = string
    image = string
    tag = string
    containerPort = number
    ingress_enabled = bool
    min_replicas = number
    max_replicas = number
    cpu_requests = number
    mem_requests = string
  }))
}

variable "law_workspace_id" {
  description = "- (Optional) The ID of the Log Analytics Workspace to which the container app logs should be sent. Changing this forces a new resource to be created."
}


variable "law_primary_shared_key" {
  description = "- (Optional) The primary shared key of the Log Analytics Workspace to which the container app logs should be sent. Changing this forces a new resource to be created."
}


variable "additional_tags" {
  description = "Additional tags added to all resources"
  type        = map(any)
  default     = {}
}
variable "environment" {
  description = "The environment of the system as defined by the data classification process. Valid values for environment are (Development, Test, Production)."
  type        = string
  validation {
    condition     = contains(["dev", "stg", "qa", "pi", "prd"], var.environment)
    error_message = "Valid values for environment are (dev, stg, qa, pi, prd)."
  }
}
variable "application_id" {
  description = "The application ID of the system as defined by the data classification process. Valid values for application_id are (APP-0001, APP-0002, APP-0003)."
  type        = string
  validation {
    condition     = contains(["APP-0001", "APP-0002", "APP-0003"], var.application_id)
    error_message = "Valid values for application_id are (APP-0001, APP-0002, APP-0003)."
  }
}
variable "application_owner" {
  description = "The application owner of the system as defined by the data classification process. Valid values for application_owner are (John Doe, Jane Doe, John Smith)."
  type        = string
  validation {
    condition     = contains(["John Doe", "Jane Doe", "John Smith"], var.application_owner)
    error_message = "Valid values for application_owner are (John Doe, Jane Doe, John Smith)."
  }
}
variable "application_owner_email" {
  description = "The application owner email of the system as defined by the data classification process. Valid values for application_owner_email are ( first.last@company.com)"
  type        = string
  validation {
    condition     = can(regex("^[a-z,A-Z,.]{1,}@company.com$", var.application_owner_email))
    error_message = "Valid values for application_owner_email are (first.last@company.com)"
  }
}
variable "application_team" {
  description = "The application team of the system as defined by the data classification process. Valid values for application_team are (Team 1, Team 2, Team 3)."
  type        = string
  validation {
    condition     = contains(["Team 1", "Team 2", "Team 3"], var.application_team)
    error_message = "Valid values for application_team are (Team 1, Team 2, Team 3)."
  }
}
variable "application_team_email" {
  description = "The application team email of the system as defined by the data classification process. Valid values for application_team_email are (team1@company.com)"
  type        = string
}
variable "application_team_slack" {
  description = "The application team slack of the system as defined by the data classification process. Valid values for application_team_slack are (https://app.slack.com/huddle/1234/123)"
  type        = string
  validation {
    condition     = can(regex("^(https://app.slack.com/huddle/1234/123)$", var.application_team_slack))
    error_message = "Valid values for application_team_slack are (https://app.slack.com/huddle/1234/123)"
  }
  default = "https://app.slack.com/huddle/1234/123"
}
variable "application_teams_channel" {
  description = "The application team Microsoft Teams channel of the system as defined by the data classification process. Valid values for application_teams_channel are (https://teams.microsoft.com/l/channel/1234/123)"
  type        = string
  validation {
    condition     = can(regex("^(https://teams.microsoft.com/l/channel/1234/123)$", var.application_teams_channel))
    error_message = "Valid values for application_teams_channel are (https://teams.microsoft.com/l/channel/1234/123)"
  }
  default = "https://teams.microsoft.com/l/channel/1234/123"
}
variable "component_name" {
  description = "The component name of the system as defined by the data classification process. Valid values for component_name are (component1, component2, component3)."
  type        = string
  validation {
    condition     = contains(["component1", "component2", "component3"], var.component_name)
    error_message = "Valid values for component_name are (component1, component2, component3)."
  }
}

variable "project" {
  description = "The project of the system as defined by the data classification process. Valid values for project are (project1, project2, project3)."
  type        = string
}

variable "description" {
  description = "The description of the system as defined by the data classification process. Valid values for description are (description1, description2, description3)."
  type        = string
  default = ""
}

variable "external" {
  description = "The external of the system as defined by the data classification process. Valid values for external are (external1, external2, external3)."
  type        = string
}

variable "cost_center" {
  description = "The cost center of the system as defined by the data classification process. Valid values for cost_center are (cost_center1, cost_center2, cost_center3)."
  type        = string
}

variable "compliance" {
  description = "The compliance of the system as defined by the data classification process. Valid values for compliance are (compliance1, compliance2, compliance3)."
  type        = string
}
variable "count_number" {
  description = "The count number of the system as defined by the data classification process. Valid values for count_number are (count_number1, count_number2, count_number3)."
  type        = string
}
