---
layout: feature
title: "Team"
permalink: /team/
author_profile: false
---

{% include base_path %}
{% assign current_people = site.data.wcsng_people %}
{% assign current_phd = current_people | where: "role", "PhD" %}
{% assign current_ms = site.data.wcsng_people_text | where: "role", "MS" %}
{% assign current_bs = site.data.wcsng_people_text | where: "role", "BS" %}
{% assign phd_alumni = site.data.wcsng_alumni | where: "role", "PhD" %}
{% assign postdoc_alumni = site.data.wcsng_alumni | where: "role", "Postdoc" %}
{% assign visiting_alumni = site.data.wcsng_alumni | where: "role", "Visiting Researcher" %}
{% assign ms_alumni = site.data.wcsng_alumni | where: "role", "MS" %}

<div class="feature-page">
  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Leadership</p>
      <h2>Principal investigator</h2>
    </div>

    <div class="team-grid team-grid--lead">
      {% for member in current_people %}
        {% if member.role == "Principal Investigator" %}
          {% assign member_image = member.picture | replace: "/assets/images/teampic/", "/images/wcsng-team/" %}
          <article class="team-card team-card--lead">
            <div class="team-card__media">
              <img src="{{ base_path }}{{ member_image }}" alt="Portrait of {{ member.name }}">
            </div>
            <div class="team-card__body">
              <p class="team-card__meta">Principal Investigator</p>
              <h3><a href="{{ base_path }}/">{{ member.name }}</a></h3>
              <p>Associate Professor, Electrical and Computer Engineering</p>
              <p>Affiliate Faculty, Computer Science and Engineering</p>
            </div>
          </article>
        {% endif %}
      {% endfor %}
    </div>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Current team</p>
      <h2>PhD students</h2>
      <p>The current doctoral researchers driving the core systems, communication, sensing, and perception efforts in WCSNG.</p>
    </div>

    <div class="team-grid">
      {% for member in current_phd %}
        {% assign member_image = member.picture | replace: "/assets/images/teampic/", "/images/wcsng-team/" %}
        <article class="team-card">
          <div class="team-card__media">
            <img src="{{ base_path }}{{ member_image }}" alt="Portrait of {{ member.name }}">
          </div>
          <div class="team-card__body">
            <p class="team-card__meta">Current PhD student</p>
            <h3>
              {% if member.website %}
                <a href="{{ member.website }}">{{ member.name }}</a>
              {% else %}
                {{ member.name }}
              {% endif %}
            </h3>
            <p>{{ member.role }}</p>
          </div>
        </article>
      {% endfor %}
    </div>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Researchers</p>
      <h2>Researchers, visitors, and collaborators</h2>
    </div>

    <div class="team-grid team-grid--compact">
      {% for member in current_people %}
        {% unless member.role == "Principal Investigator" %}
          {% unless member.role == "PhD" %}
            {% assign member_image = member.picture | replace: "/assets/images/teampic/", "/images/wcsng-team/" %}
            <article class="team-card">
              <div class="team-card__media">
                <img src="{{ base_path }}{{ member_image }}" alt="Portrait of {{ member.name }}">
              </div>
              <div class="team-card__body">
                <p class="team-card__meta">Current role</p>
                <h3>
                  {% if member.website %}
                    <a href="{{ member.website }}">{{ member.name }}</a>
                  {% else %}
                    {{ member.name }}
                  {% endif %}
                </h3>
                <p>{{ member.role }}</p>
              </div>
            </article>
          {% endunless %}
        {% endunless %}
      {% endfor %}
    </div>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Student researchers</p>
      <h2>Current MS and undergraduate researchers</h2>
    </div>

    <div class="team-list-grid">
      <article class="team-list-card">
        <p class="team-card__meta">Master's students</p>
        <ul class="team-name-list">
          {% for member in current_ms %}
            <li>
              <strong>{{ member.name }}</strong>
              {% if member.year %}<span>Expected {{ member.year }}</span>{% endif %}
            </li>
          {% endfor %}
        </ul>
      </article>

      <article class="team-list-card">
        <p class="team-card__meta">Undergraduate researchers</p>
        <ul class="team-name-list">
          {% for member in current_bs %}
            <li>
              <strong>{{ member.name }}</strong>
              {% if member.year %}<span>Expected {{ member.year }}</span>{% endif %}
            </li>
          {% endfor %}
        </ul>
      </article>
    </div>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Alumni</p>
      <h2>Former PhD students, postdocs, and researchers</h2>
      <p>Many alumni have gone on to faculty positions, research labs, startups, and major systems companies.</p>
    </div>

    <div class="team-grid">
      {% for member in phd_alumni %}
        {% if member.picture %}
          {% assign member_image = member.picture | replace: "/assets/images/teampic/", "/images/wcsng-team/" %}
          <article class="team-card">
            <div class="team-card__media">
              <img src="{{ base_path }}{{ member_image }}" alt="Portrait of {{ member.name }}">
            </div>
            <div class="team-card__body">
              <p class="team-card__meta">PhD alumnus</p>
              <h3>
                {% if member.website %}
                  <a href="{{ member.website }}">{{ member.name }}</a>
                {% else %}
                  {{ member.name }}
                {% endif %}
              </h3>
              <p>Class of {{ member.year }}{% if member.now %} | {{ member.now }}{% endif %}</p>
            </div>
          </article>
        {% endif %}
      {% endfor %}

      {% for member in postdoc_alumni %}
        {% if member.picture %}
          {% assign member_image = member.picture | replace: "/assets/images/teampic/", "/images/wcsng-team/" %}
          <article class="team-card">
            <div class="team-card__media">
              <img src="{{ base_path }}{{ member_image }}" alt="Portrait of {{ member.name }}">
            </div>
            <div class="team-card__body">
              <p class="team-card__meta">{{ member.role }}</p>
              <h3>
                {% if member.website %}
                  <a href="{{ member.website }}">{{ member.name }}</a>
                {% else %}
                  {{ member.name }}
                {% endif %}
              </h3>
              <p>{% if member.year %}Class of {{ member.year }}{% endif %}{% if member.now %}{% if member.year %} | {% endif %}{{ member.now }}{% endif %}</p>
            </div>
          </article>
        {% endif %}
      {% endfor %}

      {% for member in visiting_alumni %}
        {% if member.picture %}
          {% assign member_image = member.picture | replace: "/assets/images/teampic/", "/images/wcsng-team/" %}
          <article class="team-card">
            <div class="team-card__media">
              <img src="{{ base_path }}{{ member_image }}" alt="Portrait of {{ member.name }}">
            </div>
            <div class="team-card__body">
              <p class="team-card__meta">{{ member.role }}</p>
              <h3>
                {% if member.website %}
                  <a href="{{ member.website }}">{{ member.name }}</a>
                {% else %}
                  {{ member.name }}
                {% endif %}
              </h3>
              <p>{% if member.year %}Class of {{ member.year }}{% endif %}{% if member.now %}{% if member.year %} | {% endif %}{{ member.now }}{% endif %}</p>
            </div>
          </article>
        {% endif %}
      {% endfor %}
    </div>
  </section>

  <section class="feature-section">
    <div class="feature-section__header">
      <p class="feature-eyebrow">Alumni</p>
      <h2>Former MS researchers</h2>
    </div>

    <article class="team-list-card">
      <ul class="team-name-list team-name-list--columns">
        {% for member in ms_alumni %}
          <li>
            <strong>{{ member.name }}</strong>
            <span>Class of {{ member.year }}{% if member.now %} | {{ member.now }}{% endif %}</span>
          </li>
        {% endfor %}
      </ul>
    </article>
  </section>
</div>
