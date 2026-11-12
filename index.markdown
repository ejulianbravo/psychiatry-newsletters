---
layout: newsletter-site
---
<header class="intro">
  <p class="eyebrow">Two newsletters. Two perspectives.</p>
  <h1>Understanding psychiatry.<br>Connecting research and care.</h1>
  <p class="lead">Explore influential papers in psychiatry and accessible perspectives on psychosis, with a dedicated newsletter for each.</p>
</header>
{% for series in site.data.newsletters %}
{% assign issues = site.posts | where: 'newsletter', series.slug | where: 'approved', true | sort: 'date' | reverse %}
<section class="series {{ series.slug }}" aria-labelledby="{{ series.slug }}-heading">
  <div class="series-description">
    <p class="eyebrow">{{ series.audience }}</p>
    <h2 id="{{ series.slug }}-heading"><a href="{{ series.url | relative_url }}">{{ series.title }}</a></h2>
    <p>{{ series.description }}</p>
    <a class="archive-link" href="{{ series.url | relative_url }}">Browse the issue archive <span aria-hidden="true">→</span></a>
  </div>
  <div class="latest">
    <p class="eyebrow">Latest issue</p>
    {% if issues.size > 0 %}
    {% assign issue = issues.first %}
    <p class="date"><time datetime="{{ issue.date | date_to_xmlschema }}">{{ issue.date | date: '%B %-d, %Y' }}</time></p>
    <h3><a href="{{ issue.url | relative_url }}">{{ issue.title | escape }}</a></h3>
    <p>{{ issue.description | default: issue.excerpt | strip_html | truncatewords: 35 }}</p>
    <a class="button" href="{{ issue.url | relative_url }}">Read the latest issue <span aria-hidden="true">→</span></a>
    {% else %}
    <h3>The first issue is forthcoming.</h3>
    <p>Once published, the newest edition will appear here. Previous editions will be available in the archive.</p>
    {% endif %}
  </div>
</section>
{% endfor %}
