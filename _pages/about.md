---
permalink: /
title: "Dinesh Bharadia"
excerpt: "Associate Professor at UC San Diego working on wireless communication, sensing, networking, and autonomous perception systems."
layout: home
author_profile: false
---

{% include base_path %}
{% assign recent_publications = site.publications | sort: "date" | reverse %}
{% assign wcsng = site.data.wcsng %}
{% assign wcsng_research = site.data.wcsng_research %}
{% assign wcsng_news = site.data.wcsng_news %}
{% assign profile = site.data.profile %}

<section class="home-hero">
  <div class="home-hero__content">
    <h1 class="sr-only">Dinesh Bharadia</h1>
    <p class="home-eyebrow">UC San Diego | Electrical and Computer Engineering | CSE affiliate</p>
    <p class="home-lede">
      I am Associate Professor in the ECE department with an affiliate appointment with the CSE department at UC San Diego.
      Our group <a href="https://wcsng.ucsd.edu">WCSNG</a> designs systems for wireless communication, computing,
      sensing, and networking at UC San Diego.
    </p>
    <p class="home-lede">
      The vision for our research is to design and prototype performant systems for communicating, sensing,
      computing, and securing information in our connected world, solving real-world problems. Our research
      has aimed to solve fundamental questions, which has often led to new areas of research and commercialization.
    </p>
    <p class="home-lede home-lede--secondary">
      Our broad impact areas are vision and perception systems, sensing systems, wireless communications,
      computing systems, and wireless networking. WCSNG has curated and created open-source datasets and tools
      that enable reproducible research and lower the barrier to entry in communication, computing, and sensing.
    </p>
    <div class="home-link-strip">
      <a class="home-link-chip" href="{{ base_path }}/research/">Research areas</a>
      <a class="home-link-chip" href="{{ base_path }}/publications/">Publications</a>
      <a class="home-link-chip" href="{{ base_path }}/software/">Datasets &amp; tools</a>
    </div>
    <div class="home-intro-meta">
      <p>Associate Professor, Electrical and Computer Engineering</p>
      <p>Affiliate Faculty, Computer Science and Engineering</p>
      <p>{{ profile.office.address }}</p>
      <p>Office hours: {{ profile.office.hours }}</p>
    </div>
  </div>

  <aside class="home-profile">
    <img class="home-profile__image" src="{{ base_path }}/images/WebpageNewPic.jpg" alt="Dinesh Bharadia portrait">
    <div class="home-profile__content">
      <p class="home-profile__name">Dinesh Bharadia</p>
    </div>
    <div class="home-link-list">
      <a href="https://wcsng.ucsd.edu">WCSNG Lab</a>
      <a href="https://scholar.google.com/citations?user=5SjaXJsAAAAJ&amp;hl=en">Google Scholar</a>
    </div>
    <p class="home-profile__contact">Contact: <span>dineshb at ucsd dot edu</span></p>
  </aside>
</section>

<section class="home-section home-section--summary">
  <div class="home-summary-grid">
    <article class="home-summary-card">
      <p class="home-section__eyebrow">Openings</p>
      <h2>Apply to WCSNG Group</h2>
      <p>{{ profile.openings.intro }}</p>
      <p>{{ profile.openings.details }}</p>
      <div class="home-bullet-list">
        {% for item in profile.openings.response %}
          <p>{{ item }}</p>
        {% endfor %}
      </div>
      <a class="home-text-link" href="{{ wcsng.links.join_us }}">Current openings and forms</a>
    </article>

    <article class="home-summary-card">
      <p class="home-section__eyebrow">Honors</p>
      <h2>Selected awards and recognition</h2>
      <div class="home-awards-list">
        {% for item in profile.honors %}
          <p>
            {% if item.url %}
              <strong><a href="{{ item.url }}">{{ item.title }}</a></strong>
            {% else %}
              <strong>{{ item.title }}</strong>
            {% endif %}
            {% if item.year %}<span> | {{ item.year }}</span>{% endif %}
          </p>
        {% endfor %}
      </div>
    </article>
  </div>
