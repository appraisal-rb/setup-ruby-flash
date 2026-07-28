# setup-ruby-flash Changelog Entry

## [Unreleased]

### Added

- **bundler-cache Input**: New `bundler-cache` input for seamless compatibility with ruby/setup-ruby
  - Uses `rv clean-install` for modern Ruby versions supported by setup-ruby-flash
  - Retries Bundler lockfile generation and rv gem installation without changing Gemfile sources
  - Allows true drop-in replacement: just change action name, keep all inputs the same
  - When using the compatibility path to ruby/setup-ruby, `bundler-cache` is passed through directly
  - Perfect for migrating from ruby/setup-ruby with zero workflow changes

- **gem-install-retries Input**: New `gem-install-retries` input controls retry attempts for dependency resolution and gem installation
  - Defaults to `4`
  - Retries keep the configured Gemfile sources, avoiding fallback to alternate gem hosts

- **Automatic Compatibility Path to ruby/setup-ruby**: setup-ruby-flash now automatically uses the [ruby/setup-ruby](https://github.com/ruby/setup-ruby) compatibility path for unsupported Ruby versions and implementations
  - Automatically detects Ruby version < 3.2 (2.7, 3.0, 3.1, etc.) and uses ruby/setup-ruby
  - Automatically detects non-MRI implementations (JRuby, TruffleRuby, etc.) and uses ruby/setup-ruby
  - Enables true drop-in replacement behavior - use setup-ruby-flash everywhere, get best performance where available
  - Shows informative notice when the compatibility path is selected: `Selected ruby/setup-ruby compatibility path for Ruby version 'X.X' because rv fast path currently supports: 3.2 3.3 3.4 4.0.`
  - All inputs are passed through to ruby/setup-ruby when using the compatibility path
  - Perfect for matrix builds that test across multiple Ruby versions (2.7 through 4.0)
  - **Manual Override Controls**: New `use-setup-ruby` and `use-setup-ruby-flash` inputs allow forcing specific versions to use one action or the other
    - `use-setup-ruby`: Force the ruby/setup-ruby compatibility path for supported versions (useful for benchmarking setup-ruby-flash vs setup-ruby)
    - `use-setup-ruby-flash`: Force flash path for unsupported versions (useful for forward compatibility when rv adds support for new versions)
    - Accepts same format as ruby-version in a matrix: `'3.4'` for single value or `['3.4', '4.0']` for array
    - Enables A/B testing and future-proofing workflows

- **Build from Source Support**: New `rv-git-ref`, `ore-git-ref`, and `gfgo-git-ref` inputs allow building rv, ore, and gemfile-go from git branches, tags, or commits instead of using release binaries
  - `rv-git-ref`: Build rv from any git reference (requires Rust, automatically installed)
  - `ore-git-ref`: Build ore from any git reference (requires Go 1.24, automatically installed)
  - `gfgo-git-ref`: Build gemfile-go from any git reference when building ore from source (requires `ore-git-ref`)
  - **Fork Support**: Use `owner:ref` syntax to build from a fork (e.g., `pboling:feat/github-token-authenticated-requests`)
  - **Go Workspace**: Uses `go.work` for gemfile-go integration - clean approach without modifying `go.mod`
  - Enables testing unreleased versions without creating formal releases
  - Supports branches (`main`), tags (`v0.5.0-beta`), commit SHAs, and forks (`owner:branch`)
  - Built binaries are cached by git ref for fast subsequent runs
  - When git ref is set, corresponding version input (`rv-version`, `ore-version`) is ignored
  - **Use Case**: Test PRs, feature branches, bug fixes, and fork changes before release
  - **Performance**: First build 3-5 min (rv), 1-2 min (ore), 2-3 min (ore+gemfile-go); cached builds ~1-2 sec
  - See `GIT_REF_FEATURE.md` for comprehensive documentation and examples

- **Documentation Control**: New `no-document` input to control gem documentation generation
  - Default: `true` (skip documentation for faster installs)
  - Set to `false` to generate ri/rdoc documentation
  - Applies `--no-document` flag to `gem install` commands
  - Applies `--silent` flag to `gem update --system` commands when enabled
  - Creates `.gemrc` with `gem: --no-document` for Bundler/ore gem installations (only if file doesn't exist)
  - Preserves existing `.gemrc` files - will not overwrite user settings
  - Significantly speeds up gem installation by skipping ri/rdoc generation

- **rv GitHub API Authentication**: rv now supports authenticated GitHub API requests
  - Checks `GITHUB_TOKEN` environment variable first (GitHub Actions)
  - Falls back to `GH_TOKEN` (GitHub CLI and general use)
  - Significantly reduces rate limiting issues when fetching Ruby releases
  - Applies to both release list fetching and Ruby tarball downloads from GitHub
  - No configuration needed - automatically uses token if available

- **Elapsed Time Tracking**: All major build and install operations now track and display elapsed time
  - Tracks rv build from source, rv install, Ruby install, ore build, gemfile-go build, gem install
  - Tracks ruby/setup-ruby total time when using automatic compatibility path
  - All times displayed in GitHub Actions step summary for easy performance monitoring
  - Helps identify bottlenecks and compare performance between runs
  - Times only shown when operations actually run (not from cache)
  - See `ELAPSED_TIME_TRACKING.md` for comprehensive documentation

### Changed

- **Setup Path Wording**: Ruby versions handled by ruby/setup-ruby, such as ruby-head, are now reported as using the ruby/setup-ruby compatibility path instead of a fallback
  - Compatibility path runs now write a setup-ruby-flash summary with selected path, reason, inputs, and elapsed setup time

- **Bundler Cache Fast Path**: `bundler-cache` no longer implies ore
  - Modern Ruby versions install gems through rv's native `clean-install`
  - `ore-install` remains available as an explicit ore integration path

- **Version Detection Logic**: Enhanced with dual-allowlist approach for maximum flexibility
  - `SUPPORTED_NUMERIC_VERSIONS="3.2 3.3 3.4 4.0"` for MRI versions (major.minor format)
  - `SUPPORTED_SPECIAL_VERSIONS=""` for special versions like head, jruby, truffleruby (empty now, ready for future)
  - Supports prefix matching for special versions (e.g., "jruby" matches "jruby-9.4", "jruby-9.5", etc.)
  - Makes it trivial to add support for new versions - just update the appropriate allowlist
  - Defaults to the compatibility path unless explicitly in an allowlist
  - More maintainable and prepared for future rv enhancements
- Cache keys now include `build-from-source` flag to prevent collision between git refs and release versions
- Improved version resolution to handle both release versions and git references
- **Bundler Installation Optimization**: Skip Bundler installation when `rubygems: latest` is used, as the latest RubyGems includes the latest Bundler (they are always released together)

### Fixed

- handle various types of ruby version specification consistently.
  - handle `ruby-*` prefix properly.
- **Version Detection**: Ruby versions like `head`, `3.5`, and other unsupported versions now correctly fall back to ruby/setup-ruby instead of incorrectly attempting to use rv
- **Ore Cache Key**: Added Ruby version to ore binary cache key to prevent using ore built with wrong Ruby version
  - Ore embeds Ruby version information at build time (for `--version` output)
  - Cache key now includes Ruby version to ensure ore is rebuilt when Ruby version changes
  - Fixes issue where ore built with Ruby 3.4.8 was being used with Ruby 4.0.1
- **Grep Exit Code**: Fixed grep command failing on non-numeric Ruby versions (jruby, head, etc.) by adding `|| true`

### Notes

- Building from source is intended for testing only; production CI should use release versions
- Rust toolchain installed automatically for rv (via `dtolnay/rust-toolchain@stable`)
- Go toolchain installed automatically for ore (via `actions/setup-go@v5` with `stable`)

---

## Usage Example

Test unreleased ore fix:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-install: true
    ore-git-ref: "feat/bundle-gemfile-support" # Build from feature branch
```

Test rv pre-release:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    rv-git-ref: "v0.5.0-beta1" # Build from beta tag
```

Test changes from your fork:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    rv-git-ref: "pboling:feat/github-token-authenticated-requests" # Build from fork
```
