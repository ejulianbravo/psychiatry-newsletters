# frozen_string_literal: true

require "date"
require "yaml"
require "open3"

module Editorial
  class Invalid < StandardError; end

  SERIES = %w[landmark-psychiatry-papers psychosis-psychoeducation].freeze
  STATES = {
    "draft" => [false, false],
    "draft-for-review" => [false, false],
    "revisions-requested" => [false, false],
    "approved" => [true, false],
    "published" => [true, true]
  }.freeze
  PRIVATE_PATHS = %w[_drafts editorial _site].freeze

  def self.metadata(path)
    text = File.read(path, encoding: "UTF-8").sub(/\A\uFEFF/, "")
    match = text.match(/\A---[ \t]*\r?\n(.*?)\r?\n---[ \t]*(?:\r?\n|\z)/m)
    raise Invalid, "#{path}: missing YAML front matter" unless match

    data = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: false)
    raise Invalid, "#{path}: front matter must be a mapping" unless data.is_a?(Hash)

    data
  rescue Psych::Exception => e
    raise Invalid, "#{path}: invalid YAML: #{e.message}"
  end

  def self.validate_data!(data, path)
    status = data["editorial_status"]
    expected = STATES[status]
    raise Invalid, "#{path}: editorial_status must be one of #{STATES.keys.join(', ')}" unless expected

    unless data.values_at("approved", "published") == expected
      raise Invalid, "#{path}: #{status} requires approved: #{expected[0]} and published: #{expected[1]} (YAML booleans)"
    end
    raise Invalid, "#{path}: unknown newsletter #{data['newsletter'].inspect}" unless SERIES.include?(data["newsletter"])
  end

  def self.validate!(root)
    # Exclusion from the website does not make a tracked draft private on GitHub.
    tracked, error, result = Open3.capture3("git", "-C", root, "ls-files", "-z")
    raise Invalid, "Cannot check tracked source: #{error.strip}" unless result.success?

    leaked = tracked.split("\0").select { |path| PRIVATE_PATHS.include?(path.split('/').first) }
    raise Invalid, "Private/generated files are tracked: #{leaked.join(', ')}" unless leaked.empty?

    paths = Dir.glob(File.join(root, "**", "_posts", "**", "*"), File::FNM_DOTMATCH)
    paths.reject! { |path| path.delete_prefix("#{root}/").split('/').any? { |part| part.start_with?('.') || (PRIVATE_PATHS + %w[vendor test]).include?(part) } }
    posts = paths.select { |path| File.file?(path) }.sort
    posts.each do |path|
      unless File.basename(path).match?(/\A\d{4}-\d{2}-\d{2}-.+\.(md|markdown|html)\z/)
        raise Invalid, "#{path}: use a dated .md, .markdown, or .html issue filename"
      end
      data = metadata(path)
      validate_data!(data, path)
      unless %w[approved published].include?(data["editorial_status"])
        raise Invalid, "#{path}: unapproved issues belong in local _drafts/, outside the public repository"
      end
    end
    posts
  end
end
