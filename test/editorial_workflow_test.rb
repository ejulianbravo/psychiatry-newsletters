# frozen_string_literal: true

# Uses the Ruby standard library; no test gems or network calls are needed.
require "fileutils"
require "tmpdir"
require "open3"
require "rbconfig"
require_relative "../scripts/editorial"

ROOT = File.expand_path("..", __dir__)

def assert(condition, message)
  raise message unless condition
end

def rejects(message)
  yield
  raise "Expected rejection: #{message}"
rescue Editorial::Invalid => e
  assert(e.message.include?(message), "Unexpected validation error: #{e.message}")
end

def fixture
  Dir.mktmpdir("editorial-test-") do |dir|
    root = File.join(dir, "source")
    FileUtils.mkdir_p(root)
    Dir.children(ROOT).each do |name|
      next if name.start_with?(".") || %w[_site _drafts editorial vendor test].include?(name)

      FileUtils.cp_r(File.join(ROOT, name), root)
    end
    _, error, result = Open3.capture3("git", "init", "--quiet", root)
    assert(result.success?, error)
    yield root, File.join(dir, "site")
  end
end

def issue(root, name, series: "psychosis-psychoeducation", status: "approved", body: "APPROVED_MARKER")
  approved, published = Editorial::STATES.fetch(status)
  path = File.join(root, "_posts", "2020-01-01-#{name}.md")
  data = { "title" => name, "date" => Date.new(2020, 1, 1), "newsletter" => series,
           "approved" => approved, "published" => published, "editorial_status" => status }
  File.write(path, YAML.dump(data) + "---\n\n#{body}\n")
  path
end

def build(root, destination, success: true)
  stdout, stderr, result = Open3.capture3(
    { "PAGES_ORIGIN" => "https://example.github.io", "PAGES_BASE_PATH" => "/psychiatry-newsletters",
      "PAGES_DESTINATION" => destination, "JEKYLL_ENV" => "production" },
    RbConfig.ruby, File.join(root, "scripts/build_pages.rb"), chdir: root
  )
  assert(result.success? == success, "Unexpected build result:\n#{stdout}\n#{stderr}")
  stdout + stderr
end

def output(destination)
  Dir.glob(File.join(destination, "**", "*"), File::FNM_DOTMATCH)
     .select { |path| File.file?(path) }.map { |path| File.read(path) }.join("\n")
end

