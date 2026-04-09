---
title: Hextra Setup & S3 Deployment
---

# Hextra Setup & S3 Deployment Guide

This guide explains how to set up the Hextra Hugo theme for documentation and deploy it to an AWS S3 bucket using GitHub Actions with OIDC authentication.

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

## 3. GitHub Actions & OIDC Setup (Recommended)

Using OpenID Connect (OIDC) is more secure than using long-lived IAM access keys.

### Step 1: Create IAM OIDC Provider
If not already present in your AWS account:
1. Go to IAM > Identity providers.
2. Add provider > OpenID Connect.
3. Provider URL: `https://token.actions.githubusercontent.com`
4. Audience: `sts.amazonaws.com`

### Step 2: Create IAM Role for GitHub Actions
1. Create a new IAM Role.
2. Select **Web identity**.
3. Choose the GitHub provider, your organization/user, and repository.
4. Attach a policy allowing S3 access to your bucket:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::your-bucket-name",
                "arn:aws:s3:::your-bucket-name/*"
            ]
        }
    ]
}
```
5. Note the Role ARN.

### Step 3: GitHub Secrets
Add the following secrets to your GitHub repository:
- `AWS_ROLE_TO_ASSUME`: The ARN of the IAM role created above.
- `AWS_S3_BUCKET`: Name of your S3 bucket.
- `AWS_REGION`: e.g., `us-east-1`.

### Workflow File
The workflow `.github/workflows/deploy-docs.yml` is configured to use OIDC:

```yaml
permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    steps:
      # ... checkout and build ...
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_TO_ASSUME }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Deploy to S3
        uses: jakejarvis/s3-sync-action@v0.5.1
        with:
          args: --acl public-read --follow-symlinks --delete
        env:
          AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
          SOURCE_DIR: 'docs/public'
```

## 4. Local Preview
To preview the documentation locally:
```bash
cd docs
hugo server
```
