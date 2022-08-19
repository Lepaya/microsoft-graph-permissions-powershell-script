param ($servicePrincipalId)
if(-not($servicePrincipalId)) { Throw “Value for -servicePrincipalId is required.” }

Connect-Graph -Scopes "Application.ReadWrite.All"

if ([string]::IsNullOrEmpty((Get-MgServicePrincipal -ServicePrincipalId $servicePrincipalId))) {
    Throw “ERROR: Service Principal with id: $servicePrincipalId does not exist. Make sure value of -servicePrincipalId is correct.”
}

$existingPermissions = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId
$resourceId = $existingPermissions[0].ResourceId

foreach ($existingPermission in $existingPermissions){
    Remove-MgServicePrincipalAppRoleAssignment -AppRoleAssignmentId $existingPermission.Id -ServicePrincipalId $servicePrincipalId | Format-List -Property AppRoleId
}

Write-Output "Application Permissions for resourceId: $resourceId removed."
