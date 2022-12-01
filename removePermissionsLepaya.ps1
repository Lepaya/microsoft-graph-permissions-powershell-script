param ($servicePrincipalId)
if(-not($servicePrincipalId)) { Throw “Value for -servicePrincipalId is required.” }

# Check dependencies
$msGraphApplicationsModule = Get-Module 'Microsoft.Graph.Applications' -List

If (!$msGraphApplicationsModule) {
    Write-Output "Installing dependencies...."
    Install-Module 'Microsoft.Graph.Applications' -Force
}

# Login
Connect-Graph -Scopes "AppRoleAssignment.ReadWrite.All"

if ([string]::IsNullOrEmpty((Get-MgServicePrincipal -ServicePrincipalId $servicePrincipalId))) {
    Throw “ERROR: Service Principal with id: $servicePrincipalId does not exist. Make sure value of -servicePrincipalId is correct.”
}

# Get existing permissions
$existingPermissions = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId

# Check is there are any permissions
if ($existingPermissions) {
    $resourceId = $existingPermissions[0].ResourceId
    # Remove all permissions
    foreach ($existingPermission in $existingPermissions){
        Remove-MgServicePrincipalAppRoleAssignment -AppRoleAssignmentId $existingPermission.Id -ServicePrincipalId $servicePrincipalId | Format-List -Property AppRoleId
    }

    Write-Output "Application Permissions for resourceId: $resourceId removed."
} else {
    Write-Output "There were no Application permissions found."
}

