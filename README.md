# MS-Graph-Permissions-Powershell-Script
Simple scripts to add/remove permissions to Lepaya MS Teams App

## Usage:

### Add Permissions (without resourceId parameter)
  ./addPermissionsLepaya.ps1 -servicePrincipalId {objectId} (Id for enterprise app we want to set permissions)
  
### Add Permissions (with resourceId parameter)
  ./addPermissionsLepaya.ps1 -servicePrincipalId  {objectId} -resourceId {resourceId} for which we are assigning permissions

### Remove All permissions
  ./removePermissionsLepaya.ps1 --servicePrincipalId {objectId}
  
#### Usefull instructions for assigning permissions: 
  https://lepaya-amsterdam.atlassian.net/wiki/spaces/BTS/pages/315916437/Grant+additional+permissions+with+PowerShell+script
