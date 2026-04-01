#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "fileutils"
require "json"
require "yaml"

ROOT = File.expand_path("..", __dir__)
WCSNG_ROOT = ENV["WCSNG_ROOT"] || File.expand_path("../ucsdwcsng.github.io", ROOT)
ACADEMIC_PUBLICATIONS_DIR = File.join(ROOT, "_publications")
RESOURCES_PATH = File.join(ROOT, "_data", "wcsng_resources.yml")
OUTPUT_PATH = File.join(ROOT, "_data", "wcsng_catalog.json")
IMAGE_DEST_ROOT = File.join(ROOT, "images", "wcsng-publications")
ACCEPTANCE_OVERRIDES_PATH = File.join(ROOT, "tools", "acceptance_rates.json")

SPECIAL_TAG_LABELS = {
  "5g" => "5G",
  "fsm" => "FSM",
  "llm" => "LLM",
  "rag" => "RAG",
  "wireless-sensing" => "Wireless Sensing",
  "spectrum-sensing" => "Spectrum Sensing"
}.freeze

def abort_with(message)
  warn message
  exit 1
end

def load_front_matter(path)
  text = File.read(path)
  match = text.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  return {} unless match

  YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: true) || {}
rescue Psych::Exception => error
  warn "Failed to parse front matter for #{path}: #{error.message}"
  {}
end

def load_document(path)
  text = File.read(path)
  match = text.match(/\A---\s*\n(.*?)\n---\s*\n?/m)
  return [{}, text.strip] unless match

  front_matter = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: true) || {}
  body = text[match.end(0)..].to_s.strip
  [front_matter, body]
rescue Psych::Exception => error
  warn "Failed to parse front matter for #{path}: #{error.message}"
  [{}, ""]
end

def clean_text(value)
  text = value.to_s.strip
  text.empty? ? nil : text
end

def normalize(text)
  text.to_s.downcase.gsub("&", " and ").gsub(/[^a-z0-9]+/, " ").strip.gsub(/\s+/, " ")
end

def compact_string(text)
  normalize(text).delete(" ")
end

def slug_after_date(basename)
  basename.sub(/\A\d{4}-\d{1,2}-\d{1,2}-/, "")
end

def split_tags(value)
  raw_tags =
    case value
    when Array
      value
    else
      value.to_s.split(/[,\s]+/)
    end

  raw_tags.map(&:strip).reject(&:empty?).uniq
end

def slugify_tag(tag)
  tag.to_s.downcase.gsub("&", " and ").gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
end

def display_tag(tag)
  slug = slugify_tag(tag)
  return SPECIAL_TAG_LABELS[slug] if SPECIAL_TAG_LABELS.key?(slug)

  tag.to_s.tr("_", " ").tr("-", " ").split.map { |part| part.upcase == part ? part : part.capitalize }.join(" ")
end

def tag_objects(tags)
  split_tags(tags).map do |tag|
    {
      "slug" => slugify_tag(tag),
      "label" => display_tag(tag)
    }
  end.uniq { |entry| entry["slug"] }
end

def github_repo_name(url)
  return nil unless url.to_s.include?("github.com/")

  cleaned = url.to_s.sub(%r{\.git/?\z}, "")
  cleaned.split("/").last&.strip
end

def dice_similarity(left, right)
  a = compact_string(left)
  b = compact_string(right)
  return 1.0 if a == b && !a.empty?
  return 0.0 if a.length < 2 || b.length < 2

  counts = Hash.new(0)
  (0..a.length - 2).each { |index| counts[a[index, 2]] += 1 }
  matches = 0
  (0..b.length - 2).each do |index|
    pair = b[index, 2]
    next unless counts[pair].positive?

    counts[pair] -= 1
    matches += 1
  end

  (2.0 * matches) / ((a.length - 1) + (b.length - 1))
end

