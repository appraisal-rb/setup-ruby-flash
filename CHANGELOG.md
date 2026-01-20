# setup-ruby-flash Changelog Entry

## [Unreleased]

### Added

- **Build from Source Support**: New `rv-git-ref` and `ore-git-ref` inputs allow building rv and ore from git branches, tags, or commits instead of using release binaries
  - `rv-git-ref`: Build rv from any git reference (requires Rust, automatically installed)
  - `ore-git-ref`: Build ore from any git reference (requires Go 1.24, automatically installed)
  - Enables testing unreleased versions without creating formal releases
  - Supports branches (`main`), tags (`v0.5.0-beta`), and commit SHAs
  - Built binaries are cached by git ref for fast subsequent runs
  - When git ref is set, corresponding version input (`rv-version`, `ore-version`) is ignored
  - **Use Case**: Test PRs, feature branches, and bug fixes before release
  - **Performance**: First build 3-5 min (rv) or 1-2 min (ore); cached builds ~1-2 sec
  - See `GIT_REF_FEATURE.md` for comprehensive documentation and examples

### Changed

- Cache keys now include `build-from-source` flag to prevent collision between git refs and release versions
- Improved version resolution to handle both release versions and git references

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
