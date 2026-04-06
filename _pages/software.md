---
layout: feature
title: "Open Source, Data & Artifacts"
permalink: /software/
author_profile: false
---

{% include base_path %}
{% assign resources = site.data.wcsng_resources %}
{% assign research_areas = site.data.wcsng_research.areas %}
{% assign resource_catalog = site.data.wcsng_catalog.resources %}
{% assign resource_tags = site.data.wcsng_catalog.resource_tags %}

<div class="feature-page">
  <section class="feature-section">
    <div class="feature-section__header">
      <h2>Browse by type and topic</h2>
    </div>

    <div class="catalog-surface" data-catalog>
      <div class="catalog-controls">
        <div class="catalog-filter-group">
          <p class="catalog-filter-group__label">Type</p>
          <div class="catalog-filter-group__buttons">
            <button type="button" class="catalog-filter-button is-active" data-filter-group="kind" data-filter-value="all">All releases</button>
            <button type="button" class="catalog-filter-button" data-filter-group="kind" data-filter-value="software">Software</button>
            <button type="button" class="catalog-filter-button" data-filter-group="kind" data-filter-value="dataset">Datasets</button>
          </div>
        </div>

        <div class="catalog-filter-group">
          <p class="catalog-filter-group__label">Topic</p>
          <div class="catalog-filter-group__buttons">
            <button type="button" class="catalog-filter-button is-active" data-filter-group="tag" data-filter-value="all">All topics</button>
            {% for tag in resource_tags %}
              <button type="button" class="catalog-filter-button" data-filter-group="tag" data-filter-value="{{ tag.slug }}">{{ tag.label }}<span>{{ tag.count }}</span></button>
            {% endfor %}
          </div>
        </div>

        <p class="catalog-status" data-catalog-count></p>
      </div>

      <div class="resource-area-stack">
        {% for area in research_areas %}
          {% assign area_software = resources.software | where: "area", area.title %}
          {% assign area_datasets = resources.datasets | where: "area", area.title %}
          {% assign area_total = area_software.size | plus: area_datasets.size %}
          {% if area_total > 0 %}
            <section id="{{ area.slug }}" class="resource-area-block" data-catalog-section>
              <div class="resource-area-block__header">
                <p class="resource-card__meta">{{ area.title }}</p>
                <h3>{{ area.title }}</h3>
                <p class="resource-area-block__summary">{{ area.summary }}</p>
              </div>

              <div class="catalog-list catalog-list--resource">
                {% for item in area_software %}
                  {% assign resource_meta = resource_catalog[item.slug] %}
                  {% assign item_tags = area.slug %}
                  {% if resource_meta and resource_meta.tags and resource_meta.tags.size > 0 %}
                    {% assign item_tags = resource_meta.tags | map: "slug" | join: " " %}
                  {% endif %}
                  {% capture resolved_item_github %}{% include resolve-site-or-wcsng-href.html href=item.github %}{% endcapture %}
                  {% capture resolved_item_paper %}{% include resolve-site-or-wcsng-href.html href=item.paper %}{% endcapture %}
                  {% assign resolved_item_github = resolved_item_github | strip %}
                  {% assign resolved_item_paper = resolved_item_paper | strip %}
                  <article id="{{ item.slug }}" class="catalog-card catalog-card--resource" data-catalog-item data-catalog-kind="software" data-catalog-tag="{{ item_tags }}">
                    <div class="catalog-card__media">
                      {% if resource_meta and resource_meta.cover %}
                        <img src="{{ base_path }}{{ resource_meta.cover }}" alt="{{ item.title }} project image">
                      {% else %}
                        <div class="catalog-card__placeholder"><span>Software</span></div>
                      {% endif %}
                    </div>

                    <div class="catalog-card__body">
                      <p class="catalog-card__meta">
                        <span>Software</span>
                        <span>{{ item.year }}</span>
                        <span>{{ item.area }}</span>
                        {% if resource_meta and resource_meta.conference %}<span>{{ resource_meta.conference }}</span>{% endif %}
                      </p>
                      <h3>{{ item.title }}</h3>
                      <p class="catalog-card__copy">{{ item.summary }}</p>

                      <div class="catalog-tag-list">
                        {% if resource_meta and resource_meta.tags and resource_meta.tags.size > 0 %}
                          {% for tag in resource_meta.tags %}
                            <span class="catalog-tag">{{ tag.label }}</span>
                          {% endfor %}
                        {% else %}
                          <span class="catalog-tag">{{ item.area }}</span>
                        {% endif %}
                      </div>

                      <div class="catalog-card__links">
                        {% if resolved_item_github != "" %}
                          <a class="catalog-link" href="{{ resolved_item_github }}">GitHub</a>
                        {% endif %}
                        {% if resolved_item_paper != "" %}
                          <a class="catalog-link" href="{{ resolved_item_paper }}">Paper</a>
                        {% endif %}
                      </div>
                    </div>
                  </article>
                {% endfor %}

                {% for item in area_datasets %}
                  {% assign resource_meta = resource_catalog[item.slug] %}
                  {% assign item_tags = area.slug %}
                  {% if resource_meta and resource_meta.tags and resource_meta.tags.size > 0 %}
                    {% assign item_tags = resource_meta.tags | map: "slug" | join: " " %}
                  {% endif %}
                  {% capture resolved_item_dataset %}{% include resolve-site-or-wcsng-href.html href=item.dataset %}{% endcapture %}
                  {% capture resolved_item_github %}{% include resolve-site-or-wcsng-href.html href=item.github %}{% endcapture %}
                  {% capture resolved_item_paper %}{% include resolve-site-or-wcsng-href.html href=item.paper %}{% endcapture %}
                  {% assign resolved_item_dataset = resolved_item_dataset | strip %}
                  {% assign resolved_item_github = resolved_item_github | strip %}
                  {% assign resolved_item_paper = resolved_item_paper | strip %}
                  <article id="{{ item.slug }}" class="catalog-card catalog-card--resource" data-catalog-item data-catalog-kind="dataset" data-catalog-tag="{{ item_tags }}">
                    <div class="catalog-card__media">
                      {% if resource_meta and resource_meta.cover %}
                        <img src="{{ base_path }}{{ resource_meta.cover }}" alt="{{ item.title }} dataset image">
                      {% else %}
                        <div class="catalog-card__placeholder"><span>Dataset</span></div>
                      {% endif %}
                    </div>

                    <div class="catalog-card__body">
                      <p class="catalog-card__meta">
                        <span>Dataset</span>
                        <span>{{ item.year }}</span>
                        <span>{{ item.area }}</span>
                        {% if resource_meta and resource_meta.conference %}<span>{{ resource_meta.conference }}</span>{% endif %}
                      </p>
                      <h3>{{ item.title }}</h3>
                      <p class="catalog-card__copy">{{ item.summary }}</p>

                      <div class="catalog-tag-list">
                        {% if resource_meta and resource_meta.tags and resource_meta.tags.size > 0 %}
                          {% for tag in resource_meta.tags %}
                            <span class="catalog-tag">{{ tag.label }}</span>
                          {% endfor %}
                        {% else %}
                          <span class="catalog-tag">{{ item.area }}</span>
                        {% endif %}
                      </div>

                      <div class="catalog-card__links">
                        {% if resolved_item_dataset != "" %}
                          <a class="catalog-link" href="{{ resolved_item_dataset }}">Dataset</a>
                        {% endif %}
                        {% if resolved_item_github != "" %}
                          <a class="catalog-link" href="{{ resolved_item_github }}">Code</a>
                        {% endif %}
                        {% if resolved_item_paper != "" %}
                          <a class="catalog-link" href="{{ resolved_item_paper }}">Paper</a>
                        {% endif %}
                      </div>
                    </div>
                  </article>
                {% endfor %}
              </div>
            </section>
          {% endif %}
        {% endfor %}
      </div>
    </div>
  </section>
</div>

{% include catalog-filters-script.html %}
