---
title: Hextra Setup & GitHub Pages Deployment
---

# Hextra Setup & GitHub Pages Deployment Guide

This guide explains how to set up the Hextra Hugo theme for documentation and deploy it to GitHub Pages using GitHub Actions.

## 1. Hugo Hextra Setup

The documentation is located in the `docs/` directory.

### Prerequisites
- Hugo (Extended version)
- Go (for Hugo Modules)

### Initialization
To initialize a similar setup:
```bash
hugo new site docs --format yaml
cd docs
hugo mod init github.com/yourusername/yourrepo/docs
```

### Configuration
Update `hugo.yaml` to include Hextra:
```yaml
module:
  imports:
    - path: github.com/imfing/hextra
```

## 2. GitHub Pages Configuration

1. **Repository Settings**:
   - Go to **Settings** > **Pages**.
   - Under **Build and deployment** > **Source**, select **GitHub Actions**.

## 3. GitHub Actions Workflow

The workflow `.github/workflows/deploy-docs.yml` is configured to build and deploy to GitHub Pages.

### Testing on Feature Branches
To test documentation changes without merging to `main`, you can update the `on.push.branches` section of the workflow file to include your feature branch name:

```yaml
on:
  push:
    branches:
      - main
      - 'your-feature-branch' # Add your branch here
```

The current configuration is set to match `setup-hextra-docs-s3-*` branches for testing this specific setup.

## 4. Local Preview

The most common way to test changes is by running Hugo locally:

```bash
cd docs
hugo server
```
This will start a local server at `http://localhost:1313/` with live reloading.

## 5. Deployment Verification

After pushing changes to a branch that triggers the workflow, you can monitor the progress in the **Actions** tab of your GitHub repository. Once complete, the URL of the deployed site will be available in the deployment job summary.
