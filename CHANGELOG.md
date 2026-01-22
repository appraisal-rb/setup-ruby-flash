# setup-ruby-flash Changelog Entry

## [Unreleased]

### Added

- **bundler-cache Input**: New `bundler-cache` input for seamless compatibility with ruby/setup-ruby
  - Acts as an alias for `ore-install` - both enable gem caching and installation
  - Allows true drop-in replacement: just change action name, keep all inputs the same
  - When using fallback to ruby/setup-ruby, `bundler-cache` is passed through directly
  - Perfect for migrating from ruby/setup-ruby with zero workflow changes
  - Can be used interchangeably with `ore-install` based on preference

- **Automatic Fallback to ruby/setup-ruby**: setup-ruby-flash now automatically falls back to [ruby/setup-ruby](https://github.com/ruby/setup-ruby) for unsupported Ruby versions and implementations
  - Automatically detects Ruby version < 3.2 (2.7, 3.0, 3.1, etc.) and uses ruby/setup-ruby
  - Automatically detects non-MRI implementations (JRuby, TruffleRuby, etc.) and uses ruby/setup-ruby
  - Enables true drop-in replacement behavior - use setup-ruby-flash everywhere, get best performance where available
  - Shows informative notice when fallback occurs: `Ruby version 'X.X' is not supported by setup-ruby-flash (requires 3.2+). Falling back to ruby/setup-ruby.`
  - All inputs are passed through to ruby/setup-ruby when using fallback
  - Perfect for matrix builds that test across multiple Ruby versions (2.7 through 4.0)

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

### Changed

- **Version Detection Logic**: Changed from blacklist to allowlist approach for supported Ruby versions
  - Now explicitly checks for Ruby 3.2, 3.3, 3.4, 4.0 (with or without patch versions)
  - Ensures unsupported versions like `head`, `2.7`, etc. correctly fall back to ruby/setup-ruby
  - More maintainable and explicit about which versions are supported
- Cache keys now include `build-from-source` flag to prevent collision between git refs and release versions
- Improved version resolution to handle both release versions and git references
- **Bundler Installation Optimization**: Skip Bundler installation when `rubygems: latest` is used, as the latest RubyGems includes the latest Bundler (they are always released together)

### Fixed

- **Version Detection**: Ruby versions like `head`, `3.5`, and other unsupported versions now correctly fall back to ruby/setup-ruby instead of incorrectly attempting to use rv

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
