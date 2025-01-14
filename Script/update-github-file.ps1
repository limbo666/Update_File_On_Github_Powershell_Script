# GitHub File Update Script
# ==============================================
# HOW TO GET GITHUB ACCESS TOKEN:
# 1. Log in to GitHub
# 2. Go to Settings (click your profile picture Î Settings)
# 3. Scroll down to Developer settings (bottom of left sidebar)
# 4. Select Personal access tokens Î  Tokens (classic)
# 5. Generate new token Î Select 'repo' scope
# 6. Copy the generated token and paste it below
# ==============================================

# CONFIGURATION SECTION - MODIFY THESE VARIABLES
# --------------------------------------------
$GithubToken = "Token_here"        									# Personal access token (classic)
$RepoOwner = "username"                								# Example: "limbo666" Your GitHub username
$RepoName = "RepoNameHere"  										# Example: "Update_File_On_Github_Powershell_Script" Your repository name
$FilePath = "docs/test.txt"            								# Path to the file
$CommitMessage = "Updated file content"  							# Commit message
$DefaultContent = "No Text Provided"   								# Default content if no argument provided

# Get content from command line argument if provided
$NewContent = $DefaultContent
if ($args.Count -gt 0) {
    $NewContent = $args[0]
}

# Detect commands passed by shortcuts
if ($args.Count -gt 0) {
    switch ($args[0]) {
        "update" {
            Write-Host "Update command detected."
            # Add your update logic here if needed
        }
        "delete" {
            Write-Host "Delete command detected."
            # Add your delete logic here if needed
        }
        default {
            Write-Host "Unknown command detected. Using argument as content."
            $NewContent = $args[0]
        }
    }
}

# API URL for the file
$apiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/contents/$FilePath"

# Headers for GitHub API
$headers = @{
    'Authorization' = "Bearer $GithubToken"
    'Accept' = 'application/vnd.github.v3+json'
}

# Debug information
Write-Host "Debug Information:" -ForegroundColor Cyan
Write-Host "API URL: $apiUrl"
Write-Host "Repository: $RepoOwner/$RepoName"
Write-Host "File Path: $FilePath"
Write-Host "Token Length: $($GithubToken.Length) characters"
Write-Host "----------------------------" -ForegroundColor Cyan

try {
    Write-Host "Attempting to update file: $FilePath"
    Write-Host "Content to be used: $NewContent"
    
    # Test API connection first
    Write-Host "Testing API connection..."
    $repoTest = Invoke-RestMethod -Uri "https://api.github.com/repos/$RepoOwner/$RepoName" -Headers $headers -Method Get
    Write-Host "Repository access successful!" -ForegroundColor Green
    
    # Get current file info
    Write-Host "Fetching current file information..."
    try {
        $existingFile = Invoke-RestMethod -Uri $apiUrl -Headers $headers -Method Get
        $existingSha = $existingFile.sha
        Write-Host "Current file SHA: $existingSha" -ForegroundColor Green
    }
    catch {
        $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($_.Exception.Response.StatusCode.value__ -eq 404) {
            Write-Host "File not found. Creating new file..." -ForegroundColor Yellow
            $existingSha = $null
        }
        else {
            throw
        }
    }

    # Prepare the update request
    $updateBody = @{
        message = $CommitMessage
        content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($NewContent))
    }
    
    if ($existingSha) {
        $updateBody.sha = $existingSha
    }
    
    $bodyJson = $updateBody | ConvertTo-Json

    # Update the file
    Write-Host "Sending update request..."
    $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -Method Put -Body $bodyJson
    
    Write-Host "File updated successfully!" -ForegroundColor Green
    Write-Host "Commit URL: $($response.commit.html_url)"
}
catch {
    Write-Host "Error occurred:" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    
    try {
        $errorMessage = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "Error Message: $($errorMessage.message)" -ForegroundColor Red
        Write-Host "Documentation URL: $($errorMessage.documentation_url)" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Raw Error: $_" -ForegroundColor Red
    }
    
    Write-Host "`nTroubleshooting Tips:" -ForegroundColor Yellow
    Write-Host "1. Verify your token has 'repo' scope"
    Write-Host "2. Check if the repository path is correct: $RepoOwner/$RepoName"
    Write-Host "3. Verify the file path is correct: $FilePath"
    Write-Host "4. Make sure you have write access to the repository"
}

# ==============================================
# USAGE EXAMPLES:
# 1. Basic usage (will use default content):
#    .\update-github-file.ps1
#
# 2. Update with specific content:
#    .\update-github-file.ps1 "This is new content"
#
# 3. Update command:
#    .\update-github-file.ps1 update
#
# 4. Delete command:
#    .\update-github-file.ps1 delete
# ==============================================