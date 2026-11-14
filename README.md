# Psychiatry Papers & Perspectives

Two Jekyll newsletters: Landmark Psychiatry Papers and Psychosis Psychoeducation.

## Local preview

Use the existing rbenv Ruby 3.4.12 and run `bundle exec jekyll serve`.

## Editorial workflow

Write issues in `_drafts/` with `approved: false` and `published: false`. Drafts and the `editorial/` folder stay on your Mac; `.gitignore` keeps them out of the repository. Back them up separately. Never force-add these folders to a public repository.

Every issue must explicitly declare its newsletter (`landmark-psychiatry-papers` or `psychosis-psychoeducation`) and these three fields. Use real YAML booleans, without quotation marks.

| `editorial_status` | `approved` | `published` | Location and meaning |
| --- | --- | --- | --- |
| `draft` | `false` | `false` | Local `_drafts/`; initial work |
| `draft-for-review` | `false` | `false` | Local `_drafts/`; awaiting review |
| `revisions-requested` | `false` | `false` | Local `_drafts/`; changes required |
| `approved` | `true` | `false` | `_posts/`; reviewed version ready for the next deliberate deployment |
| `published` | `true` | `true` | `_posts/`; issue verified on the live website |

After explicit editorial approval of an exact version, move it into `_posts/` with `editorial_status: approved`, `approved: true`, and `published: false`. Open a pull request and review the validation results. Merging source does not deploy it. Draft or revision states are rejected in `_posts/` because this repository is public, even when Jekyll would hide them from the website.

The publishing build includes both approved and previously published issues. It sets Jekyll's rendering flag to `true` only in a temporary build copy, so an approved issue can be deployed without claiming in source that publication has already succeeded. It never rewrites the reviewed source or updates the editorial ledger. Future-dated issues remain excluded until their date arrives.

After a successful deployment, verify the live issue, homepage, and archive, then update the source fields to `editorial_status: published` and `published: true`. If deployment fails, keep the issue `approved` and retry deliberately after fixing the failure. A validation pass checks consistency; it cannot establish that a person approved the manuscript or that a deployment succeeded.

For a correction, revise a private local copy first. After reviewing the correction, replace the issue at the same `_posts/` path and keep its date and permalink, with the `approved` state until that corrected version is deployed and verified. The current live issue remains unchanged until the next manual publish. Keep the review and publication record locally in `editorial/`.

## AI disclosure and About page

The `newsletter-issue` layout adds `_includes/newsletter-footer.html` to both series. Keep this boilerplate out of individual article bodies. Each website issue displays AI assistance, its model and generation date when recorded, educational limits, the publisher's editorial responsibility, and a link to `/about/`.

The About page explains the Jekyll newsletter-automation experiment, AI-assisted scholarly output, metadata policy, review and manual publication process, editorial accountability, and corrections. Longer project explanations belong there, not in every issue footer. Older issues with missing model metadata explicitly say it was not recorded; never infer their model from the current issue.

For each new AI-assisted draft, record verified generation details in front matter, for example:

```yaml
ai_generation:
  provider: OpenAI
  model: gpt-6.1-sol
  model_family: GPT-6.1
  interface: Codex
  generation_date: 2026-11-13
  model_identity_source: Codex session metadata
  role: Research assistance and initial drafting
publishing_platform: Jekyll
```

This is an example, not a default model or date. Use the identifier and generation date actually recorded for that issue. Keep generation provenance separate from publication dates and editorial approval. When distributing a standalone export or email, include the same short disclosure; the website's layout is not applied to raw Markdown or the default RSS content.

## Validation without publication

Pull requests and pushes to `main` run **Validate editorial workflow**. It checks metadata and tracked private files, tests the four editorial scenarios below, and builds the site. It has read-only repository permissions and does not upload a Pages artifact or deploy.

Run the same checks locally:

```sh
bundle exec ruby scripts/validate_editorial.rb
bundle exec ruby test/editorial_workflow_test.rb
PAGES_ORIGIN=https://ejulianbravo.github.io PAGES_BASE_PATH=/psychiatry-newsletters bundle exec ruby scripts/build_pages.rb
```

The last command builds `_site/` locally, including approved issues. An ordinary `jekyll serve` preview still hides `published: false` posts. Do not use an ordinary Jekyll build as a replacement for the validated production build.

The tests use temporary repositories and local builds to check:

1. Private drafts and editorial records stay out of website output; tracking them blocks validation.
2. Invalid editorial states, missing or quoted booleans, unknown newsletters, malformed YAML, and unapproved public issues block publication.
3. Approved issues appear in the correct independent archive and feed without changing source metadata.
4. Reviewed corrections replace the issue at the same address, while deployment remains manually gated.

These are local end-to-end build tests, not live deployments. The final live verification still happens after you explicitly publish. Validation alone does not make a required merge check; configure branch protection separately if you want GitHub to prevent merging a failed check.

## GitHub Pages setup

1. Use the existing public repository `ejulianbravo/psychiatry-newsletters`. Review the preparation branch before merging into `main`. Do not upload the entire project folder through the website: `.gitignore` applies to Git, not browser uploads.
2. Upload only the Git-tracked source after reviewing `git status` and `git ls-files`. Drafts, editorial records, generated `_site`, and starter issue placeholders must not be tracked.
3. In repository Settings > Pages, select **GitHub Actions** as the publishing source. Keep the workflow on the `main` branch.
4. Review the exact version to be published. Only when approved, open Actions > Publish approved newsletters > Run workflow, select `main`, type `PUBLISH`, and run it. This step makes the built website public. Uploading source alone does not run this workflow.
5. Wait for success and review the Pages URL. Mark the source metadata and local editorial ledger published only after confirming the live issue. Commit that metadata update; it runs validation without deploying again.

The workflow uses the repository's Pages metadata for its domain and path. Local `_config.yml` stays unchanged so localhost links keep working. A custom Ruby build uses the existing Jekyll Gemfile rather than replacing the working Ruby/rbenv setup.

A free GitHub account can use Pages from a public repository. Pages from a private repository requires a qualifying paid plan; a private source repository does not automatically make the website private. Decide source visibility before uploading.

GitHub reference: https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages
