---
layout: newsletter-site
title: About and editorial policy
description: "Psychiatric knowledge translation, publishing automation, and practical work with LLM agents, built on GitHub Pages and Jekyll."
permalink: /about/
---

<article class="issue-body about-page" markdown="1">

# About Psychiatry Papers & Perspectives

**Psychiatry Papers & Perspectives** brings together psychiatric knowledge translation, publishing automation, and practical work with large language model (LLM) agents. The project develops a repeatable route from original research to reviewed newsletters and a public website, built on **GitHub Pages and Jekyll**.

Building the publishing system is a substantial part of the project's purpose. I am interested in how LLM agents can help sustain a publication over time: finding evidence, preparing drafts, writing and maintaining software, checking changes, and carrying a reviewed version through to publication. The newsletters put that work into practice, translating psychiatric research for different audiences.

## An experiment in publishing and automation

The technical work is an ongoing experiment in combining LLM agents, reusable instructions, and software tools into a working publication pipeline. It is also a way to develop practical skills in coding, version control, automated testing, web design, and troubleshooting. Each issue gives me a reason to improve the system and see where it still needs attention.

LLM agents contribute to both the scholarly and technical work. They help research and draft issues, build page layouts and navigation, write validation code, investigate failures, and document repeatable procedures. Project instructions and task-specific skills give those agents a consistent starting point. Separate paper histories help avoid repetition within each newsletter, and review records connect editorial decisions to particular manuscript versions.

The aim is to reduce repetitive work while keeping sources, revisions, and publication decisions traceable. Reliability develops through repeated use, inspection, and correction; the workflow continues to evolve as the tools and my understanding of them change.

## How the publication pipeline works

Manuscripts are written in Markdown, and Jekyll turns them into a static website with shared layouts, issue pages, and separate newsletter archives. GitHub keeps the website source under version control, GitHub Actions runs validation and the publishing workflow, and GitHub Pages hosts the resulting website.

The pipeline connects four stages:

1. **Research and drafting.** Recurring agent tasks use the project's editorial instructions and each newsletter's paper history to prepare work for review. Original sources, access limits, and drafting details are recorded alongside the manuscript.
2. **Editorial review.** Drafts stay private while sources and interpretations are checked and the text is revised. Approval belongs to a specific manuscript version. AI model and generation records are kept separately from publication dates.
3. **Automated validation.** Ruby checks and local build tests examine editorial metadata, private-file exclusions, newsletter archives, navigation, and other publishing behaviour. GitHub Actions also runs validation on proposed source changes.
4. **Publication and verification.** A separate manual workflow builds the reviewed content and publishes it through GitHub Pages. The live website is then checked before an issue is recorded as published.

This structure lets routine preparation and checking be automated while keeping the decision to publish deliberate. It also supports corrections, stable issue addresses, and permanent links to each newsletter's latest edition. The website source and publishing workflows are available in the [project's GitHub repository](https://github.com/ejulianbravo/psychiatry-newsletters). Drafts and private editorial records remain outside it.

## Founding editor {#editor}

**Edward Bravo, MD**, is a psychiatrist practising in Ontario, Canada, and the founding editor and publisher of Psychiatry Papers & Perspectives.

As editor, I select the material, review the sources and final text, decide when an issue is ready to publish, and handle corrections and reader feedback. This is an independent personal project; its content does not represent the official positions of my employers or affiliated institutions.

## Two newsletters, two audiences

The two newsletters form an independent educational publication for clinicians, people with lived experience, families, caregivers, and curious readers. Both aim to make research easier to understand and to help readers engage with the original evidence.

**[Landmark Psychiatry Papers]({{ '/landmark-psychiatry-papers/' | relative_url }})** examines influential research for clinicians and curious readers, with attention to methodology, limitations, and historical significance. It considers how findings have shaped psychiatric thinking and how they should be understood alongside later evidence.

**[Psychosis Psychoeducation]({{ '/psychosis-psychoeducation/' | relative_url }})** translates research into accessible discussion for people experiencing psychosis, their families and caregivers, and the clinicians supporting them. It connects findings with practical questions for understanding care and recovery.

The two series have separate archives and selection records. A paper can be relevant to both audiences; known overlap should be disclosed rather than mistaken for a new selection within the same series.

## How papers are selected and discussed

Selection considers a study's scientific or clinical influence, methodological contribution, and relevance to the newsletter's audience. Historical importance remains central to the Landmark series; recent research can help readers understand how the evidence has developed. Each issue presents a selection of papers, rather than a comprehensive or systematic review.

Full-text verification is required for new appraisals: reading the complete original articles, verifying references and important numerical claims, examining methods and limitations, and checking for corrections or retractions. Missing full text or essential supporting material leaves an appraisal incomplete.

References link to original publications through publisher, DOI, or PubMed records. Some full texts require a subscription or institutional access. Linking a paper does not mean that its full text is freely available.

Appraisals should distinguish study findings, editorial interpretation, and current clinical guidance, and explain what a study does and does not establish. This is especially important when discussing treatment alternatives: a finding about a selected group does not by itself establish that a treatment should be stopped or replaced. Historical influence and clinical relevance are considered separately.

## Recording AI use

AI-generated text can contain inaccurate references, numerical errors, omissions, or interpretations that the original research does not support. Reviewing it against the original sources is part of the editorial work.

New issues record the exact drafting model and the source used to verify it, together with the provider, interface, generation date, and role when verified. The issue footer displays the original drafting provenance and any recorded AI-assisted revisions. Older editions disclose the level of model detail available in their records; missing details are not inferred from later issues.

These records help readers understand how an issue was prepared. Source verification, scientific appraisal, and the decision to publish require their own review; automated build checks address the operation of the publishing system.

## Corrections and feedback

Readers can report a suspected error or suggest an improvement through the [project's GitHub issue tracker](https://github.com/ejulianbravo/psychiatry-newsletters/issues). Please identify the issue and passage concerned and, where possible, link the supporting source. The tracker is public; do not include personal health information.

Substantive corrections should be identified on the affected issue, with the correction date and a clear account of what changed. The corrected version requires review before republication, and the issue's address should remain stable where possible. Source checks and editorial review reduce the risk of error but cannot eliminate it.

## Visitor analytics

We use Umami Cloud to understand visits to the newsletters, which issues are opened, and which sharing links bring readers here. The tracker records page and referrer information, browser/device information, approximate location, and estimated visitor counts without setting analytics cookies. QR identifiers describe distribution routes; they are not assigned to individual readers.

The current free hosting plan retains analytics for six months. We may preserve dated aggregate summaries for longer-term reporting on the newsletters' dissemination. Recorded visits and pageviews do not establish that each article was read. See [Umami's privacy policy](https://umami.is/privacy) for information about its processing.

## Educational scope

These newsletters provide education and critical discussion. They are not individualized clinical advice, comprehensive evidence reviews, or substitutes for current clinical guidance and professional judgment. A historical study may be important without establishing the best treatment for a particular person today.

Each issue includes a short account of AI assistance and the available drafting and revision details, with a link back to this page.

</article>
