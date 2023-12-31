#!/bin/bash
# ------------------------------------------------------------------
# Azure Proof of Concept: Next.js
# ------------------------------------------------------------------
# chmod +x scripts/azure-create-resource-group-and-infrastructure.sh
# ./scripts/azure-create-resource-group-and-infrastructure.sh

echo "Running az cli $(az version | jq '."azure-cli"' )"
echo "Running in subscription $( az account show | jq -r '.id') / $( az account show | jq -r '.name'), AAD Tenant $( az account show | jq -r '.tenantId')"

# Variables
projectname="azure-poc-nextjs"
environment="dev" # You can change this as per your requirement
region="westus"
github_repo_url="https://github.com/TheRobBrennan/azure-poc-nextjs-openai"
app="demo-01"

# Derived names
resource_group_name="rg-${projectname}-${environment}-${region}"
keyvault_name="kv-${projectname}-${environment}" # Taking only the first 9 characters of the project name

# Create Resource Group
az group create --name $resource_group_name --location $region

# Create Azure Key Vault
az keyvault create --name $keyvault_name \
                   --resource-group $resource_group_name \
                   --location $region

# OPTIONAL: Store secret(s) in Key Vault
# secret_name="my-secret"
# secret_value="my-secret-value"
# az keyvault secret set --vault-name $keyvault_name \
#                        --name $secret_name \
#                        --value $secret_value

app_service_plan_sku="P1V2"
app_service_plan_name="asp-${projectname}-${environment}-${app_service_plan_sku}-${app}"
web_app_name="app-${projectname}-${environment}-webapp-${app}"

# Create Linux App Service Plan with PremiumV2 tier (required for Deployment Slots)
az appservice plan create --name $app_service_plan_name \
                          --resource-group $resource_group_name \
                          --location $region \
                          --is-linux \
                          --sku $app_service_plan_sku

# Create Web App with Node.js runtime
az webapp create --name $web_app_name \
                  --resource-group $resource_group_name \
                  --plan $app_service_plan_name \
                  --runtime "NODE|18-lts"

# Configure the web app for Next.js
az webapp config appsettings set --name $web_app_name \
                                  --resource-group $resource_group_name \
                                  --settings WEBSITE_NODE_DEFAULT_VERSION=18-lts \
                                            WEBSITE_RUN_FROM_PACKAGE=1

# Enforce HTTPS on the web app
az webapp update --name $web_app_name \
                  --resource-group $resource_group_name \
                  --https-only true

# Create a staging Deployment Slot for the web app
az webapp deployment slot create \
  --name $web_app_name \
  --resource-group $resource_group_name \
  --slot next

# Display the names of Azure resources we created
echo "App Service Plan Name for $app: $app_service_plan_name"
echo "Web App Name for $app: $web_app_name"
echo "Resource Group Name: $resource_group_name"
echo "Key Vault Name: $keyvault_name"
