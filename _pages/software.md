---
layout: feature
title: "Open Source, Data & Artifacts"
permalink: /software/
author_profile: false
---

{% include base_path %}
{% assign resources = site.data.wcsng_resources %}
{% assign research_areas = site.data.wcsng_research.areas %}
{% assign software_count = resources.software | size %}
{% assign dataset_count = resources.datasets | size %}

<div class="feature-page">
  <section class="feature-hero feature-hero--soft">
    <div class="feature-hero__copy">
      <p class="feature-eyebrow">Open Source</p>
      <h1>Software, datasets, and artifacts from the WCSNG ecosystem.</h1>
      <p class="feature-lede">
        WCSNG has curated and created open-source datasets and tools that enable reproducible research and lower
        the barrier to entry for researchers in communication, computing, sensing, and autonomous systems.
      </p>
      <p class="feature-lede">
        This page pulls together the public releases that are most useful to students, collaborators, and
        researchers who want working systems, representative datasets, and concrete starting points rather than
        paper titles alone.
      </p>
      <div class="feature-link-row">
        <a class="feature-button feature-button--primary" href="{{ resources.links.github_org }}">GitHub organization</a>
        <a class="feature-button feature-button--secondary" href="{{ resources.links.group_page }}">Group code page</a>
      </div>
    </div>

    <aside class="feature-hero__panel">
      <p class="feature-eyebrow">Inventory</p>
      <h2>Public releases organized by the same research areas used across the site</h2>
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
      <div class="feature-link-row feature-link-row--compact">
        {% for area in research_areas %}
          <a class="feature-chip" href="#{{ area.slug }}">{{ area.title }}</a>
        {% endfor %}
      </div>
    </aside>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Software</p>
      <h2>Open systems and toolchains</h2>
      <p>
        These repositories expose working systems, sensing pipelines, simulation environments, and evaluation
        toolchains that make the research reproducible and reusable.
      </p>
    </div>
    <div class="resource-area-stack">
      {% for area in research_areas %}
        {% assign area_software = resources.software | where: "area", area.title %}
        {% if area_software.size > 0 %}
          <section id="{{ area.slug }}" class="resource-area-block">
            <div class="resource-area-block__header">
              <p class="resource-card__meta">Software | {{ area.title }}</p>
              <h3>{{ area.title }}</h3>
              <p class="resource-area-block__summary">{{ area.summary }}</p>
            </div>
            <div class="resource-grid">
              {% for item in area_software %}
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
        {% endif %}
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
    <div class="resource-area-stack">
      {% for area in research_areas %}
        {% assign area_datasets = resources.datasets | where: "area", area.title %}
        {% if area_datasets.size > 0 %}
          <section id="{{ area.slug }}-data" class="resource-area-block">
            <div class="resource-area-block__header">
              <p class="resource-card__meta">Data | {{ area.title }}</p>
              <h3>{{ area.title }}</h3>
              <p class="resource-area-block__summary">{{ area.summary }}</p>
            </div>
            <div class="resource-grid">
              {% for item in area_datasets %}
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
        {% endif %}
      {% endfor %}
    </div>
  </section>
</div>
