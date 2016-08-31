# Azure App Services Management
Manage Azure App Services.

## Requirement
* Node.js
* Azure CLI (will be installed by npm.)

## Install
```
git clone git@github.com:yusuke-arai/azure-app-services-management.git
cd azure-app-services-management
npm install
```

## Get ready to use
Login via Azure CLI.
```
node_modules/azure-cli/bin/azure login
```

## How to use
### Restart
```
node dist/restart.js <resource-group> <service-name>
```
