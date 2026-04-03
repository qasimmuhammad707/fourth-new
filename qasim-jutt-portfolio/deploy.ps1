# PowerShell script for GitHub Actions and Docker operations
# Usage: .\deploy.ps1 [command] [args]

param(
    [Parameter(Position = 0)]
    [string]$Command = "help",
    
    [Parameter(Position = 1)]
    [string]$Argument1 = "",
    
    [Parameter(Position = 2)]
    [string]$Argument2 = ""
)

# Colors
function Write-Info {
    Write-Host "ℹ️  $args" -ForegroundColor Cyan
}

function Write-Success {
    Write-Host "✅ $args" -ForegroundColor Green
}

function Write-Warning {
    Write-Host "⚠️  $args" -ForegroundColor Yellow
}

function Write-Error {
    Write-Host "❌ $args" -ForegroundColor Red
}

$MAIN_BRANCH = "main"
$CurrentBranch = git rev-parse --abbrev-ref HEAD
$RepoUrl = git config --get remote.origin.url

# Show help
function Show-Help {
    Write-Host @"
GitHub Actions & Docker Helper Script

Usage:
  .\deploy.ps1 [command] [options]

Commands:

  Git & Commit:
    push              Push current branch to GitHub
    status            Show git status
    clean             Delete merged branches
    list-branches     List all branches
    
  Release:
    release [v1.0.0]  Create and push version tag
    list-tags         List all version tags
    
  GitHub Actions:
    trigger           Trigger CI/CD workflow
    runs              View recent workflow runs
    
  Docker:
    build             Build Docker image
    run               Run Docker container
    
  Secrets:
    add-secret [name] [value]
    list-secrets      List all secrets
    
  Info:
    info              Show repository info
    help              Show this help

Examples:
  .\deploy.ps1 push
  .\deploy.ps1 release v1.0.0
  .\deploy.ps1 add-secret DOCKER_USERNAME myusername
  .\deploy.ps1 build

"@ -ForegroundColor Cyan
}

# Git commands
function Push-Code {
    Write-Info "Pushing to $CurrentBranch..."
    git push origin $CurrentBranch
    Write-Success "Code pushed successfully!"
}

function Get-GitStatus {
    Write-Info "Current branch: $CurrentBranch"
    git status
}

function Clean-Branches {
    Write-Info "Cleaning merged branches..."
    
    # Get merged branches except main
    $branches = git branch --merged $MAIN_BRANCH | `
        Where-Object { $_ -notmatch $MAIN_BRANCH } | `
        ForEach-Object { $_.Trim() }
    
    if ($branches) {
        foreach ($branch in $branches) {
            Write-Info "Deleting: $branch"
            git branch -d $branch
        }
        Write-Success "Local branches cleaned!"
    } else {
        Write-Info "No merged branches to clean"
    }
}

function List-Branches {
    Write-Info "All branches:"
    git branch -a
}

# Release commands
function New-Release {
    param([string]$Version)
    
    if ([string]::IsNullOrEmpty($Version)) {
        Write-Error "Version required (e.g., v1.0.0)"
        return
    }
    
    if ($Version -notmatch '^v[0-9]+\.[0-9]+\.[0-9]+$') {
        Write-Error "Invalid version format. Use: v1.0.0"
        return
    }
    
    Write-Info "Creating release: $Version"
    
    git tag $Version
    Write-Success "Tag created: $Version"
    
    git push origin $Version
    Write-Success "Tag pushed to GitHub!"
    
    Write-Success "Release created! GitHub Actions will:"
    Write-Info "  1. Build Docker image"
    Write-Info "  2. Push to registries"
    Write-Info "  3. Create GitHub release"
}

function List-Tags {
    Write-Info "Version tags:"
    git tag -l 'v*' --sort=-version:refname
}

# GitHub Actions
function Trigger-Workflow {
    Write-Info "Triggering CI/CD workflow..."
    
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Error "GitHub CLI not installed"
        Write-Info "Install from: https://cli.github.com"
        return
    }
    
    gh workflow run ci-cd.yml
    Write-Success "Workflow triggered!"
}

function Get-Workflows {
    Write-Info "Recent workflow runs:"
    
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Error "GitHub CLI not installed"
        return
    }
    
    gh run list --limit 10
}

# Docker commands
function Build-Docker {
    Write-Info "Building Docker image..."
    docker build -t qasim-portfolio:latest .
    Write-Success "Docker image built!"
}

function Run-Docker {
    Write-Info "Running Docker container..."
    Write-Info "Accessing at: http://localhost:3000"
    docker run -p 3000:3000 qasim-portfolio:latest
}

# Secrets
function Add-GithubSecret {
    param([string]$Name, [string]$Value)
    
    if ([string]::IsNullOrEmpty($Name) -or [string]::IsNullOrEmpty($Value)) {
        Write-Error "Usage: add-secret [name] [value]"
        return
    }
    
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Error "GitHub CLI not installed"
        return
    }
    
    Write-Info "Adding secret: $Name"
    gh secret set $Name --body $Value
    Write-Success "Secret added: $Name"
}

function Get-GithubSecrets {
    Write-Info "GitHub secrets:"
    
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Error "GitHub CLI not installed"
        return
    }
    
    gh secret list
}

# Info
function Show-Info {
    Write-Host `n
    Write-Host "Repository Information" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "Repository:  $RepoUrl" -ForegroundColor Yellow
    Write-Host "Branch:      $CurrentBranch" -ForegroundColor Yellow
    Write-Host "Main Branch: $MAIN_BRANCH" -ForegroundColor Yellow
    
    Write-Host `n
    Write-Host "Docker" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    docker --version
    
    Write-Host `n
    Write-Host "Node.js" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    node --version
    npm --version
    
    Write-Host `n
    Write-Host "Git" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    git --version
    
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        Write-Host "GitHub CLI: Installed" -ForegroundColor Green
    } else {
        Write-Host "GitHub CLI: Not installed" -ForegroundColor Yellow
    }
    
    Write-Host `n
}

# Main switch
switch ($Command) {
    "push" { Push-Code }
    "status" { Get-GitStatus }
    "clean" { Clean-Branches }
    "list-branches" { List-Branches }
    "release" { New-Release -Version $Argument1 }
    "list-tags" { List-Tags }
    "trigger" { Trigger-Workflow }
    "runs" { Get-Workflows }
    "build" { Build-Docker }
    "run" { Run-Docker }
    "add-secret" { Add-GithubSecret -Name $Argument1 -Value $Argument2 }
    "list-secrets" { Get-GithubSecrets }
    "info" { Show-Info }
    "help" { Show-Help }
    default {
        Write-Error "Unknown command: $Command"
        Write-Host ""
        Show-Help
    }
}
