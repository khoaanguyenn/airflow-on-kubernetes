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
- **Deploy Job**: This job only runs on the `main` branch. It takes the artifact from the `build` job and publishes it to GitHub Pages.

**Note**: When working on a feature branch, you will see the `deploy` job appear as "skipped". This is expected and ensures that only the stable version from the `main` branch is ever published to the live site.

### Local Preview
The most common way to test changes is by running Hugo locally:
```bash
cd docs
hugo server
```
This will start a local server at `http://localhost:1313/` with live reloading.

## 4. Deployment Verification

After pushing changes to `main`, you can monitor the progress in the **Actions** tab.
- The **build** job will always run to verify your changes.
- The **deploy** job will only run on the `main` branch.
