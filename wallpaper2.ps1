$localFilePath = "C:\wallpaper\come_follow_me.jpg"  # Ensure this path is valid

# Ensure the wallpaper file exists
if (!(Test-Path $localFilePath)) {
    Write-Host "ERROR: Wallpaper file not found at $localFilePath"
    exit
}

# Define a specific username
$specifiedUser = "GEC Test Admin"  # Replace with the actual username

# Function to get SID for a specific user
function Get-UserSID([string]$username) { 
    try { 
        $user = New-Object System.Security.Principal.NTAccount($username)  
        $sid = $user.Translate([System.Security.Principal.SecurityIdentifier])  
        if (-NOT[string]::IsNullOrEmpty($sid)) { 
            Write-Output $sid.Value 
        } 
    } 
    catch {  
        Write-Output "Failed to get specified user SID."  
        Write-Host "Error occurred while running script -> ",$_.Exception.Message 
    } 
} 

Write-Host "--------------Starting script execution--------------"

$specificUserSID = Get-UserSID $specifiedUser

if (-NOT $specificUserSID) {
    Write-Host "Could not retrieve SID for the user: $specifiedUser"
    exit
}

$userRegistryPath = "Registry::HKEY_USERS\$($specificUserSID)\Control Panel\Desktop"

# Check if the registry path exists
if (!(Test-Path $userRegistryPath)) {
    Write-Host "ERROR: Registry path $userRegistryPath does not exist."
    exit
}

# Apply wallpaper and style
Set-ItemProperty -Path $userRegistryPath -Name Wallpaper -Value $localFilePath
Set-ItemProperty -Path $userRegistryPath -Name WallpaperStyle -Value "2"  # Fit
Set-ItemProperty -Path $userRegistryPath -Name TileWallpaper -Value "0"   # No tiling

# Force the system to apply changes
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

Write-Host "--------------Script execution completed successfully--------------"
Write-Host "Apply Restart device action to reflect the changes immediately"