</section>

<section class="home-section home-section--group">
  <div class="home-group-grid">
    <div class="home-group-copy">
      <div class="home-section__heading">
        <p class="home-section__eyebrow">WCSNG</p>
        <h2>Projects, impact areas, and current directions.</h2>
        <p>
          WCSNG consists of highly interdisciplinary engineers spanning electrical engineering, computer science,
          data science, sensing, circuits, computer vision, machine learning, and AI.
        </p>
        <p>
          We develop science and algorithms alongside real-world implementations and prototypes, moving from
          fundamental ideas to deployable systems and shared research infrastructure.
        </p>
      </div>

      <div class="home-group-areas">
        <h3>Key research areas</h3>
        <div class="home-pill-list">
          {% for area in wcsng_research.areas %}
            <a class="home-pill" href="{{ base_path }}{{ area.url }}">{{ area.title }}</a>
          {% endfor %}
        </div>
      </div>

      <div class="home-link-cluster">
        <a class="home-text-link" href="{{ wcsng.links.home }}">Visit WCSNG</a>
        <a class="home-text-link" href="{{ base_path }}/team/">Meet the team</a>
        <a class="home-text-link" href="{{ base_path }}/software/">Open source projects</a>
        <a class="home-text-link" href="{{ wcsng.links.join_us }}">Join the group</a>
      </div>
    </div>

    <aside class="home-news-panel">
      <p class="home-section__eyebrow">Recent from the group</p>
      <h3>WCSNG news</h3>
      <div class="home-news-list">
        {% for item in wcsng_news limit: 6 %}
          <article class="home-news-item">
            <p class="home-news-item__date">{{ item.date }}</p>
            <p>{{ item.headline }}</p>
          </article>
        {% endfor %}
      </div>
      <a class="home-text-link" href="{{ base_path }}/news/">More group news</a>
    </aside>
  </div>
</section>

<section class="home-section">
  <div class="home-section__heading">
    <p class="home-section__eyebrow">Research</p>
    <h2>Systems research shaped by real deployment constraints.</h2>
    <p>
      The research program spans perception systems, sensing systems, wireless communications, computing systems,
      and wireless networking, with projects that move from theory to deployable prototypes, curated datasets,
      and open tools.
    </p>
  </div>

  <div class="home-research-grid">
    {% for area in wcsng_research.areas limit: 4 %}
      <a class="home-research-card" href="{{ base_path }}{{ area.url }}">
        {% if area.image %}
          <div class="home-research-card__media">
            <img src="{{ base_path }}{{ area.image }}" alt="{{ area.image_alt | default: area.title }}">
          </div>
        {% endif %}
        <div class="home-research-card__body">
          <h3>{{ area.title }}</h3>
          <p>{{ area.summary }}</p>
        </div>
      </a>
    {% endfor %}
  </div>

  <div class="home-section__cta">
    <a class="home-text-link" href="{{ base_path }}/research/">View all research areas</a>
  </div>
</section>

