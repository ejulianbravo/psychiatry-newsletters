# Psychiatry Papers & Perspectives

Two Jekyll newsletters: Landmark Psychiatry Papers and Psychosis Psychoeducation.

## Local preview

Use the existing rbenv Ruby 3.4.12 and run `bundle exec jekyll serve`.

## Editorial workflow

Write issues in `_drafts/` with `approved: false` and `published: false`. Drafts and the `editorial/` folder stay on your Mac; `.gitignore` keeps them out of the repository. Back them up separately. Never force-add these folders to a public repository.

After explicit editorial approval of a version, move it into `_posts/`, include its newsletter slug, and set `approved: true` and `published: true`. Check the normal local build before publishing. The production build rejects explicitly published posts without approval.

## GitHub Pages setup

1. Use the existing public repository `ejulianbravo/psychiatry-newsletters`. Review the preparation branch before merging into `main`. Do not upload the entire project folder through the website: `.gitignore` applies to Git, not browser uploads.
2. Upload only the Git-tracked source after reviewing `git status` and `git ls-files`. Drafts, editorial records, generated `_site`, and starter issue placeholders must not be tracked.
3. In repository Settings > Pages, select **GitHub Actions** as the publishing source. Keep the workflow on the `main` branch.
4. Review the exact version to be published. Only when approved, open Actions > Publish approved newsletters > Run workflow, select `main`, type `PUBLISH`, and run it. This step makes the built website public. Uploading source alone does not run this workflow.
5. Wait for success and review the Pages URL. Mark the editorial ledger published only after confirming the live issue.

The workflow uses the repository's Pages metadata for its domain and path. Local `_config.yml` stays unchanged so localhost links keep working. A custom Ruby build uses the existing Jekyll Gemfile rather than replacing the working Ruby/rbenv setup.

A free GitHub account can use Pages from a public repository. Pages from a private repository requires a qualifying paid plan; a private source repository does not automatically make the website private. Decide source visibility before uploading.

GitHub reference: https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages
