# GitHub Actions Complete Implementation Guide

## Overview

Your portfolio application has a complete CI/CD pipeline with 4 automated workflows:

1. **CI/CD Pipeline** - Main workflow (test → build → security scan → deploy → release)
2. **Code Quality** - Quality checks, linting, and code coverage
3. **Manual Docker Build** - Manually rebuild and push Docker images
4. **Deploy to Production** - Manual production deployment workflow

---

## Workflow Details

### 1. CI/CD Pipeline (ci-cd.yml)
**Triggers:** Push to main, Pull Requests, Manual trigger

**Stages:**
```
Code Commit
    ↓
Test (Node.js build & tests)
    ↓
Build Docker (if passing)
    ↓
Security Scan (Trivy vulnerability check)
    ↓
Deploy (notifications & custom steps)
    ↓
Release (automatic GitHub release for tags)
```

**Key Steps:**
- ✅ Runs automatically on push
- ✅ Tests code first
- ✅ Builds Docker image
- ✅ Pushes to GitHub Container Registry (GHCR)
- ✅ Optional: Pushes to Docker Hub
- ✅ Scans for vulnerabilities
- ✅ Creates releases for version tags

**When it runs:**
- Every push to `main` branch
- Every pull request to `main`
- When you push a version tag (v1.0.0)

---

### 2. Code Quality Workflow (quality-checks.yml)
**Triggers:** Push to main/develop, Pull Requests

**Checks:**
- Build verification
- Unit test execution with coverage
- SonarQube analysis (optional, requires token)
- PR comments with results

**When it runs:**
- Every push to main or develop
- Every pull request
- Automatic comments on PRs

---

### 3. Manual Docker Build (manual-docker-build.yml)
**Triggers:** Manual (Actions tab)

**Options:**
- Custom image tag
- Optional Docker Hub push
- Confirmation message with image URLs

**When to use:**
- Rebuild without code changes
- Test image changes
- Deploy specific version
- Maintain image cache

---

### 4. Deploy to Production (deploy-production.yml)
**Triggers:** Manual (Actions tab)

**Environments:**
- Staging (test deployment)
- Production (live deployment)

**Safety Features:**
- Manual trigger required
- Environment protection rules
- Smoke tests
- Deployment notifications

---

## Step-by-Step Setup

### Phase 1: Quick Start (5 minutes)

#### 1. Commit Changes to GitHub
```bash
cd "c:\Users\DELL\Desktop\New folder\my-first-repo\qasim-jutt-portfolio"

# Stage all changes
git add .

# Commit
git commit -m "Add Docker and GitHub Actions CI/CD"

# Push to main branch
git push origin main
```

#### 2. Monitor First Run
- Go to GitHub: https://github.com/YOUR_USERNAME/qasim-jutt-portfolio
- Click "Actions" tab
- Watch "CI/CD Pipeline - Build & Deploy Docker" run
- Check logs for any errors

### Phase 2: Configure Registries (10 minutes)

#### Option A: GitHub Container Registry (Free - Default)
✅ Already configured! No action needed.

**Image location:** `ghcr.io/YOUR_USERNAME/qasim-jutt-portfolio:latest`

**Pull command:**
```bash
docker pull ghcr.io/YOUR_USERNAME/qasim-jutt-portfolio:latest
```

#### Option B: Also Add Docker Hub (Optional)

1. **Create Docker Hub account** (free): https://hub.docker.com

2. **Generate Docker Hub token:**
   - Go to: https://hub.docker.com/settings/security
   - Click "New Access Token"
   - Name it: "GitHub Actions"
   - Click "Generate"
   - Copy token

3. **Add GitHub Secrets:**
   - Go to: https://github.com/YOUR_USERNAME/qasim-jutt-portfolio
   - Settings → Secrets and variables → Actions
   - Click "New repository secret"
   
   **Secret 1:**
   - Name: `DOCKER_USERNAME`
   - Value: Your Docker Hub username
   
   **Secret 2:**
   - Name: `DOCKER_PASSWORD`
   - Value: Your access token (from step 2)

