# frozen_string_literal: true

require "date"
require "yaml"
require "jekyll"

root = File.expand_path("..", __dir__)
series = %w[landmark-psychiatry-papers psychosis-psychoeducation]
Dir.glob(File.join(root, "_posts", "**", "*.{md,markdown,html}")).each do |path|
  text = File.read(path).sub(/\A\uFEFF/, "")
  match = text.match(/\A---\s*\r?\n(.*?)\r?\n---\s*(?:\r?\n|\z)/m)
  next unless match # Jekyll does not publish posts without front matter.
  data = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: false) || {}
  next unless data["published"] == true
  abort "Publication blocked: #{File.basename(path)} is not approved" unless data["approved"] == true
  abort "Unknown newsletter: #{File.basename(path)}" unless series.include?(data["newsletter"])
end

origin = ENV.fetch("PAGES_ORIGIN")
base_path = ENV.fetch("PAGES_BASE_PATH", "")
abort "PAGES_ORIGIN must be an https URL" unless origin.match?(%r{\Ahttps://[^/]+\z})
abort "Invalid Pages base path" unless base_path.empty? || base_path.match?(%r{\A/[a-zA-Z0-9._/-]+\z})
config = Jekyll.configuration(
  "source" => root,
  "destination" => ENV.fetch("PAGES_DESTINATION", File.join(root, "_site")),
  "url" => origin,
  "baseurl" => base_path,
  "show_drafts" => false,
  "unpublished" => false,
  "future" => false,
  "disable_disk_cache" => true
)
config["exclude"] |= ["editorial", "scripts", "README.md", "about.markdown"]
Jekyll::Site.new(config).process
abort "Editorial files leaked into build" if File.exist?(File.join(config["destination"], "editorial"))
puts "Approved website built for #{origin}#{base_path}"
