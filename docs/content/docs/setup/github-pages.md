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

The workflow `.github/workflows/docs.yml` manages both verification and deployment.

### Testing Strategy
The workflow is split into two jobs: `build` and `deploy`.

- **Build Job**: This job runs on all pushes to the `docs/` directory, including feature branches. It verifies that the site builds correctly and uploads the resulting artifact.
- **Deploy Job**: This job runs on the `main` branch and currently also on the `setup-hextra-docs-s3-*` feature branches for testing purposes.

**Note**: When working on other feature branches, you will see the `deploy` job appear as "skipped". This ensures that only finalized content from `main` is published to the production site.

### Local Preview
The most common way to test changes is by running Hugo locally:
```bash
cd docs
hugo server
```
This will start a local server at `http://localhost:1313/` with live reloading.

## 4. Deployment Verification

After pushing changes, you can monitor the progress in the **Actions** tab.
- The **build** job will always run to verify your changes.
- The **deploy** job will run if the branch is `main` or the current testing branch.
