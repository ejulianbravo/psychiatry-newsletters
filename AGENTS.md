# Psychiatry newsletters

This checkout is the authoritative project for `ejulianbravo/psychiatry-newsletters`. Preserve unrelated local changes. Read README.md for editorial states and build commands.

## Editorial work

- For Landmark drafting or revision, read `.agents/skills/landmark-newsletter/SKILL.md`.
- For Psychosis Psychoeducation drafting or revision, read `.agents/skills/psychosis-newsletter/SKILL.md`.
- For approval preparation, publication, corrections, or live verification, read `.agents/skills/publish-newsletter/SKILL.md`.
- Keep the series and their paper ledgers separate. Authoritative private records belong in `editorial/<series>/`; drafts belong in `_drafts/`. Do not force-add either directory or upload private review exports. Temporary folders and generated `_site/` are not editorial history.
- Verify primary sources and record access limits. Never invent citations, results, quotations, historical completeness, approval, or generation metadata. Distinguish historical evidence from current clinical guidance.
- Record actual model provenance when available; otherwise explicitly record that it is unavailable. Do not copy a previous issue's model or date as a default.
- Editorial approval applies to an exact manuscript version. Record its path and SHA-256 privately. Substantive revisions require renewed review. Drafting, topic approval, and successful validation do not authorize uploading a manuscript or deploying it.
- Keep publication deliberate through the existing manual workflow. Never change workflows to deploy on push. Do not mark published until the live issue, homepage, and series archive have been checked.

## Website work

Use the existing Ruby/rbenv and Jekyll setup. Keep shared disclosure in `_includes/newsletter-footer.html` and broader project explanation on `/about/`. Preserve recorded generation provenance independently of publication dates.

For relevant website or publishing changes, run the README validation commands. Generated output must exclude drafts, editorial records, AGENTS.md, and project skills. Report remaining verification limits and never claim a local build is a live deployment.
