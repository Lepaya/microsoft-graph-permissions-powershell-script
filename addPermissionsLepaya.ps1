param ($servicePrincipalId, $resourceId)
if(-not($servicePrincipalId)) { Throw “Value for -servicePrincipalId is required.” }

Connect-Graph -Scopes "AppRoleAssignment.ReadWrite.All"

if ([string]::IsNullOrEmpty((Get-MgServicePrincipal -ServicePrincipalId $servicePrincipalId))) {
        Throw “ERROR: Service Principal with id: $servicePrincipalId does not exist. Make sure value of -servicePrincipalId is correct.”
}

$existingPermissions = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId

if ([string]::IsNullOrEmpty($resourceId)) {
    if (!$existingPermissions) {
        Throw “There are no existing Aplication permissions. Please provide resourceId for resource you want to assign permissions.”
    }
    $resourceId = $existingPermissions[0].ResourceId
}

$permissions =@(

    # GroupMember.Read.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "98830695-27a2-44f7-8c18-0c3ebc9698f6"
    }

    # User.Read.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "df021288-bdef-4463-88db-98f22de89214"
    }

    # Team.Create
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "23fc2474-f741-46ce-8465-674744c5c361"
    }

    # Team.ReadBasic.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "2280dda6-0bfd-44ee-a2f4-cb867cfc4c1e"
    }

    # TeamSettings.ReadWrite.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "bdd80a03-d9bc-451d-b7c4-ce7c63fe3c8f"
    }

    # TeamMember.ReadWrite.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "0121dc95-1b9f-4aed-8bac-58c5ac466691"
    }

    # TeamsAppInstallation.ReadWriteForTeam.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "5dad17ba-f6cc-4954-a5a2-a0dcc95154f0"
    }

    # TeamsActivity.Send
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "a267235f-af13-44dc-8385-c1dc93023186"
    }

    # AppCatalog.Read.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "e12dae10-5a57-4817-b79d-dfbec5348930"
    }

    # Application.Read.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "9a5d68dd-52b0-4cc2-bd40-abcf44ac3a30"
    }
)

foreach ($permissionParams in $permissions)
{
    if (!$existingPermissions) {
        New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId -BodyParameter $permissionParams | Format-List -Property AppRoleId
        continue
    }

    foreach ($existingPermission in $existingPermissions)
    {
        $hasPermission = $false
        if ($existingPermission.AppRoleId -match $permissionParams.AppRoleId)
        {
            $hasPermission = $true
            break
        }
    }

    if (!$hasPermission) {
        Write-Output "---------------------------------------------------------------"
        Write-Output "Seting application permission ID:"
        Write-Output $permissionParams.AppRoleId
        Write-Output "---------------------------------------------------------------"
        New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId -BodyParameter $permissionParams | Format-List
    }
}

Write-Output "----------------------------------------------------------------"
Write-Output "Application permissions:"
Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId | Format-List -Property AppRoleId, ResourceDisplayName, PrincipalDisplayName
Write-Output "Done."
Write-Output "----------------------------------------------------------------"
