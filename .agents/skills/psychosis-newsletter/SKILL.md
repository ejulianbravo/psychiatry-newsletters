---
name: psychosis-newsletter
description: Draft or revise this project's Psychosis Psychoeducation issues for families, caregivers, and clinicians, maintaining its own private paper history.
---

# Psychosis Psychoeducation in this project

Use the installed `psychosis-psychoeducation-newsletter` skill when available, including its ledger and publication references as applicable. Apply these repository paths and editorial states. If it is unavailable, use the procedure below without claiming to have loaded it.

Read AGENTS.md, README.md, prior genuine Psychosis issues, and `editorial/psychosis-psychoeducation/`. Keep its ledger separate from Landmark. If no project ledger exists, recover featured papers from the actual posts into a new private paper-ledger.json, with issue paths and provenance; flag incomplete older history. Do not infer an unused paper solely from an absent ledger entry.

Read `editorial/appraisal-standards.md` and `editorial/full-text-access-policy.md` before drafting. These project requirements also apply when using the installed supporting skill. Put a verified **Read the original paper** link immediately below each featured-paper heading, include a plain-language, study-specific **What this study does not establish** passage, and add separately cited contemporary context. Keep the three featured papers and landmark focus; contextual sources do not impose a recent-paper quota or become extra featured selections.

Prepare three distinct landmark psychosis papers, normally 1,200–1,800 words overall, with accessible, respectful language and enough methodological detail for clinicians. Read each original article in full and verify bibliography, results, denominators, uncertainty, limitations, corrections, and retractions. Record access limits and claim locations privately. Missing full text leaves the slot incomplete; request the exact article or supplement through the editor rather than completing it from an abstract or quietly replacing an editor-selected paper. Separate historical evidence from current guidance and verify current-practice claims separately.

For each paper explain its contribution, design, findings, limitations, and concrete caregiver implications or questions for the treating team. Avoid family blame, deterministic prognosis, treatment promises, and individualized medication advice. Include a brief opening, synthesis, and linked references.

Save under `_drafts/` with layout `newsletter-issue`, newsletter `psychosis-psychoeducation`, approved: false, and published: false, using YAML booleans. Use editorial_status `draft-for-review` only for a complete manuscript with all three featured papers verified in full text; otherwise use `draft` and identify the missing evidence. Preserve accurate generation provenance as described in README.md. Do not invent numbering, bylines, or model identity. The shared footer handles the website disclosure; standalone copies need the disclosure too.

Reserve the papers in the private series ledger after saving the draft. Record path, SHA-256, verification limits, and review questions in private editorial notes. Apply the appraisal-standards manuscript check and hand off for editorial review with paths and unresolved points. For an approved manuscript use `.agents/skills/publish-newsletter/SKILL.md`.
