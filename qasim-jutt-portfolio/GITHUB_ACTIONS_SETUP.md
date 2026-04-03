# GitHub Actions Setup Guide

## Workflow Overview

This CI/CD pipeline automates the entire process of testing, building Docker images, and deploying your application.

### Pipeline Stages

#### 1. **Test** (Always Runs)
- Checkout code
- Set up Node.js 16
- Install dependencies
- Build project
- Run tests
- Upload coverage reports

#### 2. **Build Docker** (Only on Push to Main)
- Build Docker image using multi-stage build
- Push to GitHub Container Registry (GHCR)
- Optional: Push to Docker Hub
- Generate image metadata and tags automatically

#### 3. **Security Scan** (After Docker Build)
- Scan Docker image for vulnerabilities using Trivy
- Upload results to GitHub Security tab
- Continue pipeline even if scan fails

#### 4. **Deploy** (On Main Branch Push)
- Notification and status reporting
- Ready for custom deployment steps (AWS, Azure, Heroku, etc.)

#### 5. **Release** (On Version Tags)
- Automatically create GitHub releases
- Generate release notes
- Provide pull command for Docker image

---

## Required Secrets Configuration

### GitHub Settings
1. Go to your repository
2. Settings → Secrets and variables → Actions
3. Add the following secrets:

#### Option 1: Push to GitHub Container Registry (GHCR) - Free
**Already configured!** The workflow uses `GITHUB_TOKEN` automatically.

#### Option 2: Also Push to Docker Hub (Optional)
If you want to push to Docker Hub, add:

```
DOCKER_USERNAME     = your-docker-hub-username
DOCKER_PASSWORD     = your-docker-hub-access-token
```

**How to get Docker Hub token:**
1. Go to https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Generate and copy the token
4. Add to GitHub Secrets

#### Option 3: Deploy to Heroku (If Using)
```
HEROKU_API_KEY      = your-heroku-api-key
HEROKU_APP_NAME     = your-heroku-app-name
HEROKU_EMAIL        = your-heroku-email
```

#### Option 4: Deploy to AWS (If Using)
```
AWS_ACCESS_KEY_ID       = your-aws-access-key
AWS_SECRET_ACCESS_KEY   = your-aws-secret-key
AWS_REGION              = us-east-1
```

---

## How to Set Up Secrets

### Via GitHub Web UI:
```
1. Go to Repository Settings
2. Left sidebar → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: DOCKER_USERNAME
5. Value: your-username
6. Click "Add secret"
```

### Via GitHub CLI:
```bash
gh secret set DOCKER_USERNAME --body "your-username"
gh secret set DOCKER_PASSWORD --body "your-access-token"
```

---

## Triggering the Workflow

### Automatic Triggers:
- **Push to main branch** → Runs test, build, security scan, deploy
- **Pull Request to main** → Runs test only
- **Push git tags** → Creates release (e.g., `git tag v1.0.0`)

### Manual Trigger:
1. Go to Actions tab
2. Select "CI/CD Pipeline - Build & Deploy Docker"
3. Click "Run workflow"
4. Select branch and click "Run workflow"

### Trigger with Commands:
```bash
# Push to main (triggers workflow)
git add .
git commit -m "Update code"
git push origin main

# Create tag (triggers release)
git tag v1.0.0
git push origin v1.0.0
```

---

## Docker Image Registry

### GitHub Container Registry (GHCR)
- **Free** with GitHub account
- **Included** in this workflow automatically
- **Access:** `ghcr.io/username/qasim-jutt-portfolio:latest`

### Docker Hub (Optional)
- Requires Docker Hub account (free at hub.docker.com)
- Requires `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets
- **Access:** `docker.io/username/qasim-portfolio:latest`

---

## Pulling Images

### From GitHub Container Registry:
```bash
# Login (use your GitHub token)
docker login ghcr.io -u USERNAME -p YOUR_GITHUB_TOKEN

# Pull image
docker pull ghcr.io/username/qasim-jutt-portfolio:latest

# Run container
docker run -p 3000:3000 ghcr.io/username/qasim-jutt-portfolio:latest
```

### From Docker Hub (if configured):
```bash
docker pull username/qasim-portfolio:latest
docker run -p 3000:3000 username/qasim-portfolio:latest
```

---

## Image Tags Explained

The workflow automatically creates multiple tags:

```
# Branch-based tags
latest              # Latest commit on main
main-abc123def      # Specific commit hash

# Version tags (when you push git tags)
v1.0.0              # Semantic version
1.0                 # Major.Minor version
1                   # Major version only
```

---

## Viewing Workflow Status

### GitHub Web UI:
1. Go to your repository
2. Click "Actions" tab
3. View running/completed workflows
4. Click workflow to see steps
5. Click step to see logs

### GitHub CLI:
```bash
# List recent workflows
gh run list

# View specific run
gh run view <run-id>

# Watch workflow in real-time
gh run watch
```

---

## Monitoring and Debugging

### View Workflow Logs:
1. Go to Actions tab
2. Click on the workflow run
3. Click on a job
4. Click on a step to expand logs

### Common Issues:

#### "npm test failed"
- Check Node version compatibility
- Ensure all dependencies are listed in package.json
- Review test configuration in jest.config.js

#### "Docker build failed"
- Check Dockerfile syntax
- Verify all files are correctly copied
- Check for missing dependencies

#### "Auth failed pushing to registry"
- Verify GITHUB_TOKEN has permissions
- Check DOCKER_USERNAME and DOCKER_PASSWORD are correct
- Ensure Docker Hub token hasn't expired

#### "Image too large"
- Review .dockerignore file
- Use Alpine Linux base image
- Install only production dependencies

---

## Auto-healing Features

The workflow includes `continue-on-error: true` for:
- Tests (example: npm test)
- Trivy security scanning
- Docker Hub push (if no credentials)
- Upload coverage

This ensures the pipeline continues even if optional steps fail.

---

## Next Steps

### 1. Add Docker Secrets (Optional but Recommended)
```bash
# Set secrets via CLI
gh secret set DOCKER_USERNAME --body "your-username"
gh secret set DOCKER_PASSWORD --body "your-token"
```

### 2. Add Repository Rules
1. Settings → Branches
2. Add branch protection rule for `main`
3. Require workflow to pass before merge

### 3. Enable GitHub Pages (Optional)
1. Settings → Pages
2. Select "Deploy from a branch"
3. Choose `gh-pages` branch

### 4. Add Deployment Configuration
Uncomment and configure deployment steps in `.github/workflows/ci-cd.yml`:
- Heroku
- AWS
- Azure
- Google Cloud
- DigitalOcean
- Any custom deployment

### 5. Monitor with GitHub Status Checks
- All workflows will show in pull request checks
- Status badges available for README.md

---

## Useful GitHub Actions Resources

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Docker Build Action](https://github.com/docker/build-push-action)
- [Container Registry Guide](https://docs.github.com/en/packages/working-with-a-github-packages-registry)
- [Secrets Management](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)

---

## Status Badge for README

Add this to your README.md to display workflow status:

```markdown
![CI/CD Pipeline](https://github.com/YOUR_USERNAME/qasim-jutt-portfolio/actions/workflows/ci-cd.yml/badge.svg)
```

Replace `YOUR_USERNAME` with your actual GitHub username.
