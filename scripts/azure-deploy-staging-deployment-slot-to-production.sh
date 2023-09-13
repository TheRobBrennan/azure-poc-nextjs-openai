#!/bin/bash
az webapp deployment slot swap \
  --resource-group rg-azure-poc-nextjs-dev-westus \
  --name app-azure-poc-nextjs-dev-webapp-demo-01 \
  --slot next \
  --target-slot production

# REFERENCE: Create a deployment slot for an Azure Web App
# az webapp deployment slot create \
#   --resource-group rg-azure-poc-nextjs-dev-westus \
#   --name app-azure-poc-nextjs-dev-webapp-demo-01 \
#   --slot test-deployment-slot-to-delete

# REFERENCE: Delete a deployment slot for an Azure Web App
# az webapp deployment slot delete \
#   --resource-group rg-azure-poc-nextjs-dev-westus \
#   --name app-azure-poc-nextjs-dev-webapp-demo-01 \
#   --slot test-deployment-slot-to-delete
