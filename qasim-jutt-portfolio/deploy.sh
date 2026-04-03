#!/bin/bash
# Git and GitHub Actions Helper Script
# Usage: ./deploy.sh [command] [args]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL=$(git config --get remote.origin.url)
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
MAIN_BRANCH="main"

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if git is in clean state
check_git_status() {
    if git diff-index --quiet HEAD --; then
        log_success "Git working directory is clean"
    else
        log_warning "Git working directory has uncommitted changes"
        read -p "Do you want to continue? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Show help
show_help() {
    cat << EOF
${BLUE}GitHub Actions & Docker Helper Script${NC}

${YELLOW}Usage:${NC}
  ./deploy.sh [command] [options]

${YELLOW}Commands:${NC}

  ${GREEN}Git & Commit Commands:${NC}
    push              Push current branch to GitHub
    status            Show git status
    clean-branches    Delete merged branches locally and remote
    list-branches     List all branches
    
  ${GREEN}Release Commands:${NC}
    release [version] Create and push a version tag (e.g. v1.0.0)
    list-tags         List all version tags
    
  ${GREEN}GitHub Actions:${NC}
    trigger-workflow  Manually trigger CI/CD workflow
    view-runs         View recent workflow runs
    watch-workflow    Watch current workflow in real-time
    
  ${GREEN}Docker Commands:${NC}
    build             Build Docker image locally
    run               Run Docker container locally
    push              Push image to registries
    
  ${GREEN}Secrets:${NC}
    add-secret [name] [value]  Add GitHub secret
    list-secrets      List all GitHub secrets
    delete-secret [name]       Delete GitHub secret
    
  ${GREEN}Setup:${NC}
    init              Initialize GitHub CLI and setup secrets
    setup-docker-hub  Setup Docker Hub credentials
    
  ${GREEN}Info:${NC}
    info              Show repository information
    help              Show this help message

${YELLOW}Examples:${NC}
  ./deploy.sh push
  ./deploy.sh release v1.0.0
  ./deploy.sh add-secret DOCKER_USERNAME myusername
  ./deploy.sh build
  ./deploy.sh trigger-workflow

EOF
}

# Git commands
push_code() {
    log_info "Pushing to $CURRENT_BRANCH..."
    check_git_status
    git push origin "$CURRENT_BRANCH"
    log_success "Code pushed to $CURRENT_BRANCH"
}

show_git_status() {
    log_info "Current branch: $CURRENT_BRANCH"
    git status
}

clean_merged_branches() {
    log_info "Cleaning up merged branches..."
    
    # Delete local merged branches
    git branch --merged "$MAIN_BRANCH" | grep -v "$MAIN_BRANCH" | xargs -r git branch -d
    
    # Delete remote merged branches
    git branch -r --merged "origin/$MAIN_BRANCH" | grep -v "$MAIN_BRANCH" | sed 's/.*\///' | xargs -r git push origin -d
    
    log_success "Cleaned up merged branches"
}

list_branches() {
    log_info "Listing all branches:"
    git branch -a
}

# Release commands
create_release() {
    local version=$1
    
    if [[ -z "$version" ]]; then
        log_error "Version required (e.g., v1.0.0)"
        exit 1
    fi
    
    if ! [[ "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log_error "Invalid version format. Use: v1.0.0"
        exit 1
    fi
    
    log_info "Creating release: $version"
    check_git_status
    
    # Create tag
    git tag "$version"
    log_success "Tag created: $version"
    
    # Push tag
    git push origin "$version"
    log_success "Tag pushed to GitHub"
    
    log_success "Release $version created!"
    log_info "GitHub Actions will automatically:"
    log_info "  1. Build Docker image"
    log_info "  2. Push to registries"
    log_info "  3. Create GitHub release"
}

list_tags() {
    log_info "Version tags:"
    git tag -l 'v*' --sort=-version:refname
}

# GitHub Actions commands
trigger_workflow() {
    log_info "Triggering CI/CD workflow..."
    
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not installed. Install from: https://cli.github.com"
        exit 1
    fi
    
    gh workflow run ci-cd.yml
    log_success "Workflow triggered!"
    log_info "Watch progress: gh run watch"
}

view_workflow_runs() {
    log_info "Recent workflow runs:"
    
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not installed. Install from: https://cli.github.com"
        exit 1
    fi
    
    gh run list --limit 10
}

watch_workflow() {
    log_info "Watching workflow..."
    
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not installed. Install from: https://cli.github.com"
        exit 1
    fi
    
    gh run watch
}

# Docker commands
build_docker() {
    log_info "Building Docker image..."
    docker build -t qasim-portfolio:latest .
    log_success "Docker image built!"
}

run_docker() {
    log_info "Running Docker container..."
    docker run -p 3000:3000 qasim-portfolio:latest
}

# Secrets commands
add_github_secret() {
    local name=$1
    local value=$2
    
    if [[ -z "$name" || -z "$value" ]]; then
        log_error "Usage: ./deploy.sh add-secret [name] [value]"
        exit 1
    fi
    
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not installed. Install from: https://cli.github.com"
        exit 1
    fi
    
    log_info "Adding secret: $name"
    gh secret set "$name" --body "$value"
    log_success "Secret added: $name"
}

list_github_secrets() {
    log_info "GitHub secrets:"
    
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not installed. Install from: https://cli.github.com"
        exit 1
    fi
    
    gh secret list
}

delete_github_secret() {
    local name=$1
    
    if [[ -z "$name" ]]; then
        log_error "Usage: ./deploy.sh delete-secret [name]"
        exit 1
    fi
    
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not installed. Install from: https://cli.github.com"
        exit 1
    fi
    
    log_warning "Deleting secret: $name"
    gh secret delete "$name"
    log_success "Secret deleted: $name"
}

# Setup commands
init_github_cli() {
    log_info "Initializing GitHub CLI..."
    
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not installed"
        log_info "Install from: https://cli.github.com"
        exit 1
    fi
    
    gh auth login
    log_success "GitHub CLI initialized!"
    
    log_info "Would you like to setup Docker Hub credentials now? (y/n)"
    read -r -n 1 setup_docker
    echo
    if [[ $setup_docker =~ ^[Yy]$ ]]; then
        setup_docker_hub_secrets
    fi
}

setup_docker_hub_secrets() {
    log_info "Setting up Docker Hub credentials..."
    
    read -p "Docker Hub username: " docker_username
    read -sp "Docker Hub access token: " docker_password
    echo
    
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not installed"
        exit 1
    fi
    
    gh secret set DOCKER_USERNAME --body "$docker_username"
    gh secret set DOCKER_PASSWORD --body "$docker_password"
    
    log_success "Docker Hub secrets configured!"
}

# Info command
show_info() {
    echo
    log_info "Repository Information"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "Repository URL:  ${BLUE}$REPO_URL${NC}"
    echo -e "Current Branch:  ${BLUE}$CURRENT_BRANCH${NC}"
    echo -e "Main Branch:     ${BLUE}$MAIN_BRANCH${NC}"
    echo
    log_info "Docker Information"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    docker --version
    
    if command -v docker-compose &> /dev/null; then
        docker-compose --version
    fi
    
    echo
    log_info "Node.js Information"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    node --version
    npm --version
    
    echo
    log_info "Git Information"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    git --version
    
    if command -v gh &> /dev/null; then
        echo -e "${GREEN}GitHub CLI: Installed${NC}"
    else
        echo -e "${YELLOW}GitHub CLI: Not installed${NC}"
    fi
    
    echo
}

# Main script
main() {
    local command=$1
    local arg1=$2
    local arg2=$3
    
    case "$command" in
        push)
            push_code
            ;;
        status)
            show_git_status
            ;;
        clean-branches)
            clean_merged_branches
            ;;
        list-branches)
            list_branches
            ;;
        release)
            create_release "$arg1"
            ;;
        list-tags)
            list_tags
            ;;
        trigger-workflow)
            trigger_workflow
            ;;
        view-runs)
            view_workflow_runs
            ;;
        watch-workflow)
            watch_workflow
            ;;
        build)
            build_docker
            ;;
        run)
            run_docker
            ;;
        add-secret)
            add_github_secret "$arg1" "$arg2"
            ;;
        list-secrets)
            list_github_secrets
            ;;
        delete-secret)
            delete_github_secret "$arg1"
            ;;
        init)
            init_github_cli
            ;;
        setup-docker-hub)
            setup_docker_hub_secrets
            ;;
        info)
            show_info
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            echo
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