4. **Test it:**
   - Go to Actions tab
   - Run "CI/CD Pipeline - Build & Deploy Docker" manually
   - Watch it push to Docker Hub

**Image locations:**
```
GitHub Container Registry: ghcr.io/YOUR_USERNAME/qasim-jutt-portfolio:latest
Docker Hub:              docker.io/YOUR_USERNAME/qasim-portfolio:latest
```

### Phase 3: Enable Quality Checks (Optional, 5 minutes)

#### Setup SonarQube (Optional)

1. Create free account: https://sonarcloud.io

2. Create project for your repository

3. Add GitHub Secret:
   - Settings → Secrets and variables → Actions
   - New secret
   - Name: `SONAR_TOKEN`
   - Value: From SonarCloud

4. Next workflow run will include quality analysis

### Phase 4: Enable Production Deployment (10 minutes)

#### Create Deployment Environment

1. Go to: Settings → Environments

2. Click "New environment"

3. Name: `production`

4. Click "Configure environment"

5. Add deployment branch protection (optional)

6. Repeat for `staging` environment

#### Add Deployment Credentials

Add any deployment secrets needed:
```
HEROKU_API_KEY
HEROKU_APP_NAME
HEROKU_EMAIL
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
```

---

## Using the Workflows

### Automatic Workflows

#### Trigger 1: Push to Main
```bash
git add .
git commit -m "Update code"
git push origin main
```
**Result:** Entire CI/CD pipeline runs automatically

#### Trigger 2: Create Pull Request
```bash
git checkout -b feature/new-feature
git add .
git commit -m "Add new feature"
git push origin feature/new-feature
# Create PR on GitHub
```
**Result:** Test and quality checks run (no deployment)

#### Trigger 3: Create Release
```bash
# Create semantic version tag
git tag v1.0.0
git push origin v1.0.0
```
**Result:** Full pipeline + automatic GitHub release creation

### Manual Workflows

#### Trigger Manual Docker Build
1. Go to GitHub Actions tab
2. Click "Manual Docker Build & Push" (left sidebar)
3. Click "Run workflow"
4. Select branch (main)
5. Optionally enter custom tag
6. Optionally enable Docker Hub push
7. Click "Run workflow"

#### Trigger Manual Deployment
1. Go to GitHub Actions tab
2. Click "Deploy to Production"
3. Click "Run workflow"
4. Select environment (staging or production)
5. Click "Run workflow"

---

## Monitoring & Debugging

### View Workflow Status

#### GitHub Web UI:
1. Go to: https://github.com/YOUR_USERNAME/qasim-jutt-portfolio
2. Click "Actions" tab
3. Click workflow run you want to view
4. Click job to expand
5. Click step to see logs

#### GitHub CLI:
```bash
# Install: choco install gh (on Windows with Chocolatey)

# List recent runs
gh run list

# View specific run
gh run view <run-id>

# Watch real-time
gh run watch
```

### Common Errors & Solutions

#### ❌ Error: "npm test failed"
**Solution:**
- Check jest configuration
- Ensure test files exist
- Review error logs

#### ❌ Error: "Docker build failed"
**Solution:**
- Check Dockerfile syntax
- Verify base image exists
- Check for typos in COPY commands
- Ensure .dockerignore is correct

#### ❌ Error: "Failed to authenticate with container registry"
**Solution:**
- Verify GITHUB_TOKEN has access
- Check DOCKER_USERNAME and DOCKER_PASSWORD match
- Ensure secrets don't have extra spaces
- Regenerate tokens if needed

#### ❌ Error: "unauthorized: authentication required"
**Solution:**
- DOCKER_PASSWORD should be access token, not password
- Check token hasn't expired
- Verify Docker Hub account permissions

#### ❌ Error: "Image 'ghcr.io/...' not found"
**Solution:**
- Workflow must complete successfully first
- Images aren't available until workflow passes
- Check Actions tab for errors

#### ❌ Workflow doesn't trigger
**Solution:**
- Verify you pushed to `main` branch (not `master`)
- Check branch protection rules
- Verify workflow file syntax is correct
- Review `.yml` file for errors

