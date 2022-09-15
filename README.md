# MS-Graph-Permissions-Powershell-Script
Simple scripts to add/remove permissions to Lepaya MS Teams App

## Usage:

### Add Permissions (without resourceId parameter)
 ```./addPermissionsLepaya.ps1 -servicePrincipalId {objectId}``` (Id for enterprise app we want to set permissions)
  
### Add Permissions (with resourceId parameter)
 ```./addPermissionsLepaya.ps1 -servicePrincipalId  {objectId} -resourceId {resourceId} ```\
 Resource ID for resource we are assigning permissions. In our case it is Microsoft Graph (4954fa11-cd76-476d-9101-18e54423b7a3)

#### Detailed instructions for assigning permissions can be found here: 
  https://lepaya-amsterdam.atlassian.net/wiki/spaces/BTS/pages/315916437/Grant+additional+permissions+with+PowerShell+script


### Remove All permissions
 ```./removePermissionsLepaya.ps1 --servicePrincipalId {objectId} ```

#### Detailed instructions for removing permissions can be found here: 
 https://lepaya-amsterdam.atlassian.net/wiki/spaces/BTS/pages/323780888/Remove+All+application+permissions
  

