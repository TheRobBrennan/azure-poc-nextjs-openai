#!/bin/bash
az webapp deployment slot swap \
  --resource-group azure-poc-nextjs-dev-westus \
  --name azure-poc-nextjs-dev-webapp-demo-01 \
  --slot staging \
  --target-slot production

# REFERENCE: Create a deployment slot for an Azure Web App
# az webapp deployment slot create \
#   --name azure-poc-nextjs-dev-webapp-demo-01 \
#   --resource-group azure-poc-nextjs-dev-westus \
#   --slot test-deployment-slot-to-delete

# REFERENCE: Delete a deployment slot for an Azure Web App
# az webapp deployment slot delete \
#   --name azure-poc-nextjs-dev-webapp-demo-01 \
#   --resource-group azure-poc-nextjs-dev-westus \
#   --slot test-deployment-slot-to-delete
