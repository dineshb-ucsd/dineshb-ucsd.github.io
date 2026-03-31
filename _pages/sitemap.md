---
layout: archive
title: "Sitemap"
permalink: /sitemap/
author_profile: false
---

{% include base_path %}

A list of the main public pages on the site. For search engines, the XML sitemap remains available at [sitemap.xml]({{ base_path }}/sitemap.xml).

## Main pages

- [Home]({{ base_path }}/)
- [Research]({{ base_path }}/research/)
- [Publications]({{ base_path }}/publications/)
- [Teaching]({{ base_path }}/teaching/)
- [Open Source & Data]({{ base_path }}/software/)
- [News]({{ base_path }}/news/)
- [CV]({{ base_path }}/cv/)

## Teaching pages

{% for course in site.data.navigation.teaching_courses[0].children %}
- [{{ course.title }}]({{ base_path }}{{ course.url }})
{% endfor %}

## Research areas

{% assign research_pages = site.research | sort: "title" %}
{% for post in research_pages %}
- [{{ post.title }}]({{ base_path }}{{ post.url }})
{% endfor %}