---

## Best Practices

### 1. Branching Strategy
```
main (production-ready)
  └── develop (integration branch)
       └── feature/name (feature branches)
```

### 2. Commit Message Format
```
[type]: description

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- test: Testing
- ci: CI/CD changes
- refactor: Code refactoring

Example:
git commit -m "feat: Add Docker support"
```

### 3. Version Tagging
```bash
# Semantic versioning: MAJOR.MINOR.PATCH

git tag v1.0.0
git tag v1.0.1  # Patch release
git tag v1.1.0  # Minor release
git tag v2.0.0  # Major release

git push origin --tags
```

### 4. Pull Request Workflow
```bash
1. Create feature branch
   git checkout -b feature/new-feature

2. Make changes and commit
   git add .
   git commit -m "feature: add new feature"

3. Push and create PR
   git push origin feature/new-feature
   # Create PR on GitHub

4. Tests run automatically
   # Fix any failing tests

5. Merge PR
   # GitHub will show "All checks passed"

6. Delete feature branch
   git branch -D feature/new-feature
```

### 5. Secrets Management
- ✅ Use GitHub Secrets for sensitive data
- ✅ Rotate credentials quarterly
- ✅ Never commit secrets to repository
- ✅ Use minimal permissions
- ✅ Monitor access logs

---

## Advanced Configurations

### Add Kubernetes Deployment (K8s)

Uncomment in `deploy-production.yml`:
```yaml
- name: Deploy to Kubernetes
  run: |
    kubectl apply -f k8s/deployment.yml
```

### Add AWS Deployment

Uncomment in `deploy-production.yml`:
```yaml
- name: Deploy to AWS ECR
  run: |
    aws ecr get-login-password --region ${{ secrets.AWS_REGION }} | \
    docker login --username AWS --password-stdin $ECR_REGISTRY
    docker push $ECR_REGISTRY/$ECR_REPOSITORY:latest
```

### Add Slack Notifications

Add secret: `SLACK_WEBHOOK`

Then use in workflows:
```yaml
- name: Notify Slack
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Add Email Notifications

Use GitHub's repository settings:
1. Settings → Notifications
2. Enable email on workflow failures

---

## Workflow Files Location

```
.github/workflows/
├── ci-cd.yml                    # Main CI/CD pipeline
├── manual-docker-build.yml      # Manual Docker build
├── quality-checks.yml           # Code quality checks
└── deploy-production.yml        # Manual deployment
```

---

## Status Badge for README

Add to your README.md:

```markdown
# Qasim Jutt's Portfolio

![CI/CD Status](https://github.com/YOUR_USERNAME/qasim-jutt-portfolio/actions/workflows/ci-cd.yml/badge.svg)

**Status:** 
- ✅ Tests: Passing
- ✅ Docker: Building automatically
- ✅ Security: Scanning
```

Replace `YOUR_USERNAME` with your actual GitHub username.

---

## Troubleshooting Checklist

- [ ] Branch is `main` (not `master`)
- [ ] All workflow files in `.github/workflows/` are valid YAML
- [ ] Secrets are configured correctly
- [ ] Dockerfile syntax is correct
- [ ] No typos in image names
- [ ] Node version matches (16)
- [ ] Docker command works locally first
- [ ] .dockerignore file exists
- [ ] All dependencies in package.json
- [ ] Environment variables set correctly

---

## Useful Links

- [GitHub Actions Docs](https://docs.github.com/actions)
- [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Docker Build Action](https://github.com/docker/build-push-action)
- [Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry)
- [GitHub CLI](https://cli.github.com/)
- [GitHub Status Checks](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)

---

## Next Steps

1. ✅ Commit and push to GitHub
2. ✅ Monitor first workflow run
3. ✅ Add Docker Hub secrets (optional)
4. ✅ Enable code quality checks
5. ✅ Test manual workflows
6. ✅ Configure deployment (optional)
7. ✅ Add status badges to README
8. ✅ Share workflow docs with team

---

**Ready to deploy!** 🚀