def copied_image_path(image_path)
  image_path = clean_text(image_path)
  return nil if image_path.nil?
  return image_path if image_path.match?(%r{\Ahttps?://}i)
  return image_path unless image_path.start_with?("/")

  source = File.expand_path(image_path.sub(%r{\A/}, ""), WCSNG_ROOT)
  return image_path unless source.start_with?(WCSNG_ROOT) && File.file?(source)

  relative = image_path.sub(%r{\A/}, "")
  relative = relative.sub(%r{\Aassets/images/}, "")
  destination = File.join(IMAGE_DEST_ROOT, relative)
  FileUtils.mkdir_p(File.dirname(destination))
  FileUtils.cp(source, destination)

  "/images/wcsng-publications/#{relative}"
end

def normalize_author_list(value)
  Array(value).map do |author|
    next unless author.is_a?(Hash)

    name = clean_text(author["name"])
    next if name.nil?

    entry = { "name" => name }
    url = clean_text(author["url"])
    email = clean_text(author["email"])
    entry["url"] = url if url
    entry["email"] = email if email
    entry
  end.compact
end

def normalize_descriptions(value)
  Array(value).map do |entry|
    if entry.is_a?(Hash)
      title = clean_text(entry["title"])
      text = clean_text(entry["text"])
      image = copied_image_path(entry["image"])
      next if title.nil? && text.nil? && image.nil?

      normalized = {}
      normalized["title"] = title if title
      normalized["text"] = text if text
      normalized["image"] = image if image
      normalized["image_width"] = entry["image_width"] if entry["image_width"]
      alt = clean_text(entry["alt"]) || clean_text(entry["image_alt"])
      normalized["alt"] = alt if alt
      normalized
    else
      text = clean_text(entry)
      text ? { "text" => text } : nil
    end
  end.compact
end

def normalize_citations(value)
  Array(value).map do |entry|
    if entry.is_a?(Hash)
      text = clean_text(entry["text"])
      next if text.nil?

      normalized = { "text" => text }
      bib = clean_text(entry["bib"])
      bibtex = clean_text(entry["bibtex"])
      normalized["bib"] = bib if bib
      normalized["bibtex"] = bibtex if bibtex
      normalized
    else
      text = clean_text(entry)
      text ? { "text" => text } : nil
    end
  end.compact
end

def normalize_misc_links(value)
  Array(value).map do |entry|
    next unless entry.is_a?(Hash)

    label = clean_text(entry["content_type"]) || clean_text(entry["display"])
    url = clean_text(entry["content_url"]) || clean_text(entry["url"])
    next if label.nil? || url.nil?

    {
      "content_type" => label,
      "content_url" => url
    }
  end.compact
end

def build_post_record(path)
  front_matter, body = load_document(path)
  basename = File.basename(path, ".md")
  {
    "file" => File.basename(path),
    "basename" => basename,
    "title" => front_matter["title"].to_s.strip,
    "short_title" => front_matter["short_title"].to_s.strip,
    "title_norm" => normalize(front_matter["title"]),
    "short_title_norm" => normalize(front_matter["short_title"]),
    "slug_norm" => normalize(slug_after_date(basename)),
    "conference" => clean_text(front_matter["conference"]),
    "conference_site" => clean_text(front_matter["conference_site"]),
    "paper" => clean_text(front_matter["paper"]),
    "github" => clean_text(front_matter["github"]),
    "dataset" => clean_text(front_matter["dataset"]),
    "slides" => clean_text(front_matter["slides"]),
    "extra" => clean_text(front_matter["extra"]),
    "tags" => tag_objects(front_matter["tags"]),
    "cover" => copied_image_path(front_matter["cover"]),
    "display_cover" => clean_text(front_matter["disp_cover"]) != "False",
    "authors" => clean_text(front_matter["authors"]),
    "author_list" => normalize_author_list(front_matter["author_list"]),
    "description" => normalize_descriptions(front_matter["description"]),
    "citation" => normalize_citations(front_matter["citation"]),
    "miscs" => normalize_misc_links(front_matter["miscs"]),
    "video" => clean_text(front_matter["video"]),
    "video2" => clean_text(front_matter["video2"]),
    "video_str" => clean_text(front_matter["video_str"]),
    "banner" => clean_text(front_matter["banner"]),
    "body_markdown" => clean_text(body)
  }
end

def build_publication_record(path)
  front_matter = load_front_matter(path)
  basename = File.basename(path, ".md")
  {
    "basename" => basename,
    "title" => front_matter["title"].to_s.strip,
    "title_norm" => normalize(front_matter["title"]),
    "slug_norm" => normalize(slug_after_date(basename)),
    "github_repo" => github_repo_name(front_matter["github"])
  }
end

def match_post_to_publication(publication, posts)
  exact = posts.select { |post| post["title_norm"] == publication["title_norm"] }
  return exact.first if exact.one?

  exact_short = posts.select { |post| !post["short_title_norm"].empty? && post["short_title_norm"] == publication["title_norm"] }
  return exact_short.first if exact_short.one?

  exact_slug = posts.select { |post| post["slug_norm"] == publication["slug_norm"] }
  return exact_slug.first if exact_slug.one?

  scored = posts.map do |post|
    score = 0.0
    score += 4.0 if post["slug_norm"] == publication["slug_norm"]
    score += 3.0 if !post["short_title_norm"].empty? && post["short_title_norm"] == publication["title_norm"]
    score += 2.0 if post["github"] && publication["github_repo"] && github_repo_name(post["github"]) == publication["github_repo"]
    score += 5.0 * dice_similarity(post["title"], publication["title"])
    score += 2.0 * dice_similarity(post["short_title"], publication["title"]) unless post["short_title"].to_s.empty?
    [score, post]
  end

  best_score, best_post = scored.max_by(&:first)
  return nil if best_score.nil? || best_score < 3.8

  best_post
end

def load_resources
  YAML.safe_load(File.read(RESOURCES_PATH), permitted_classes: [Date, Time], aliases: true) || {}
end

def area_tag(area)
  {
    "slug" => slugify_tag(area),
    "label" => area.to_s
  }
end

def match_post_to_resource(resource, posts)
  title_norm = normalize(resource["title"])
  slug_norm = normalize(resource["slug"])
  repo_candidates = [resource["github"], resource["dataset"]].map { |url| github_repo_name(url) }.compact

  direct = posts.find do |post|
    post["title_norm"] == title_norm ||
      post["short_title_norm"] == title_norm ||
      post["slug_norm"] == slug_norm
  end
  return direct if direct

  repo_match = posts.find do |post|
    repo = github_repo_name(post["github"])
    repo && repo_candidates.include?(repo)
  end
  return repo_match if repo_match

  scored = posts.map do |post|
    score = 0.0
    score += 4.0 if post["slug_norm"] == slug_norm
    score += 3.0 if post["short_title_norm"] == title_norm
    score += 5.0 * dice_similarity(post["title"], resource["title"])
    score += 2.0 * dice_similarity(post["short_title"], resource["title"]) unless post["short_title"].to_s.empty?
    [score, post]
  end

  best_score, best_post = scored.max_by(&:first)
  return nil if best_score.nil? || best_score < 3.4

  best_post
end

def update_tag_counts(counts, tags)
  tags.each do |tag|
    counts[tag["slug"]] ||= { "slug" => tag["slug"], "label" => tag["label"], "count" => 0 }
    counts[tag["slug"]]["count"] += 1
  end
end

def load_acceptance_overrides
  return {} unless File.exist?(ACCEPTANCE_OVERRIDES_PATH)

  JSON.parse(File.read(ACCEPTANCE_OVERRIDES_PATH))
rescue JSON::ParserError => error
  warn "Could not parse #{ACCEPTANCE_OVERRIDES_PATH}: #{error.message}"
  {}
end

abort_with("Missing WCSNG repo at #{WCSNG_ROOT}") unless Dir.exist?(WCSNG_ROOT)

wcsng_publication_paths = Dir.glob(File.join(WCSNG_ROOT, "**", "*.md")).sort.reject do |path|
  path.include?("/test/") || path.include?("/vendor/") || path.include?("/node_modules/") || path.include?("/_site/")
end

posts = wcsng_publication_paths.map do |path|
  front_matter = load_front_matter(path)
  next unless front_matter["layout"] == "publication"

  build_post_record(path)
end.compact
publications = Dir.glob(File.join(ACADEMIC_PUBLICATIONS_DIR, "*.md")).sort.map { |path| build_publication_record(path) }
resources = load_resources
acceptance_overrides = load_acceptance_overrides

publication_entries = {}
publication_tag_counts = {}
publication_unmatched = []

publications.each do |publication|
  match = match_post_to_publication(publication, posts)
  unless match
    publication_unmatched << publication["basename"]
    next
  end

  overrides = acceptance_overrides[publication["basename"]] || {}
  entry = {
    "source_post" => match["file"],
    "title" => match["title"],
    "short_title" => match["short_title"],
    "conference" => match["conference"],
    "conference_site" => match["conference_site"],
    "paper" => match["paper"],
    "github" => match["github"],
    "dataset" => match["dataset"],
    "slides" => match["slides"],
    "extra" => match["extra"],
    "cover" => match["cover"],
    "display_cover" => match["display_cover"],
    "tags" => match["tags"],
    "authors" => match["authors"],
    "author_list" => match["author_list"],
    "description" => match["description"],
    "citation" => match["citation"],
    "miscs" => match["miscs"],
    "video" => match["video"],
    "video2" => match["video2"],
    "video_str" => match["video_str"],
    "banner" => match["banner"],
    "body_markdown" => match["body_markdown"],
    "acceptance_rate" => overrides["acceptance_rate"],
    "acceptance_note" => overrides["acceptance_note"]
  }
  publication_entries[publication["basename"]] = entry
  update_tag_counts(publication_tag_counts, entry["tags"])
end

resource_entries = {}
resource_tag_counts = {}
resource_unmatched = []

%w[software datasets].each do |group|
  Array(resources[group]).each do |resource|
    match = match_post_to_resource(resource, posts)
    tags = match ? match["tags"] : [area_tag(resource["area"])]
    entry = {
      "source_post" => match&.dig("file"),
      "cover" => match&.dig("cover"),
      "tags" => tags,
      "conference" => match&.dig("conference"),
      "short_title" => match&.dig("short_title")
    }
    resource_entries[resource["slug"]] = entry
    update_tag_counts(resource_tag_counts, tags)
    resource_unmatched << resource["slug"] unless match
  end
end

output = {
  "publications" => publication_entries,
  "publication_tags" => publication_tag_counts.values.sort_by { |entry| [-entry["count"], entry["label"]] },
  "resources" => resource_entries,
  "resource_tags" => resource_tag_counts.values.sort_by { |entry| [-entry["count"], entry["label"]] },
  "unmatched" => {
    "publications" => publication_unmatched.sort,
    "resources" => resource_unmatched.sort
  }
}

File.write(OUTPUT_PATH, JSON.pretty_generate(output) + "\n")

puts "Wrote #{OUTPUT_PATH}"
puts "Matched publications: #{publication_entries.size}/#{publications.size}"
puts "Matched resources: #{resource_entries.values.count { |entry| entry['source_post'] }}/#{resource_entries.size}"
puts "Unmatched publications: #{publication_unmatched.size}"
puts "Unmatched resources: #{resource_unmatched.size}"
