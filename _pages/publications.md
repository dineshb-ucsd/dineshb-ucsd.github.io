---
layout: feature
title: "Publications"
permalink: /publications/
author_profile: false
---

{% include base_path %}
{% assign publications_sorted = site.publications | sort: "date" | reverse %}
{% assign publication_catalog = site.data.wcsng_catalog.publications %}
{% assign publication_tags = site.data.wcsng_catalog.publication_tags %}

<div class="feature-page">
  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Browse</p>
      <h2>Filter by topical tag</h2>
      <p>
        These tags come from the WCSNG publication taxonomy and make the archive easier to scan by theme instead of
        only by year.
      </p>
    </div>

    <div class="catalog-surface" data-catalog>
      <div class="catalog-controls">
        <div class="catalog-filter-group">
          <p class="catalog-filter-group__label">Topic</p>
          <div class="catalog-filter-group__buttons">
            <button type="button" class="catalog-filter-button is-active" data-filter-group="tag" data-filter-value="all">All topics</button>
            {% for tag in publication_tags %}
              <button type="button" class="catalog-filter-button" data-filter-group="tag" data-filter-value="{{ tag.slug }}">{{ tag.label }}<span>{{ tag.count }}</span></button>
            {% endfor %}
          </div>
        </div>
        <p class="catalog-status" data-catalog-count></p>
      </div>

      <div class="catalog-year-stack">
        {% assign current_year = "" %}
        {% for post in publications_sorted %}
          {% assign basename = post.path | split: '/' | last | remove: '.md' %}
          {% assign meta = publication_catalog[basename] %}
          {% assign post_year = post.date | date: "%Y" %}
          {% assign tag_slugs = "" %}
          {% if meta and meta.tags %}
            {% assign tag_slugs = meta.tags | map: "slug" | join: " " %}
          {% endif %}
          {% assign paper_href = post.paperurl %}
          {% assign github_href = post.github %}
          {% assign dataset_href = nil %}
          {% assign slides_href = nil %}
          {% assign venue_href = post.link %}
          {% assign cover_href = nil %}
          {% assign short_title = nil %}
          {% assign acceptance_rate = nil %}
          {% assign acceptance_note = nil %}
          {% assign venue_label = post.venue %}
          {% if meta %}
            {% assign paper_href = meta.paper | default: paper_href %}
            {% assign github_href = meta.github | default: github_href %}
            {% assign dataset_href = meta.dataset %}
            {% assign slides_href = meta.slides %}
            {% assign venue_href = meta.conference_site | default: venue_href %}
            {% assign cover_href = meta.cover %}
            {% assign short_title = meta.short_title %}
            {% assign acceptance_rate = meta.acceptance_rate %}
            {% assign acceptance_note = meta.acceptance_note %}
            {% assign venue_label = meta.conference | default: venue_label %}
          {% endif %}
          {% capture resolved_paper_href %}{% include resolve-site-or-wcsng-href.html href=paper_href %}{% endcapture %}
          {% capture resolved_github_href %}{% include resolve-site-or-wcsng-href.html href=github_href %}{% endcapture %}
          {% capture resolved_dataset_href %}{% include resolve-site-or-wcsng-href.html href=dataset_href %}{% endcapture %}
          {% capture resolved_slides_href %}{% include resolve-site-or-wcsng-href.html href=slides_href %}{% endcapture %}
          {% capture resolved_venue_href %}{% include resolve-site-or-wcsng-href.html href=venue_href %}{% endcapture %}
          {% assign resolved_paper_href = resolved_paper_href | strip %}
          {% assign resolved_github_href = resolved_github_href | strip %}
          {% assign resolved_dataset_href = resolved_dataset_href | strip %}
          {% assign resolved_slides_href = resolved_slides_href | strip %}
          {% assign resolved_venue_href = resolved_venue_href | strip %}

          {% if post_year != current_year %}
            {% unless forloop.first %}</div></section>{% endunless %}
            <section class="catalog-year-group" data-catalog-section>
              <div class="catalog-year-group__header">
                <p class="feature-eyebrow">{{ post_year }}</p>
                <h2>{{ post_year }}</h2>
              </div>
              <div class="catalog-list catalog-list--publication">
            {% assign current_year = post_year %}
          {% endif %}

          <article class="catalog-card catalog-card--publication" data-catalog-item data-catalog-tag="{{ tag_slugs }}">
            <div class="catalog-card__media">
              {% if cover_href %}
                <img src="{{ base_path }}{{ cover_href }}" alt="{% if short_title %}{{ short_title }}{% else %}{{ post.title }}{% endif %} cover image">
              {% else %}
                <div class="catalog-card__placeholder">
                  <span>{{ post_year }}</span>
                </div>
              {% endif %}
            </div>

            <div class="catalog-card__body">
              <div class="catalog-card__meta-line">
                <p class="catalog-card__meta">
                  <span>{{ post_year }}</span>
                  {% if venue_label %}<span>{{ venue_label }}</span>{% endif %}
                  {% if acceptance_rate %}<span>Acceptance rate: {{ acceptance_rate }}</span>{% endif %}
                  {% if acceptance_note and acceptance_rate == nil %}<span>{{ acceptance_note }}</span>{% endif %}
                </p>
              </div>

              <h3><a href="{{ base_path }}{{ post.url }}">{{ post.title }}</a></h3>

              {% if post.citation %}
                <p class="catalog-card__copy">{{ post.citation | strip | truncate: 260 }}</p>
              {% endif %}

              {% if meta and meta.tags and meta.tags.size > 0 %}
                <div class="catalog-tag-list">
                  {% for tag in meta.tags %}
                    <span class="catalog-tag">{{ tag.label }}</span>
                  {% endfor %}
                </div>
              {% endif %}

              <div class="catalog-card__links">
                {% if resolved_paper_href != "" %}
                  <a class="catalog-link" href="{{ resolved_paper_href }}">Paper</a>
                {% endif %}
                {% if resolved_github_href != "" %}
                  <a class="catalog-link" href="{{ resolved_github_href }}">Code</a>
                {% endif %}
                {% if resolved_dataset_href != "" %}
                  <a class="catalog-link" href="{{ resolved_dataset_href }}">Dataset</a>
                {% endif %}
                {% if resolved_slides_href != "" %}
                  <a class="catalog-link" href="{{ resolved_slides_href }}">Slides</a>
                {% endif %}
                {% if resolved_venue_href != "" %}
                  <a class="catalog-link" href="{{ resolved_venue_href }}">Venue</a>
                {% endif %}
              </div>
            </div>
          </article>

          {% if forloop.last %}</div></section>{% endif %}
        {% endfor %}
      </div>
    </div>
  </section>
</div>

{% include catalog-filters-script.html %}
