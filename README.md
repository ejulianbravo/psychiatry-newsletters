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

Capture the exact model identifier from the drafting run's metadata when saving the manuscript, and note the evidence in `model_identity_source`. Keep any private run reference in the series ledger. Record substantive AI-assisted revisions separately in `ai_revisions`, including the revision model and date. If the drafting run's model cannot be verified, record `model: null` and describe the evidence available in the private draft. Resolve the identifier before publication preparation. Editorial validation requires an explicit model identifier and source field for posts dated November 19, 2026 or later.

## Newsletter identity and reader navigation

Each series has its own masthead, audience description, visual accent, and landing page. The landing page features its latest issue and names the previous issues, while keeping a clear link to the other newsletter.

Issue pages identify the newest edition as **Latest issue**. Older editions say **From the archive** and offer a route to the current issue. A named previous-issue invitation appears before the article when an earlier edition exists; named previous/next links at the end remain within the same series. Manuscript wording and generation provenance stay in their existing source files.

Use these permanent destinations for reusable QR codes once this website version is published:

- `/psychosis/latest/` — latest Psychosis Psychoeducation issue.
- `/landmarks/latest/` — latest Landmark Psychiatry Papers issue.

Their destinations are selected during the normal validated build and advance only when the website is deliberately published. Drafts and future-dated editions are excluded. An empty series falls back to its own landing page. A QR code tied to a particular edition should use that edition's permanent article URL instead.

The latest-issue redirects preserve only the standard `utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, and `utm_term` campaign parameters. With JavaScript disabled they still open the correct issue, but do not preserve the incoming campaign tags. These redirect pages do not load analytics; counting occurs on the destination issue to avoid counting the redirect as a second visit.

## Basic visitor analytics

The initial analytics choice is Umami Cloud's free Hobby plan, with both newsletters registered as one website at `psychiatrypapers.org`. Its public tracking details are in `analytics.umami.website_id` and `analytics.umami.script_url` in `_config.yml`. Empty values disable the integration. Obtain both public values from the actual site's tracking snippet; do not put account passwords or API keys in this repository.

Once configured and deliberately published, the shared site layout loads the tracker only in a build for `https://psychiatrypapers.org`; its domain restriction prevents recording local preview hosts. Events use the newsletter slug as a tag, with `site` for general pages. Latest-issue and legacy redirects remain untracked. Existing QR codes use `utm_source=qr`; group-specific codes can add stable identifiers in `utm_content` without changing the latest-issue destination.

Before enabling collection, add an accurate analytics explanation to About, run all validation commands below, and inspect the exact integration. After deliberate publication, verify a normal pageview and QR-tagged arrival in the real dashboard. A build or test with fixture identifiers does not establish live collection.

The free plan currently retains six months of analytics. Preserve dated monthly exports through Umami Cloud's **Settings → Data → Export** for longer-term reporting. Hobby has no API access, so automatic API exports are not part of this initial setup. Keep usage definitions and QR group mappings privately with the exports. Self-hosting remains a later option; do not assume CSV exports can be reimported as native history into a future self-hosted database without checking compatibility.

## Search visibility plan

| Priority | Work | Status |
| --- | --- | --- |
| 1 | Canonical page URLs, sitemap, crawler instructions, sharing metadata, and structured data | Implemented in source; requires review and deliberate publication |
| 2 | Verify `psychiatrypapers.org` in Google Search Console and submit `/sitemap.xml` | After publication; requires access to the owner's Google account and domain verification |
| 3 | Expand the editor profile with verified academic links and ORCID | Basic editor identity added; additional links still to verify |
| 4 | Prepare a reusable framework and choose explicit code/content licences | Separate follow-up; public repository visibility does not grant a reuse licence |

The shared `newsletter-seo.html` include adds canonical links, Open Graph and Twitter card metadata. Approved issue pages describe themselves as `BlogPosting`, with their original publication dates and Edward Bravo identified as **editor**. It does not invent an author, modification date, image, or drafting provenance. The homepage has `WebSite` structured data.

`sitemap.xml` lists content pages and eligible approved issues. Redirects, the error page, feeds, private drafts, and future issues stay out. New redirect or utility pages should declare `sitemap: false`; new content pages are included automatically. `robots.txt` points to the sitemap. Both use the origin and base path supplied by the validated build, so local configuration does not need a production hostname.

After deliberate publication, check the live sitemap, crawler instructions, canonical URLs, and article metadata. Then submit the sitemap in Search Console, inspect the homepage and a recent issue, and monitor indexing, impressions, and clicks. These source changes do not verify Search Console ownership, submit anything to Google, establish indexing, or guarantee a ranking change.

References: [Google's sitemap guidance](https://developers.google.com/search/docs/crawling-indexing/sitemaps/overview), [article structured data](https://developers.google.com/search/docs/appearance/structured-data/article), and [page descriptions](https://developers.google.com/search/docs/appearance/snippet).

## Validation without publication

Pull requests and pushes to `main` run **Validate editorial workflow**. It checks metadata and tracked private files, tests the editorial and reader-navigation scenarios below, and builds the site. It has read-only repository permissions and does not upload a Pages artifact or deploy.

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
5. Latest-issue shortcuts advance with publication, named previous/next links stay within their series, and future/private issues stay out of reader navigation.
6. Empty and first-issue series work at the custom-domain root without inventing previous editions.
7. Analytics stays disabled without account configuration and in non-production-origin builds; a configured production build labels each series, includes one tracker per content page and excludes redirect pages.
8. Search metadata and sitemap URLs match at the custom-domain root and a project subpath; redirects, error pages, drafts, and future issues stay out of the sitemap, and structured data safely handles quoted text and HTML-like titles.

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
