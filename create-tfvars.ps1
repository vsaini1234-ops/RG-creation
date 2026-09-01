# $csvFile = "C:\Vikram\Pipeline\Pipe line prctice-01-sep\RG-Creation\azure_10_resources_portal.csv"
# $tfvarsFile = ".\terraform.tfvars"

# $resources = Import-Csv $csvFile

# $lines = @()
# $lines += "rgs = {"

# foreach ($resource in $resources) {
#     $rgName = $resource.'Resource Group Name'.Trim()
#     $location = $resource.Location.Trim()

#     $lines += "  `"$rgName`" = {"
#     $lines += "    name     = `"$rgName`""
#     $lines += "    location = `"$location`""
#     $lines += "  }"
# }

# $lines += "}"

# $lines | Set-Content -Path $tfvarsFile -Encoding UTF8

# Write-Host "terraform.tfvars created successfully!" -ForegroundColor Green
# Write-Host "File: $tfvarsFile"




####################################################


## script local and pipeline


# ============================================
# Generate terraform.tfvars from CSV
# Works in Local PowerShell + Azure DevOps Pipeline
# ============================================

# Check if running inside Azure DevOps Pipeline
if ($env:BUILD_SOURCESDIRECTORY) {

    # Pipeline environment
    $repoPath = $env:BUILD_SOURCESDIRECTORY

    Write-Host "Running inside Azure DevOps Pipeline"

}
else {

    # Local environment
    # Script ke current folder ko repository path maanega
    $repoPath = $PSScriptRoot

    Write-Host "Running locally in PowerShell"
}

# File paths
$csvFile = Join-Path $repoPath "azure_10_resources_portal.csv"
$tfvarsFile = Join-Path $repoPath "terraform.tfvars"

Write-Host ""
Write-Host "========================================"
Write-Host "       TFVARS FILE GENERATOR"
Write-Host "========================================"
Write-Host ""

Write-Host "Repository Path : $repoPath"
Write-Host "CSV File        : $csvFile"
Write-Host "TFVARS File     : $tfvarsFile"
Write-Host ""

# Check CSV file exists
if (-not (Test-Path $csvFile)) {

    Write-Host "ERROR: CSV file not found!" -ForegroundColor Red
    Write-Host "Expected location: $csvFile"

    exit 1
}

# Read CSV
$resources = Import-Csv $csvFile

Write-Host "Resources found in CSV: $($resources.Count)" -ForegroundColor Cyan
Write-Host ""

# Create terraform.tfvars content
$lines = @()

$lines += "rgs = {"

foreach ($resource in $resources) {

    $rgName = $resource.'Resource Group Name'.Trim()
    $location = $resource.Location.Trim()

    Write-Host "Adding: $rgName | $location"

    $lines += "  `"$rgName`" = {"
    $lines += "    name     = `"$rgName`""
    $lines += "    location = `"$location`""
    $lines += "  }"
}

$lines += "}"

# Create terraform.tfvars
$lines | Set-Content -Path $tfvarsFile -Encoding UTF8

Write-Host ""
Write-Host "========================================"
Write-Host " terraform.tfvars generated successfully"
Write-Host "========================================"
Write-Host ""

# Display generated file
Write-Host "===== terraform.tfvars ====="

Get-Content $tfvarsFile

Write-Host "============================"




