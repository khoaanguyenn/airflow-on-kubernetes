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

The workflow `.github/workflows/deploy-docs.yml` is configured to build and deploy to GitHub Pages:

```yaml
permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.146.0'
          extended: true

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Build
        run: |
          cd docs
          hugo --minify

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./docs/public

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

## 4. Local Preview
To preview the documentation locally:
```bash
cd docs
hugo server
```
