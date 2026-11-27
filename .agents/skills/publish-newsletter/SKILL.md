---
name: publish-newsletter
description: Prepare approved newsletter versions, validate Jekyll publication, verify a deliberate deployment, and record corrections in this repository. Does not grant approval or authorize deployment.
---

# Deliberate newsletter publication

Read AGENTS.md, README.md, the target manuscript, its series ledger, and `.github/workflows/publish.yml`. Distinguish preparation, uploading public source, deployment, and verification. Existing user authorization governs each action; do not request it again when already granted, and do not infer approval from passing checks.

For publication preparation, establish explicit editorial approval of the exact version using the private review record and manuscript SHA-256. If approval is missing, finish the private review package and request editorial review. Before placing any manuscript in the public repository, confirm the exact version is approved and that the user requested publication preparation/upload. Record approval evidence privately without inventing a timestamp or approver.

Move the approved manuscript into `_posts/` using the confirmed publication date, newsletter identifier, and existing permalink policy. Set editorial_status: approved, approved: true, published: false. Record the reviewed body hash and final file hash if frontmatter changed; do not silently revise reviewed claims. Confirm provenance and rendered disclosure. For corrections preserve the existing path, date, and permalink; privately review substantive changes before replacing public source.

Use the existing commands from README.md:

```sh
bundle exec ruby scripts/validate_editorial.rb
bundle exec ruby test/editorial_workflow_test.rb
PAGES_ORIGIN=https://ejulianbravo.github.io PAGES_BASE_PATH=/psychiatry-newsletters bundle exec ruby scripts/build_pages.rb
```

Review the staged diff and tracked-file list before uploading; `_drafts/` and `editorial/` must remain ignored and untracked. Preserve unrelated changes. Open a focused PR when requested, reporting the checks and exact version. A merge validates source but does not publish. If remote state is ahead, reconcile it while preserving local changes; never overwrite newer published work with an older review draft.

Deployment requires the user's deliberate publishing instruction. Use the existing manual **Publish approved newsletters** workflow on main with PUBLISH, or provide that exact action for the editor to perform. Do not enable deployment on push or schedule deployment. On failure retain approved state and report the failure; do not claim success or retry indefinitely.

After deployment succeeds, inspect the live issue, homepage, correct series archive, feed, links, and disclosure at the production base path. Only then update the source to editorial_status: published and published: true and record canonical issue path, live URL, publication date, verification date, and deployed version in the private series ledger. Keep original generation dates. A metadata commit does not require redeployment under the current workflow. Report the verified URL and any remaining limits.
