---
layout: newsletter-site
title: About and editorial policy
description: "A Jekyll-based experiment in newsletter automation and AI-assisted scholarly output, with human editorial responsibility."
permalink: /about/
---

<article class="issue-body about-page" markdown="1">

# About this newsletter experiment

**Psychiatry Papers & Perspectives** is a Jekyll-based publishing experiment testing the capacity of large language models (LLMs) to help create a newsletter, build its website, and support a repeatable publication workflow. It explores the whole process: finding and discussing research, preparing a manuscript, organizing an accessible archive, and moving an approved version into publication.

The intention is to understand how much of this work LLMs can perform usefully, where they need correction or supervision, and how their contributions can be made transparent. Newsletter writing and site building provide a practical setting in which to examine those questions together. The resulting scholarly output is also a way to assess the process: its usefulness depends on the quality of the evidence, interpretation, presentation, and editorial decisions behind it.

## What the project is trying to achieve

The project has three connected aims:

- **Test LLM-assisted creation and automation.** Explore how reliably an LLM can help research and draft recurring issues, create and maintain the website, and carry out routine publishing tasks. Recording the model and its role makes that contribution visible as tools and methods change.
- **Make psychiatric research easier to access.** Bring influential papers, clear explanations, critical appraisal, and links to original sources into a website where readers can easily find the current issue and earlier editions. The two newsletters adapt the discussion to different audiences while retaining methodological substance and uncertainty.
- **Develop a reliable publication pipeline with editorial control.** Reduce repeated copying, formatting, and technical troubleshooting through a consistent sequence of drafting, review, approval, building, publication, and live verification. Decisions about what to publish, how to interpret the evidence, and when a version is ready remain with the editor.

Success would mean that the process can be repeated across issues without losing sources, provenance, approved wording, or control over publication. A reliable pipeline should make the status of an issue clear, carry the reviewed version into the correct archive, and support traceable corrections. Producing text quickly or building a working page is only part of that goal.

This is an exploratory publishing project, not a completed demonstration that LLMs can independently produce trustworthy scholarship. The aim is to learn from the work required to make each issue accurate, useful, accessible, and ready for publication, including the errors and limitations encountered along the way.

Jekyll provides the website-building step: it turns reviewed Markdown files into pages and archives. It does not select evidence, validate references, or make clinical judgments. Automated checks and human editorial review have distinct roles within the same process.

## Two newsletters, two audiences

**[Landmark Psychiatry Papers]({{ '/landmark-psychiatry-papers/' | relative_url }})** examines influential research for clinicians and curious readers, with attention to methodology, limitations, and historical significance.

**[Psychosis Psychoeducation]({{ '/psychosis-psychoeducation/' | relative_url }})** translates research into accessible discussion for families, caregivers, and clinicians supporting people experiencing psychosis.

The two series have separate archives and selection records. A paper can be relevant to both audiences; known overlap should be disclosed rather than mistaken for a new selection within the same series.

## How AI is used and recorded

AI tools assist with literature searches, paper selection, summaries, comparisons, and initial drafting. They may also help with formatting and the publishing workflow. Their output can contain inaccurate references, numerical errors, omissions, or interpretations that the original research does not support. Linked sources let readers examine the underlying evidence.

For new issues, the source metadata records the AI provider, exact model identifier, interface, generation date, and role of AI when those details can be verified. The issue footer displays the recorded model and generation date. Models may change between issues, so there is no single model version attributed to the entire archive. Older editions without recorded model details are identified as such; those details are not reconstructed by guesswork.

Generation and publication dates have different meanings. Recording how a draft was made does not establish that its claims are correct or that editorial review is complete.

## Review, approval, and publication

The editorial process is intended to check citations against original sources, distinguish findings from interpretation, consider corrections and retractions, and identify access limitations. Historical findings should be separated from contemporary clinical recommendations. These checks reduce the risk of error but cannot eliminate it.

Drafts and private editorial records stay outside the public source repository. A specific version must receive editorial approval before entering the publication process. Automated checks test metadata consistency and whether the website builds; they do not replace scientific appraisal or certify that a person has reviewed the text.

Publication currently requires a separate, deliberate manual action. Generating a draft or changing the repository does not automatically publish a newsletter. An issue is recorded as published only after its live version has been checked.

## My editorial responsibility

As editor and publisher, **I assume editorial responsibility for each published issue**, including the final wording, source verification, interpretations, and corrections. AI assistance does not transfer that responsibility to the model or its provider. Neither the use of AI nor this project's experimental nature excuses errors in the published work.

Substantive corrections should be identified on the affected issue, with the correction date and a clear account of what changed. The corrected version should undergo review before republication, and the issue's address should remain stable where possible. Readers can report a suspected error through the [project's GitHub issue tracker](https://github.com/ejulianbravo/psychiatry-newsletters/issues). Please do not include personal health information in a public report.

## Educational scope

These newsletters provide education and critical discussion. They are not individualized clinical advice, comprehensive evidence reviews, or substitutes for current clinical guidance and professional judgment. A historical study may be important without establishing the best treatment for a particular person today.

The short disclosure on each website issue keeps AI use, available provenance, educational limits, and editorial responsibility close to the text. This page supplies the fuller explanation of the project and its process.

</article>
