# Building rv and ore from Source - Feature Documentation

## Overview

setup-ruby-flash now supports building `rv` and `ore` from git branches, tags, or commits instead of using released binaries. This enables testing unreleased versions without creating formal releases.

## New Inputs

### `rv-git-ref`

**Description**: Git branch, tag, or commit SHA to build rv from source.

**When set**: rv will be built from the specified git ref instead of using a release binary.

**Toolchain**: Rust toolchain is automatically installed if needed (via `dtolnay/rust-toolchain@stable`)

**Examples**:

- `'main'` - Build from main branch
- `'feat/new-feature'` - Build from feature branch
- `'v0.5.0-beta'` - Build from pre-release tag
- `'abc123'` - Build from specific commit

**Default**: `''` (empty - uses release binary)

**Overrides**: When set, `rv-version` input is ignored

### `ore-git-ref`

**Description**: Git branch, tag, or commit SHA to build ore from source.

**When set**: ore will be built from the specified git ref instead of using a release binary.

**Toolchain**: Go toolchain is automatically installed if needed (via `actions/setup-go@v5` with `stable`)

**Examples**:

- `'main'` - Build from main branch
- `'feat/bundle-gemfile-support'` - Build from feature branch
- `'v0.19.0-alpha'` - Build from pre-release tag
- `'def456'` - Build from specific commit

**Default**: `''` (empty - uses release binary)

**Overrides**: When set, `ore-version` input is ignored

## Usage Examples

### Example 1: Test BUNDLE_GEMFILE Fix in ore-light

```yaml
name: Test ore BUNDLE_GEMFILE fix

on: [push, pull_request]

jobs:
  test-ore-fix:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6

      - name: Setup Ruby with ore from feature branch
        uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: "3.4"
          ore-install: true
          ore-git-ref: "feat/bundle-gemfile-support" # Build from feature branch

      - name: Verify ore respects BUNDLE_GEMFILE
        env:
          BUNDLE_GEMFILE: Appraisal.root.gemfile
        run: |
          ore install
          # Should use Appraisal.root.gemfile instead of Gemfile
```

### Example 2: Test rv Pre-release

```yaml
name: Test rv beta

on: [push]

jobs:
  test-rv-beta:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6

      - name: Setup Ruby with rv beta
        uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: "3.4"
          rv-git-ref: "v0.5.0-beta1" # Build from beta tag

      - name: Test with beta rv
        run: |
          rv --version
          ruby --version
```

### Example 3: Test Both from Source

```yaml
name: Test unreleased rv and ore

on: [workflow_dispatch]

jobs:
  test-both:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6

      - name: Setup with unreleased versions
        uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: "3.4"
          rv-git-ref: "main" # Latest rv from main
          ore-install: true
          ore-git-ref: "main" # Latest ore from main

      - name: Verify installations
        run: |
          rv --version
          ore --version
          ruby --version
```

### Example 4: Test Specific Commit

```yaml
name: Test specific commit

on: [push]

jobs:
  test-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6

      - name: Setup with specific ore commit
        uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: "3.4"
          ore-install: true
          ore-git-ref: "a1b2c3d4e5f6" # Specific commit SHA
```

## How It Works

### Build Process Flow

#### For rv (Rust)

1. **Cache Check**: Checks if binary for this git ref is cached
2. **Rust Setup**: If not cached and `rv-git-ref` is set, installs Rust toolchain
3. **Clone & Build**:

   ```bash
   git clone --depth 1 https://github.com/spinel-coop/rv.git
   git checkout <rv-git-ref>  # fetches ref if needed
   cargo build --release
   cp target/release/rv ~/.local/bin/rv
   rm -rf /tmp/rv-build  # cleanup
   ```

4. **Cache Store**: Binary is cached for subsequent runs

#### For ore (Go)

1. **Cache Check**: Checks if binary for this git ref is cached
2. **Go Setup**: If not cached and `ore-git-ref` is set, installs Go (stable)
3. **Clone & Build**:

   ```bash
   git clone --depth 1 https://github.com/contriboss/ore-light.git
   git checkout <ore-git-ref>  # fetches ref if needed
   go build -o ore ./cmd/ore
   cp ore ~/.local/bin/ore
   rm -rf /tmp/ore-build  # cleanup
   ```

4. **Cache Store**: Binary is cached for subsequent runs

### Caching Strategy

**Cache Key Format**:

- rv: `setup-ruby-flash-rv-<platform>-<git-ref>-true`
- ore: `setup-ruby-flash-ore-<platform>-<git-ref>-true`

**Benefits**:

- Git refs are cached separately from release versions
- Same git ref on same platform reuses cached binary
- `build-from-source=true` flag prevents collision with release binaries

**Example Cache Keys**:

- `setup-ruby-flash-rv-linux-amd64-main-true`
- `setup-ruby-flash-ore-darwin-arm64-feat/bundle-gemfile-support-true`
- `setup-ruby-flash-rv-linux-arm64-v0.5.0-beta-true`

