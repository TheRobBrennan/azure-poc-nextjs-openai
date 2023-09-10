#!/bin/bash
# Azure Proof of Concept: Next.js and OpenAI
# chmod +x scripts/azure-create-resource-group-and-infrastructure.sh
# ./scripts/azure-create-resource-group-and-infrastructure.sh

echo "Running az cli $(az version | jq '."azure-cli"' )"
echo "Running in subscription $( az account show | jq -r '.id') / $( az account show | jq -r '.name'), AAD Tenant $( az account show | jq -r '.tenantId')"

# Variables
projectname="azure-poc-nextjs-openai"
environment="dev" # You can change this as per your requirement
region="westus"
random_number=$RANDOM
github_repo_url="https://github.com/TheRobBrennan/azure-poc-nextjs-openai"

# Derived names
resource_group_name="rg-${environment}-${projectname}-${region}-${random_number}"
keyvault_suffix="${random_number:0:4}" # Taking only the first 4 digits of the random number
keyvault_name="${projectname:0:9}-${environment}-kv-${keyvault_suffix}" # Taking only the first 9 characters of the project name

# Create Resource Group
az group create --name $resource_group_name --location $region

# Create Azure Key Vault
az keyvault create --name $keyvault_name \
                   --resource-group $resource_group_name \
                   --location $region

# OPTIONAL: Store secret(s) in Key Vault
# secret_name="github-token"
# secret_value="my-secret-value"
# az keyvault secret set --vault-name $keyvault_name \
#                        --name $secret_name \
#                        --value $secret_value


app_service_plan_name="asp-${environment}-${projectname}-${app}-P1v2"
web_app_name="${projectname}-${environment}-${app}-webapp-${random_number}"

# Create Linux App Service Plan with PremiumV2 tier (required for Deployment Slots)
az appservice plan create --name $app_service_plan_name \
                          --resource-group $resource_group_name \
                          --location $region \
                          --is-linux \
                          --sku P1V2

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

echo "App Service Plan Name for $app: $app_service_plan_name"
echo "Web App Name for $app: $web_app_name"

echo "Resource Group Name: $resource_group_name"
echo "Key Vault Name: $keyvault_name"

# Clean-up
# az group delete --name $resource_group_name --yes --no-wait