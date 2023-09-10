#!/bin/bash
az webapp deployment slot swap --resource-group azure-poc-nextjs-dev-westus --name azure-poc-nextjs-dev-webapp-demo-01 --slot staging --target-slot production
