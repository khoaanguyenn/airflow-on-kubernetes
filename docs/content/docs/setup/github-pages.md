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

### Testing Strategy
Automatic deployment is restricted to the `main` branch due to GitHub's Environment Protection Rules for GitHub Pages.

#### Local Preview
The most common way to test changes is by running Hugo locally:
```bash
cd docs
hugo server
```
This will start a local server at `http://localhost:1313/` with live reloading.

#### Manual Testing on GitHub
You can manually trigger the workflow on any branch using the **workflow_dispatch** event:
1. Go to the **Actions** tab in your repository.
2. Select the **Deploy Documentation** workflow.
3. Click the **Run workflow** dropdown and select your branch.

Note: Deployment to the live site will still be skipped unless triggered from the `main` branch, but the `build` job will verify your changes.

## 4. Deployment Verification

After pushing changes to `main`, you can monitor the progress in the **Actions** tab.
- The **build** job will always run to verify your changes.
- The **deploy** job will only run on the `main` branch.
