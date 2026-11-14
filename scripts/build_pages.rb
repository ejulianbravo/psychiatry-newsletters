# frozen_string_literal: true

require "fileutils"
require "tmpdir"
require "jekyll"
require_relative "editorial"

root = File.expand_path("..", __dir__)
begin
  posts = Editorial.validate!(root)
rescue Editorial::Invalid => e
  abort "Publication blocked: #{e.message}"
end

origin = ENV.fetch("PAGES_ORIGIN")
base_path = ENV.fetch("PAGES_BASE_PATH", "")
abort "PAGES_ORIGIN must be an https URL" unless origin.match?(%r{\Ahttps://[^/]+\z})
abort "Invalid Pages base path" unless base_path.empty? || base_path.match?(%r{\A/[a-zA-Z0-9._/-]+\z})
destination = File.expand_path(ENV.fetch("PAGES_DESTINATION", File.join(root, "_site")), root)
abort "Destination must not replace source" if root == destination || root.start_with?("#{destination}/")
if destination.start_with?("#{root}/") && destination != File.join(root, "_site")
  abort "A destination inside the source must be _site"
end

# Jekyll's published flag controls rendering, not evidence of a successful
# deployment. Promote approved issues only in this temporary build copy.
# The reviewed source and its editorial history remain unchanged.
Dir.mktmpdir("newsletter-build-") do |source|
  excluded = Editorial::PRIVATE_PATHS + %w[scripts test vendor README.md about.markdown]
  Dir.children(root).each do |name|
    path = File.join(root, name)
    next if name.start_with?(".") || excluded.include?(name)
    next if destination == path || destination.start_with?("#{path}/")

    FileUtils.cp_r(path, source)
  end
  posts.each do |path|
    copy = File.join(source, path.delete_prefix("#{root}/"))
    text = File.read(copy).sub(/\A\uFEFF/, "")
    text.sub!(/\A---[ \t]*\r?\n(.*?)\r?\n---[ \t]*(?:\r?\n|\z)/m) do
      YAML.dump(Editorial.metadata(path).merge("published" => true)) + "---\n"
    end
    File.write(copy, text)
  end

  config = Jekyll.configuration(
    "source" => source,
    "destination" => destination,
    "url" => origin,
    "baseurl" => base_path,
    "show_drafts" => false,
    "unpublished" => false,
    "future" => false,
    "disable_disk_cache" => true
  )
  config["exclude"] |= excluded
  Jekyll::Site.new(config).process
  abort "Editorial files leaked into build" if File.exist?(File.join(destination, "editorial"))
end
puts "Approved website built for #{origin}#{base_path}"