checks = {
  "1. Private drafts stay out of the build and cannot be tracked" => lambda {
    fixture do |root, site|
      %w[_drafts editorial].each do |folder|
        FileUtils.mkdir_p(File.join(root, folder))
        File.write(File.join(root, folder, "private.md"), "PRIVATE_DRAFT_SENTINEL")
      end
      build(root, site)
      assert(!output(site).include?("PRIVATE_DRAFT_SENTINEL"), "Private text leaked")
      %w[_drafts editorial scripts test].each { |folder| assert(!File.exist?(File.join(site, folder)), "Leaked #{folder}") }
      _, error, result = Open3.capture3("git", "-C", root, "add", "_drafts", "editorial")
      assert(result.success?, error)
      rejects("Private/generated files are tracked") { Editorial.validate!(root) }
      build(root, site, success: false)
    end
  },
  "2. Contradictory, missing and unapproved metadata block publication" => lambda {
    Editorial::STATES.each do |status, expected|
      [true, false, nil, "true", "false"].repeated_permutation(2) do |approved, published|
        data = { "editorial_status" => status, "approved" => approved, "published" => published,
                 "newsletter" => "psychosis-psychoeducation" }
        if [approved, published] == expected
          Editorial.validate_data!(data, "fixture.md")
        else
          rejects("requires approved:") { Editorial.validate_data!(data, "fixture.md") }
        end
      end
    end
    fixture do |root, site|
      path = issue(root, "blocked", status: "draft-for-review")
      assert(build(root, site, success: false).include?("unapproved issues belong"), "Unapproved post accepted")
      File.write(path, "---\nnewsletter: psychosis-psychoeducation\n---\nNo states")
      rejects("editorial_status must be") { Editorial.validate!(root) }
      File.write(path, "---\n- invalid\n---\n")
      rejects("must be a mapping") { Editorial.validate!(root) }
      File.write(path, "---\napproved: [broken\n---\n")
      rejects("invalid YAML") { Editorial.validate!(root) }
      File.write(path, "Missing front matter")
      rejects("missing YAML front matter") { Editorial.validate!(root) }
      FileUtils.rm(path)
      path = issue(root, "bad-series", series: "typo")
      rejects("unknown newsletter") { Editorial.validate!(root) }
      FileUtils.rm(path)
      File.write(File.join(root, "_posts", "2020-01-01-no-extension"), "ignored by Jekyll")
      rejects("issue filename") { Editorial.validate!(root) }
    end
  },
  "3. Approved issues build in separate archives without changing source" => lambda {
    fixture do |root, site|
      path = issue(root, "Approved psychosis fixture", body: "PSYCHOSIS_APPROVED_SENTINEL")
      original = File.binread(path)
      issue(root, "Approved landmark fixture", series: "landmark-psychiatry-papers", body: "LANDMARK_APPROVED_SENTINEL")
      build(root, site)
      assert(File.binread(path) == original, "Build changed editorial source")
      assert(Editorial.metadata(path)["published"] == false, "Build marked an issue published")
      psycho = File.read(File.join(site, "psychosis-psychoeducation/index.html"))
      landmark = File.read(File.join(site, "landmark-psychiatry-papers/index.html"))
      assert(psycho.include?("Approved psychosis fixture") && !psycho.include?("Approved landmark fixture"), "Psychosis archive mixed series")
      assert(landmark.include?("Approved landmark fixture") && !landmark.include?("Approved psychosis fixture"), "Landmark archive mixed series")
      feed = File.read(File.join(site, "feed.xml"))
      assert(feed.include?("PSYCHOSIS_APPROVED_SENTINEL") && feed.include?("LANDMARK_APPROVED_SENTINEL"), "Approved issues missing from feed")
      assert(feed.include?("https://example.github.io/psychiatry-newsletters/"), "Incorrect feed URL")
    end
  },
  "4. Corrections rebuild at the same address; deployment stays manual" => lambda {
    fixture do |root, site|
      path = issue(root, "correction", status: "published", body: "ORIGINAL_CORRECTION_SENTINEL")
      build(root, site)
      article = Dir.glob(File.join(site, "2020", "**", "*.html")).find { |p| File.read(p).include?("ORIGINAL_CORRECTION_SENTINEL") }
      assert(article, "Published fixture missing")
      # A newly reviewed correction is approved for the next intentional deploy.
      issue(root, "correction", body: "REVIEWED_CORRECTION_SENTINEL")
      build(root, site)
      assert(File.read(article).include?("REVIEWED_CORRECTION_SENTINEL"), "Correction did not replace issue at stable URL")
      assert(!output(site).include?("ORIGINAL_CORRECTION_SENTINEL"), "Stale correction remains")
    end
    publish = YAML.load_file(File.join(ROOT, ".github/workflows/publish.yml"))
    validate = YAML.load_file(File.join(ROOT, ".github/workflows/validate.yml"))
    assert(publish.fetch("on", publish[true]).keys == ["workflow_dispatch"], "Publishing is automatic")
    gate = publish.fetch("jobs").fetch("build").fetch("if")
    assert(gate.include?("github.ref == 'refs/heads/main'") && gate.include?("inputs.confirmation == 'PUBLISH'"), "Missing publishing gate")
    assert(validate.fetch("on", validate[true]).keys.sort == %w[pull_request push], "Validation triggers missing")
    assert(validate.fetch("permissions") == { "contents" => "read" }, "Validation has write permissions")
    assert(!File.read(File.join(ROOT, ".github/workflows/validate.yml")).match?(/deploy-pages|upload-pages-artifact|pages: write|id-token: write/), "Validation can deploy")
  }
}

checks.each do |name, check|
  check.call
  puts "PASS #{name}"
end
puts "All four editorial workflow scenarios passed. No website was deployed."
