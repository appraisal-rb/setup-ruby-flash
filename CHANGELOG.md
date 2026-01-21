# setup-ruby-flash Changelog Entry

## [Unreleased]

### Added

- **Build from Source Support**: New `rv-git-ref` and `ore-git-ref` inputs allow building rv and ore from git branches, tags, or commits instead of using release binaries
  - `rv-git-ref`: Build rv from any git reference (requires Rust, automatically installed)
  - `ore-git-ref`: Build ore from any git reference (requires Go 1.24, automatically installed)
  - **Fork Support**: Use `owner:ref` syntax to build from a fork (e.g., `pboling:feat/github-token-authenticated-requests`)
  - Enables testing unreleased versions without creating formal releases
  - Supports branches (`main`), tags (`v0.5.0-beta`), commit SHAs, and forks (`owner:branch`)
  - Built binaries are cached by git ref for fast subsequent runs
  - When git ref is set, corresponding version input (`rv-version`, `ore-version`) is ignored
  - **Use Case**: Test PRs, feature branches, bug fixes, and fork changes before release
  - **Performance**: First build 3-5 min (rv) or 1-2 min (ore); cached builds ~1-2 sec
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

- Cache keys now include `build-from-source` flag to prevent collision between git refs and release versions
- Improved version resolution to handle both release versions and git references
- **Bundler Installation Optimization**: Skip Bundler installation when `rubygems: latest` is used, as the latest RubyGems includes the latest Bundler (they are always released together)

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
