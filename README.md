# Lepaya Learning MS Teams app - MS Graph permissions PowerShell scripts 
Powershell scripts to add/remove permissions to the **Lepaya Learning** MS Teams app

## Prerequisites
- Powershell environment [(version 7.3.0)](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3)
- Powershell Module: Microsoft.Graph.Applications 1.17.0

## Usage:

:information_source: ***Detailed instructions on how to run this script can be found [here!](https://developer.lepaya.com/docs/automated-onboarding#run-the-powershell-script)***

### Add Permissions to the **Lepaya Learning** MS Teams app
 `pwsh ./addPermissionsLepaya.ps1 -servicePrincipalID SERVICE_PRINCIPAL_OBJECT_ID`
 >`-servicePrincipalID`: app's identity in the Azure AD tenant.

#### Add permissions for a specific resource *(optional)*
 `pwsh ./addPermissionsLepaya.ps1 -servicePrincipalID SERVICE_PRINCIPAL_OBJECT_ID -resourceId MICROSOFT_GRAPH_OBJECT_ID`
 >`-servicePrincipalID`: app's identity in the Azure AD tenant.
 >
 >`-resourceId`: service to which the permissions are associated. In our case it is [Microsoft Graph](https://developer.microsoft.com/en-us/graph).
 
#### Remove ALL granted permissions
 `pwsh ./removePermissionsLepaya.ps1 -servicePrincipalID SERVICE_PRINCIPAL_OBJECT_ID`
 >`-servicePrincipalID`: app's identity in the Azure AD tenant.
