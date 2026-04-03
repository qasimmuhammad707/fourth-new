# GitHub Secrets Configuration

This file explains all the secrets needed for the GitHub Actions CI/CD pipeline.

## Quick Setup

### Step 1: GitHub Container Registry (GHCR) - Automatic ✅
No action needed! Uses default `GITHUB_TOKEN` automatically.

### Step 2: Docker Hub Push - Optional
If you want to push images to Docker Hub, add these secrets:

#### Go to GitHub Settings:
```
Repository Settings → Secrets and variables → Actions → New repository secret
```

#### Add These Secrets:

**Secret 1: DOCKER_USERNAME**
- Name: `DOCKER_USERNAME`
- Value: Your Docker Hub username
- Example: `qasimjutt`

**Secret 2: DOCKER_PASSWORD**
- Name: `DOCKER_PASSWORD`
- Value: Your Docker Hub access token (NOT your password)
- How to generate:
  1. Go to https://hub.docker.com/settings/security
  2. Click "New Access Token"
  3. Give it a name: "GitHub Actions"
  4. Click "Generate"
  5. Copy the token immediately

### Step 3: Deployment Credentials - Optional

#### For Heroku Deployment:
```
HEROKU_API_KEY      = Your Heroku API Key
HEROKU_APP_NAME     = Your Heroku application name
HEROKU_EMAIL        = Your Heroku email
```

**Get Heroku API Key:**
1. Go to https://dashboard.heroku.com/account/applications/authorizations
2. Create new authorization
3. Copy token

#### For AWS Deployment:
```
AWS_ACCESS_KEY_ID       = Your AWS Access Key ID
AWS_SECRET_ACCESS_KEY   = Your AWS Secret Access Key
AWS_REGION              = us-east-1 (or your region)
```

**Get AWS Keys:**
1. Go to AWS IAM console
2. Create new user or use existing
3. Create access key
4. Copy Access Key ID and Secret Access Key

#### For Azure Deployment:
```
AZURE_SUBSCRIPTION_ID   = Your Azure subscription ID
AZURE_RESOURCE_GROUP    = Your resource group name
AZURE_APP_NAME          = Your app name
```

---

## Complete Secrets Reference

| Secret Name | Required | Source | Used For |
|-----------|----------|--------|----------|
| `GITHUB_TOKEN` | ✅ Auto | GitHub | GHCR push, releases |
| `DOCKER_USERNAME` | ❌ Optional | Docker Hub | Docker Hub push |
| `DOCKER_PASSWORD` | ❌ Optional | Docker Hub | Docker Hub authentication |
| `HEROKU_API_KEY` | ❌ Optional | Heroku | Heroku deployment |
| `HEROKU_APP_NAME` | ❌ Optional | Heroku | Heroku app identifier |
| `HEROKU_EMAIL` | ❌ Optional | Heroku | Heroku account email |
| `AWS_ACCESS_KEY_ID` | ❌ Optional | AWS IAM | AWS deployment |
| `AWS_SECRET_ACCESS_KEY` | ❌ Optional | AWS IAM | AWS authentication |
| `AWS_REGION` | ❌ Optional | AWS | AWS region selection |

---

## Setting Secrets via GitHub CLI

```bash
# Install GitHub CLI: https://cli.github.com

# Login
gh auth login

# Set Docker Hub secrets
gh secret set DOCKER_USERNAME --body "your-username"
gh secret set DOCKER_PASSWORD --body "your-access-token"

# Set Heroku secrets
gh secret set HEROKU_API_KEY --body "your-api-key"
gh secret set HEROKU_APP_NAME --body "your-app-name"
gh secret set HEROKU_EMAIL --body "your-email"

# Set AWS secrets
gh secret set AWS_ACCESS_KEY_ID --body "your-access-key"
gh secret set AWS_SECRET_ACCESS_KEY --body "your-secret-key"
gh secret set AWS_REGION --body "us-east-1"

# List all secrets
gh secret list
```

---

## Verifying Secrets

```bash
# List all secrets (doesn't show values)
gh secret list

# Check if a secret exists
gh secret list | grep DOCKER_USERNAME
```

---

## Testing Secrets in Workflow

Add this step to your workflow to test (without exposing values):

```yaml
- name: Test Secrets
  run: |
    if [ -z "${{ secrets.DOCKER_USERNAME }}" ]; then
      echo "⚠️  DOCKER_USERNAME not set"
    else
      echo "✅ DOCKER_USERNAME is configured"
    fi
```

---

## Security Best Practices

1. **Never commit secrets to repository**
   - GitHub will automatically scan for exposed tokens
   - Use `.gitignore` for local `.env` files

2. **Rotate credentials regularly**
   - Change Docker Hub tokens every 90 days
   - Update AWS keys quarterly

3. **Use minimal permissions**
   - Docker Hub: Only push permissions
   - AWS: Limited IAM policy
   - GitHub: Uses minimal default token scope

4. **Monitor usage**
   - Check deployment logs regularly
   - Review GitHub Actions activity

5. **Revoke immediately if compromised**
   - Docker Hub: Regenerate token
   - AWS: Delete access key
   - GitHub: Review token usage

---

## Common Secret Issues

### Docker Hub

**Error:** `unauthorized: authentication required`
- Solution: Check DOCKER_USERNAME and DOCKER_PASSWORD match
- The password should be an access token, not your actual password

**Error:** `denied: requested access to the resource is denied`
- Solution: Ensure Docker Hub account has push permissions to the repository

### AWS

**Error:** `InvalidClientTokenId`
- Solution: Verify AWS_ACCESS_KEY_ID is correct
- Generate new keys if needed

**Error:** `AccessDenied`
- Solution: Check IAM user has proper permissions
- May need to add additional policies

### Heroku

**Error:** `Couldn't find that app.`
- Solution: Verify HEROKU_APP_NAME matches exactly (case-sensitive)
- Check app exists on Heroku dashboard

---

## Removing Secrets

```bash
# Via CLI
gh secret delete DOCKER_USERNAME

# Via Web UI:
# Settings → Secrets and variables → Actions → [Secret Name] → Delete
```

---

## Environment Variables vs Secrets

### Use Secrets For:
- Passwords and tokens
- API keys
- Authentication credentials
- Private configuration

### Use Environment Variables For:
- Application settings (in docker-compose.yml)
- Public configuration
- Feature flags
- Non-sensitive settings

Example in workflow:
```yaml
env:
  PUBLIC_SETTING: value

jobs:
  build:
    steps:
      - run: echo $PUBLIC_SETTING
      - run: echo ${{ secrets.PRIVATE_TOKEN }}
```

---

## GitHub Actions Permissions

The workflow needs these permissions:

```yaml
permissions:
  contents: read       # Read repository contents
  packages: write      # Write to GitHub Container Registry
```

Check these are configured correctly in Settings → Actions → General.

---

## Troubleshooting

### Secrets not appearing in logs?
✅ Good! GitHub automatically masks secrets in logs for security.

### Workflow fails but no error message?
Check if the secret is actually set with: `gh secret list`

### Different behavior locally vs GitHub Actions?
- Local: Uses .env file
- GitHub: Uses secrets
- Ensure values match exactly in both places

---

For more information, see:
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Docker Hub Tokens](https://hub.docker.com/settings/security)
- [AWS Access Keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