<section class="home-section home-section--split">
  <div class="home-section__heading">
    <p class="home-section__eyebrow">Publications</p>
    <h2>Recent papers and systems contributions.</h2>
    <p>
      Selected work across wireless communication, sensing, localization, perception, and robust networked systems.
      The full archive includes papers, project pages, and software links.
    </p>
  </div>

  <div class="home-publications">
    {% for post in recent_publications limit: 4 %}
      {% assign home_paper_available = false %}
      {% if post.paperurl %}
        {% if post.paperurl contains "://" %}
          {% assign home_paper_available = true %}
        {% else %}
          {% assign home_paper = site.static_files | where: "path", post.paperurl | first %}
          {% if home_paper %}
            {% assign home_paper_available = true %}
          {% endif %}
        {% endif %}
      {% endif %}
      <article class="home-publication">
        <p class="home-publication__meta">{{ post.date | date: "%Y" }}{% if post.venue %} | {{ post.venue }}{% endif %}</p>
        <h3><a href="{{ base_path }}{{ post.url }}">{{ post.title }}</a></h3>
        {% if post.citation %}
          <p class="home-publication__citation">{{ post.citation | strip | truncate: 180 }}</p>
        {% endif %}
        <div class="home-publication__links">
          {% if home_paper_available %}
            <a href="{% if post.paperurl contains '://' %}{{ post.paperurl }}{% else %}{{ base_path }}{{ post.paperurl }}{% endif %}" aria-label="Read the paper for {{ post.title }}">Paper</a>
          {% endif %}
          {% if post.link %}
            <a href="{{ post.link }}" aria-label="Open the project page for {{ post.title }}">Project</a>
          {% endif %}
          {% if post.code %}
            <a href="{{ post.code }}" aria-label="Open the code for {{ post.title }}">Code</a>
          {% endif %}
          {% if post.github %}
            <a href="{{ post.github }}" aria-label="Open the GitHub repository for {{ post.title }}">GitHub</a>
          {% endif %}
        </div>
      </article>
    {% endfor %}
  </div>

  <div class="home-section__cta">
    <a class="home-text-link" href="{{ base_path }}/publications/">See the full publications archive</a>
  </div>
</section>

<section class="home-section home-section--bio">
  <div class="home-summary-grid">
    <article class="home-summary-card">
      <p class="home-section__eyebrow">Bio</p>
      <h2>Short professional background</h2>
      <div class="home-bullet-list">
        {% for paragraph in profile.bio %}
          <p>{{ paragraph }}</p>
        {% endfor %}
      </div>
    </article>

    <article class="home-summary-card">
      <p class="home-section__eyebrow">Impact</p>
      <h2>{{ profile.industry.title }}</h2>
      <p>{{ profile.industry.text }}</p>
    </article>
  </div>
</section>

<section class="home-section home-section--teaching">
  <div class="home-section__heading">
    <p class="home-section__eyebrow">Teaching</p>
    <h2>Hands-on systems courses with a strong theory core.</h2>
    <p>
      My teaching centers on challenging assumptions, building strong intuition, and pairing theory with direct
      exposure to systems, hardware, and applied experimentation.
    </p>
  </div>

  <div class="home-course-grid">
    <article class="home-course">
      <p class="home-course__type">Current course</p>
      <h3>ECE 157A</h3>
      <p>Wireless communications laboratory built around SDRs, labs, mini-projects, and digital communication systems.</p>
      <p><a class="home-text-link" href="{{ base_path }}/teaching/ece-157a/">View ECE 157A course page</a></p>
    </article>
    <article class="home-course">
      <p class="home-course__type">Graduate</p>
      <h3>ECE 257B</h3>
      <p>Principles of Wireless Communication, focused on foundations and system design tradeoffs.</p>
      <p><a class="home-text-link" href="{{ base_path }}/teaching/ece-257b/">View ECE 257B course page</a></p>
    </article>
    <article class="home-course">
      <p class="home-course__type">Laboratory</p>
      <h3>ECE 157B</h3>
      <p>Wireless communication and wireless sensing laboratories built around practical experimentation.</p>
      <p><a class="home-text-link" href="{{ base_path }}/teaching/ece-157b/">View ECE 157B course page</a></p>
    </article>
    <article class="home-course">
      <p class="home-course__type">Laboratory archive</p>
      <h3>ECE 157B</h3>
      <p>Wireless sensing laboratory material spanning respiration, FMCW, localization, and practical experimentation.</p>
      <p><a class="home-text-link" href="{{ base_path }}/teaching/ece-157b/">View ECE 157B archive page</a></p>
    </article>
  </div>

  <div class="home-section__cta">
    <a class="home-text-link" href="{{ base_path }}/teaching/">Read more about teaching</a>
  </div>
</section>
