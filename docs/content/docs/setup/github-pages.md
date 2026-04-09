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

The workflow `.github/workflows/deploy-docs.yml` is split into two jobs: `build` and `deploy`.

### Testing on Feature Branches
The `build` job runs on all branches (including feature branches matching `setup-hextra-docs-s3-*`) to verify that the documentation builds correctly.

If you want to test the full deployment from a feature branch, you may need to adjust the Environment protection rules in GitHub Settings, as by default, only the `main` branch may be allowed to deploy to the `github-pages` environment.

## 4. Local Preview

The most common way to test changes is by running Hugo locally:

```bash
cd docs
hugo server
```
This will start a local server at `http://localhost:1313/` with live reloading.

## 5. Deployment Verification

After pushing changes, you can monitor the progress in the **Actions** tab.
- The **build** job will always run to verify your changes.
- The **deploy** job will only run on the `main` branch.
