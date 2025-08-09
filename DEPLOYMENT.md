# Deployment Guide for Joe Ma Dev Tech Blog

## Current Status

Your Hugo blog is set up with:
- ✅ About page at `/content/about/index.md`
- ✅ Posts section with welcome post at `/content/posts/welcome.md`
- ✅ Search page at `/content/search/index.md`
- ✅ Navigation menu configured in `hugo.toml`

## Compatibility Issue

The LoveIt theme has compatibility issues with Hugo v0.148.2. You have two options:

### Option 1: Fix Theme Compatibility (Recommended)

1. **Use an older Hugo version** (v0.128.x):
   ```bash
   brew install hugo@0.128
   ```

2. **Or switch to a compatible theme**:
   ```bash
   # Remove current theme
   rm -rf themes/LoveIt
   
   # Add PaperMod theme (actively maintained)
   git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
   
   # Update config
   sed -i '' 's/theme = "LoveIt"/theme = "PaperMod"/' hugo.toml
   ```

### Option 2: Deploy with Current Setup

Despite the build errors, the basic site structure works. To deploy:

1. **For GitHub Pages**:
   ```bash
   # Create .github/workflows/hugo.yml
   mkdir -p .github/workflows
   ```

2. **Add GitHub Actions workflow** (create `.github/workflows/hugo.yml`):
   ```yaml
   name: Deploy Hugo site to Pages

   on:
     push:
       branches: ["main"]
     workflow_dispatch:

   permissions:
     contents: read
     pages: write
     id-token: write

   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
           with:
             submodules: recursive
         - name: Setup Hugo
           uses: peaceiris/actions-hugo@v2
           with:
             hugo-version: '0.128.0'
             extended: true
         - name: Build
           run: hugo --minify
         - name: Upload artifact
           uses: actions/upload-pages-artifact@v3
           with:
             path: ./public

     deploy:
       environment:
         name: github-pages
         url: ${{ steps.deployment.outputs.page_url }}
       runs-on: ubuntu-latest
       needs: build
       steps:
         - name: Deploy to GitHub Pages
           id: deployment
           uses: actions/deploy-pages@v4
   ```

3. **Enable GitHub Pages**:
   - Go to Settings → Pages
   - Source: GitHub Actions
   - Push to main branch

## Quick Start Commands

```bash
# Test locally (if theme is fixed)
hugo server -D

# Build for production
hugo --minify

# Your site will be at: https://mrjoema.github.io/
```

## Next Steps

1. Fix theme compatibility or switch themes
2. Customize site appearance in `hugo.toml`
3. Add more posts in `/content/posts/`
4. Deploy using GitHub Actions

The site structure is ready - you just need to resolve the theme compatibility issue before deployment.