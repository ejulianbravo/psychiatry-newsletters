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

def issue(root, name, series: "psychosis-psychoeducation", status: "approved", body: "APPROVED_MARKER", generation: nil, date: Date.new(2020, 1, 1))
  approved, published = Editorial::STATES.fetch(status)
  path = File.join(root, "_posts", "#{date.iso8601}-#{name}.md")
  data = { "title" => name, "date" => date, "newsletter" => series,
           "approved" => approved, "published" => published, "editorial_status" => status }
  data["ai_generation"] = generation if generation
  File.write(path, YAML.dump(data) + "---\n\n#{body}\n")
  path
end

def build(root, destination, success: true, origin: "https://example.github.io", base_path: "/psychiatry-newsletters")
  stdout, stderr, result = Open3.capture3(
    { "PAGES_ORIGIN" => origin, "PAGES_BASE_PATH" => base_path,
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
      path = issue(root, "Approved psychosis fixture", body: "PSYCHOSIS_APPROVED_SENTINEL",
                   generation: { "model" => "recorded-model", "model_family" => "Recorded family",
                                 "generation_date" => Date.new(2019, 12, 31) })
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
      about = File.read(File.join(site, "about/index.html"))
      assert(about.include?("Jekyll-based publishing experiment") && about.include?("I assume editorial responsibility"), "About page missing project scope or responsibility")
      ["PSYCHOSIS_APPROVED_SENTINEL", "LANDMARK_APPROVED_SENTINEL"].each do |marker|
        article = Dir.glob(File.join(site, "2020", "**", "*.html")).map { |p| File.read(p) }.find { |html| html.include?(marker) }
        assert(article && article.scan('class="issue-disclosure"').length == 1, "Each series needs exactly one disclosure footer")
        assert(article.include?('href="/psychiatry-newsletters/about/"'), "Footer About link has wrong project path")
        if marker == "PSYCHOSIS_APPROVED_SENTINEL"
          assert(article.include?("recorded-model") && article.include?("December 31, 2019"), "Recorded model/date missing")
          assert(!article.include?("Model details were not recorded"), "Recorded provenance shown as missing")
        else
          assert(article.include?("Model details were not recorded for this edition"), "Missing model must not be invented")
          assert(!article.include?("recorded-model"), "Model metadata leaked between editions")
        end
      end
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
  },
  "5. Latest links and named reading links stay within their newsletter" => lambda {
    fixture do |root, site|
      FileUtils.rm_rf(File.join(root, "_posts"))
      FileUtils.mkdir_p(File.join(root, "_posts"))
      first = issue(root, "psychosis-first", date: Date.new(2020, 1, 1), body: "FIRST_SERIES_ISSUE")
      latest = issue(root, "psychosis-latest", date: Date.new(2020, 1, 3), body: "LATEST_SERIES_ISSUE")
      issue(root, "landmark-only", series: "landmark-psychiatry-papers", date: Date.new(2020, 1, 2))
      issue(root, "future-issue", date: Date.new(2100, 1, 1), body: "FUTURE_ISSUE_SENTINEL")
      FileUtils.mkdir_p(File.join(root, "_drafts"))
      File.write(File.join(root, "_drafts/private.md"), "PRIVATE_LATEST_SENTINEL")
      originals = [first, latest].to_h { |path| [path, File.binread(path)] }
      build(root, site)
      latest_url = "/psychiatry-newsletters/2020/01/03/psychosis-latest.html"
      previous_url = "/psychiatry-newsletters/2020/01/01/psychosis-first.html"
      redirect = File.read(File.join(site, "psychosis/latest/index.html"))
      assert(redirect.include?(%(data-latest-target="#{latest_url}")), "Latest shortcut selected the wrong issue or base path")
      assert(redirect.include?(%(url=#{latest_url})) && redirect.include?("<noscript>"), "Latest shortcut needs a no-JavaScript fallback")
      assert(redirect.include?("noindex, follow"), "Redirect should not become a duplicate search result")
      article = File.read(File.join(site, "2020/01/03/psychosis-latest.html"))
      assert(article.include?('class="issue-status">Latest issue'), "Newest issue is not identified")
      assert(article.include?('data-newsletter="psychosis-psychoeducation"'), "Issue lost its series identity")
      assert(article.include?(%(rel="prev" href="#{previous_url}")), "Named previous link points outside this newsletter")
      assert(article.index('class="previous-issue-invitation"') < article.index("LATEST_SERIES_ISSUE"), "Previous issue invitation must appear before the article")
      assert(!article.include?("landmark-only") && !article.include?('rel="next"'), "Latest issue has foreign or newer issue navigation")
      earlier = File.read(File.join(site, "2020/01/01/psychosis-first.html"))
      assert(earlier.include?('archive-status') && earlier.include?(%(rel="next" href="#{latest_url}")), "Older issue needs archive status and named forward navigation")
      assert(!earlier.include?('rel="prev"'), "First issue must not wrap around to the latest issue")
      landing = File.read(File.join(site, "psychosis-psychoeducation/index.html"))
      assert(landing.include?('id="previous-issues"') && landing.include?("psychosis-first"), "Series home must invite exploration of earlier issues")
      assert(!landing.include?("landmark-only"), "Series home mixed the two issue lists")
      assert(!output(site).include?("FUTURE_ISSUE_SENTINEL") && !output(site).include?("PRIVATE_LATEST_SENTINEL"), "Future/private content entered reader navigation")
      originals.each { |path, original| assert(File.binread(path) == original, "Navigation changed an approved manuscript") }
      issue(root, "psychosis-newest", date: Date.new(2020, 1, 4))
      build(root, site)
      updated = File.read(File.join(site, "psychosis/latest/index.html"))
      assert(updated.include?("/2020/01/04/psychosis-newest.html"), "Permanent latest shortcut did not advance after publication")
      landmark = File.read(File.join(site, "landmarks/latest/index.html"))
      assert(landmark.include?("/2020/01/02/landmark-only.html") && !landmark.include?("psychosis-newest"), "Updating one series changed the other latest shortcut")
    end
  },
  "6. Empty and first-issue series work on the custom-domain root" => lambda {
    fixture do |root, site|
      FileUtils.rm_rf(File.join(root, "_posts"))
      FileUtils.mkdir_p(File.join(root, "_posts"))
      build(root, site, origin: "https://psychiatrypapers.org", base_path: "")
      empty = File.read(File.join(site, "psychosis/latest/index.html"))
      assert(empty.include?('data-latest-target="/psychosis-psychoeducation/"'), "Empty series shortcut must fall back to its own home")
      assert(empty.include?("The first issue is forthcoming."), "Empty series needs an honest state")
      issue(root, "first-and-latest")
      build(root, site, origin: "https://psychiatrypapers.org", base_path: "")
      article = File.read(File.join(site, "2020/01/01/first-and-latest.html"))
      assert(article.include?('class="issue-status">Latest issue'), "Only issue must be identified as latest")
      assert(!article.include?('rel="prev"') && !article.include?('rel="next"'), "Single-issue series must not invent neighbors")
      redirect = File.read(File.join(site, "psychosis/latest/index.html"))
      assert(redirect.include?('data-latest-target="/2020/01/01/first-and-latest.html"'), "Custom-domain shortcut has a stale project subpath")
      assert(redirect.include?('href="https://psychiatrypapers.org/2020/01/01/first-and-latest.html"'), "Latest canonical URL has the wrong origin")
    end
  }
}

checks.each do |name, check|
  check.call
  puts "PASS #{name}"
end
puts "All #{checks.size} editorial and reader-navigation scenarios passed. No website was deployed."
