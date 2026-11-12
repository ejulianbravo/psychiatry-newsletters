# The code looks for all posts with the category psychosis, displays the newest one, and creates a list of earlier issues automatically.
---
layout: default
title: Psychosis & Families
permalink: /psychosis/
---

# Psychosis & Families

Evidence for families, caregivers, and clinicians.

{% assign issues = site.posts | where: "category", "psychosis" %}

## Current issue

{% for post in issues limit:1 %}
### [{{ post.title }}]({{ post.url | relative_url }})

Published {{ post.date | date: "%B %d, %Y" }}

{{ post.excerpt }}

[Read the full issue]({{ post.url | relative_url }})
{% endfor %}

## Previous issues

{% for post in issues offset:1 %}
- [{{ post.title }}]({{ post.url | relative_url }})
  ({{ post.date | date: "%B %d, %Y" }})
{% endfor %}
