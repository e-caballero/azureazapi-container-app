
#Standard tags, naming convention and shared variables to load and use in the module

#shared variables 
#module "shared_vars" {
#  source      = "git::https://dev.azure.com/company/company-terraform/_git/azure-shared-vars?ref=v1"
#  location    = var.location
#  environment = var.environment
#}


locals {
  common_tags = merge(local.standard_tags, var.additional_tags)
  standard_tags = {
    "Project"                       = var.project
    "Description"                   = var.description
    "Environment"                   = var.environment
    "External"                      = var.external
    "CostCenter"                    = var.cost_center
    "Compliance"                    = var.compliance
    "ApplicationID"                 = var.application_id
    "ApplicationOwner"              = var.application_owner
    "ApplicationOwnerEmail"         = var.application_owner_email
    "ApplicationTeam"               = var.application_team
    "ApplicationTeamEmail"          = var.application_team_email
    "ApplicationTeamSlack"          = var.application_team_slack
    "ApplicationTeamMicrosoftTeams" = var.application_teams_channel
  }

#resource naming convention 
aca_name = lower("${var.application_id}-${var.environment}-${var.location}-aca-${var.count_number}")

}
