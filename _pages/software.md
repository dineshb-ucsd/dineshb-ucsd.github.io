---
layout: feature
title: "Open Source & Data"
permalink: /software/
author_profile: false
---

{% include base_path %}
{% assign resources = site.data.wcsng_resources %}
{% assign software_count = resources.software | size %}
{% assign dataset_count = resources.datasets | size %}

<div class="feature-page">
  <section class="feature-hero feature-hero--soft">
    <div class="feature-hero__copy">
      <p class="feature-eyebrow">Open Source</p>
      <h1>Software, datasets, and artifacts that support the research agenda.</h1>
      <p class="feature-lede">
        This page pulls together the most useful public releases from the WCSNG ecosystem so the personal site
        points to concrete systems, not just paper titles. The emphasis is on usable code, reproducible artifacts,
        and datasets that capture the core technical ideas.
      </p>
      <div class="feature-link-row">
        <a class="feature-button feature-button--primary" href="{{ resources.links.github_org }}">GitHub organization</a>
        <a class="feature-button feature-button--secondary" href="{{ resources.links.group_page }}">Group code page</a>
      </div>
    </div>

    <aside class="feature-hero__panel">
      <p class="feature-eyebrow">Inventory</p>
      <h2>Public releases across sensing, xG, IoT, autonomy, and RF systems</h2>
      <div class="feature-mini-stats">
        <div>
          <strong>{{ software_count }}</strong>
          <span>software systems</span>
        </div>
        <div>
          <strong>{{ dataset_count }}</strong>
          <span>datasets and artifacts</span>
        </div>
      </div>
    </aside>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Software</p>
      <h2>Open systems and toolchains</h2>
      <p>
        These repositories expose working systems, controllers, sensing pipelines, and evaluation frameworks that
        make the research reproducible and reusable.
      </p>
    </div>

    <div class="resource-grid">
      {% for item in resources.software %}
        <article id="{{ item.slug }}" class="resource-card">
          <p class="resource-card__meta">{{ item.year }} | {{ item.area }}</p>
          <h3>{{ item.title }}</h3>
          <p>{{ item.summary }}</p>
          <div class="feature-link-row">
            {% if item.github %}
              <a class="feature-text-link" href="{{ item.github }}" aria-label="Open the GitHub repository for {{ item.title }}">GitHub</a>
            {% endif %}
            {% if item.paper %}
              <a class="feature-text-link" href="{{ item.paper }}" aria-label="Read the paper for {{ item.title }}">Paper</a>
            {% endif %}
          </div>
        </article>
      {% endfor %}
    </div>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Data</p>
      <h2>Datasets and research artifacts</h2>
      <p>
        These releases make it easier to benchmark localization, mmWave reliability, autonomous radar perception,
        and sustainable wireless architectures without rebuilding every pipeline from scratch.
      </p>
    </div>

    <div class="resource-grid">
      {% for item in resources.datasets %}
        <article id="{{ item.slug }}" class="resource-card">
          <p class="resource-card__meta">{{ item.year }} | {{ item.area }}</p>
          <h3>{{ item.title }}</h3>
          <p>{{ item.summary }}</p>
          <div class="feature-link-row">
            {% if item.dataset %}
              <a class="feature-text-link" href="{{ item.dataset }}" aria-label="Open the dataset for {{ item.title }}">Dataset</a>
            {% endif %}
            {% if item.github %}
              <a class="feature-text-link" href="{{ item.github }}" aria-label="Open the code for {{ item.title }}">Code</a>
            {% endif %}
            {% if item.paper %}
              <a class="feature-text-link" href="{{ item.paper }}" aria-label="Read the paper for {{ item.title }}">Paper</a>
            {% endif %}
          </div>
        </article>
      {% endfor %}
    </div>
  </section>
</div>
