---
layout: feature
title: "Research"
permalink: /research/
author_profile: false
---

{% include base_path %}
{% assign research = site.data.wcsng_research %}
{% assign publication_count = site.publications | size %}

<div class="feature-page">
  <section class="feature-section feature-section--intro">
    <div class="feature-section__header feature-section__header--compact">
      <p class="feature-eyebrow">Overview</p>
      <h1>Focus Areas</h1>
      <p>{{ research.intro.lede }}</p>
      <div class="feature-link-row">
        <a class="feature-text-link" href="{{ base_path }}/publications/">{{ publication_count }} publications</a>
        <a class="feature-text-link" href="{{ base_path }}/software/">datasets and tools</a>
        <a class="feature-text-link" href="https://wcsng.ucsd.edu/">WCSNG group page</a>
      </div>
    </div>
  </section>

  <section class="feature-section">
    <div class="feature-card-grid">
      {% for area in research.areas %}
        <a class="feature-card" href="{{ base_path }}{{ area.url }}">
          {% if area.image %}
            <div class="feature-card__media">
              <img src="{{ base_path }}{{ area.image }}" alt="{{ area.image_alt | default: area.title }}">
            </div>
          {% endif %}
          <div class="feature-card__body">
            <h3>{{ area.title }}</h3>
            <p>{{ area.summary }}</p>
          </div>
        </a>
      {% endfor %}
    </div>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Details</p>
      <h2>Area-by-area view</h2>
    </div>

    <div class="research-area-list">
      {% for area in research.areas %}
        <article id="{{ area.slug }}" class="research-area">
          <div class="research-area__header">
            <div>
              <p class="feature-eyebrow">Current focus</p>
              <h3>{{ area.title }}</h3>
            </div>
            <a class="feature-text-link" href="{{ area.external_url }}">Group page</a>
          </div>

          <p class="research-area__summary">{{ area.summary }}</p>

          <div class="research-area__grid">
            <div>
              <h4>Current thrusts</h4>
              <ul class="feature-list">
                {% for item in area.themes %}
                  <li>{{ item }}</li>
                {% endfor %}
              </ul>
            </div>

            <div>
              {% if area.image %}
                <div class="research-area__visual">
                  <img src="{{ base_path }}{{ area.image }}" alt="{{ area.image_alt | default: area.title }}">
                </div>
              {% endif %}

              <h4>Representative resources</h4>
              <div class="feature-link-row">
                {% for link in area.links %}
                  {% if link.url contains "://" %}
                    <a class="feature-text-link" href="{{ link.url }}">{{ link.title }}</a>
                  {% else %}
                    <a class="feature-text-link" href="{{ base_path }}{{ link.url }}">{{ link.title }}</a>
                  {% endif %}
                {% endfor %}
              </div>
            </div>
          </div>
        </article>
      {% endfor %}
    </div>
  </section>
</div>
