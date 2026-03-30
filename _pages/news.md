---
layout: feature
title: "News"
permalink: /news/
author_profile: false
---

{% include base_path %}
{% assign wcsng = site.data.wcsng %}
{% assign news_items = site.data.wcsng_news %}

<div class="feature-page">
  <section class="feature-hero feature-hero--warm">
    <div class="feature-hero__copy">
      <p class="feature-eyebrow">WCSNG</p>
      <h1>Recent group milestones, papers, demos, and workshops.</h1>
      <p class="feature-lede">
        This page keeps the personal site aligned with the major milestones from the WCSNG group:
        accepted papers, awards, workshops, project releases, and student news.
      </p>
      <div class="feature-link-row">
        <a class="feature-button feature-button--primary" href="{{ wcsng.links.home }}">Visit WCSNG</a>
        <a class="feature-button feature-button--secondary" href="{{ wcsng.links.publications }}">Group publications</a>
      </div>
    </div>

    <aside class="feature-hero__panel">
      <p class="feature-eyebrow">Scope</p>
      <h2>Imported from the WCSNG news source</h2>
      <p>
        The items below are curated from the lab's local source repo so this site can surface the same
        milestones without manually copying headlines into the homepage.
      </p>
      <div class="feature-mini-stats">
        <div>
          <strong>{{ news_items | size }}</strong>
          <span>news items</span>
        </div>
        <div>
          <strong>2021-2025</strong>
          <span>current timeline</span>
        </div>
      </div>
    </aside>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Timeline</p>
      <h2>Highlights from the group</h2>
    </div>

    <div class="news-timeline">
      {% for item in news_items %}
        <article class="news-entry">
          <p class="news-entry__date">{{ item.date }}</p>
          <div class="news-entry__content">
            <p>{{ item.headline }}</p>
          </div>
        </article>
      {% endfor %}
    </div>
  </section>
</div>