## Performance Considerations

### First Run (No Cache)

**With git ref** (builds from source):

- rv: ~3-5 minutes (Rust compilation)
- ore: ~1-2 minutes (Go compilation)

**With release** (downloads binary):

- rv: ~5-10 seconds
- ore: ~5-10 seconds

### Subsequent Runs (Cached)

**Same for both**:

- rv: ~1-2 seconds (cache restore)
- ore: ~1-2 seconds (cache restore)

### Recommendations

1. **Use git refs for testing only** - Not recommended for production CI
2. **Prefer release versions for speed** - When possible
3. **Cache hits are fast** - Once built, git refs are as fast as releases
4. **Pin commits for stability** - Use commit SHAs instead of branch names if consistency matters

## Build Requirements

### Automatically Installed When Needed

#### For rv

- ✅ Rust toolchain (via `dtolnay/rust-toolchain@stable`)
- ✅ Cargo (comes with Rust)
- ✅ git (pre-installed on GitHub runners)

#### For ore

- ✅ Go toolchain (via `actions/setup-go@v5` with `stable`)
- ✅ git (pre-installed on GitHub runners)

### Pre-installed on Runners

- ✅ git
- ✅ Standard build tools (make, gcc, etc.)

## Troubleshooting

### Build Fails - Invalid Git Ref

**Error**:

```text
fatal: couldn't find remote ref feat/typo-branch
```

**Solution**: Verify the branch/tag exists in the repository

### Build Fails - Compilation Error

**Error**:

```text
error: could not compile `rv` (bin "rv")
```

**Solution**:

- The git ref may be broken or incompatible
- Try a different ref (e.g., latest release tag)
- Check the rv/ore repository for known issues

### Cache Not Working

**Symptom**: Builds from source every time

**Solution**:

- Verify cache key is stable (don't use dynamic values in git-ref)
- Check GitHub Actions cache limits (10GB per repo)
- Consider using commit SHA instead of branch name for stability

## Comparison: Git Ref vs Release

| Aspect                | Git Ref                     | Release Binary     |
| --------------------- | --------------------------- | ------------------ |
| **Speed (first run)** | ❌ Slow (3-5 min)           | ✅ Fast (5-10 sec) |
| **Speed (cached)**    | ✅ Fast (1-2 sec)           | ✅ Fast (1-2 sec)  |
| **Use Case**          | Testing unreleased features | Production CI      |
| **Stability**         | ⚠️ May be unstable          | ✅ Stable releases |
| **Flexibility**       | ✅ Any commit/branch        | ❌ Only releases   |
| **Setup Complexity**  | ⚠️ Requires toolchain       | ✅ Simple download |

## Best Practices

### ✅ DO

- Use git refs for testing PRs and feature branches
- Use commit SHAs for reproducible builds
- Cache aggressively (same git ref = same binary)
- Document which git ref you're testing in workflow names

### ❌ DON'T

- Use git refs in production CI (slow first build)
- Use dynamic branch names that change frequently
- Forget to test with actual releases before merging
- Mix git refs and release versions without clear reason

## Migration Guide

### From Release to Git Ref

**Before**:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ore-version: "0.18.0"
    ore-install: true
```

**After**:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ore-git-ref: "feat/bundle-gemfile-support" # ore-version ignored when ore-git-ref set
    ore-install: true
```

### From Git Ref Back to Release

**Before**:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ore-git-ref: "feat/bundle-gemfile-support"
    ore-install: true
```

**After**:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ore-git-ref: "" # Clear git ref
    ore-version: "latest" # Use latest release
    ore-install: true
```

Or simply remove the `ore-git-ref` line:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ore-version: "latest"
    ore-install: true
```

## Real-World Use Case: Testing new ore feature branch

**Workflow**:

```yaml
name: Test new ore feature

on:
  push:
    branches: [main]

jobs:
  test-with-fix:
    runs-on: ubuntu-latest
    env:
      BUNDLE_GEMFILE: ${{ github.workspace }}/Appraisal.root.gemfile

    steps:
      - uses: actions/checkout@v6

      - name: Setup Ruby with ore fix
        uses: appraisal-rb/setup-ruby-flash@main
        with:
          ruby-version: "3.4"
          ore-install: true
          # Use ore with a feature before it's released
          ore-git-ref: "feat/a-good-feature"

      - name: Verify fix works
        run: |
          ore install
          test -f Appraisal.root.gemfile.lock
```

## Summary

The `rv-git-ref` and `ore-git-ref` inputs provide a powerful way to test unreleased versions of rv and ore directly in CI without creating formal releases. This is especially useful for:

- ✅ Testing PR changes before merge
- ✅ Validating bug fixes in feature branches
- ✅ Testing pre-release versions (alpha/beta tags)
- ✅ Reproducing issues with specific commits
- ✅ Developing setup-ruby-flash itself

While slower on first run, caching makes subsequent runs fast, making this a practical option for testing workflows.
