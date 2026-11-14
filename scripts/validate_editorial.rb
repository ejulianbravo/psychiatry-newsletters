# frozen_string_literal: true

require_relative "editorial"

begin
  posts = Editorial.validate!(File.expand_path("..", __dir__))
  puts "Editorial validation passed (#{posts.length} approved/published issues)."
rescue Editorial::Invalid => e
  abort "Editorial validation failed: #{e.message}"
end
