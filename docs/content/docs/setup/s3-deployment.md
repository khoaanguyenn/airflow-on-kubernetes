---
title: Hextra Setup & S3 Deployment
---

# Hextra Setup & S3 Deployment Guide

This guide explains how to set up the Hextra Hugo theme for documentation and deploy it to an AWS S3 bucket using GitHub Actions.

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

## 2. AWS S3 Setup

1. **Create an S3 Bucket**: Create a bucket (e.g., `my-airflow-docs`).
2. **Enable Static Website Hosting**: In the bucket properties, enable static website hosting and set the index document to `index.html`.
3. **Public Access**: Ensure the bucket allows public read access (or use a CloudFront distribution for better security).
4. **IAM User**: Create an IAM user with `AmazonS3FullAccess` (or more restricted permissions to only that bucket) and generate access keys.

## 3. GitHub Actions Configuration

### GitHub Secrets
Add the following secrets to your GitHub repository:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_S3_BUCKET`: Name of your S3 bucket.
- `AWS_REGION`: e.g., `us-east-1`.

### Workflow File
Create `.github/workflows/deploy-docs.yml`:

```yaml
name: Deploy Documentation
on:
  push:
    branches:
      - main
    paths:
      - 'docs/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build
        run: |
          cd docs
          hugo --minify

      - name: Deploy to S3
        uses: jakejarvis/s3-sync-action@master
        with:
          args: --acl public-read --follow-symlinks --delete
        env:
          AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_REGION: ${{ secrets.AWS_REGION }}
          SOURCE_DIR: 'docs/public'
```

## 4. Local Preview
To preview the documentation locally:
```bash
cd docs
hugo server
```
