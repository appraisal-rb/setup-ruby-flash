# gfgo-git-ref Feature Implementation Summary

## Overview

The `gfgo-git-ref` feature allows building gemfile-go from source when building ore from source. This enables testing unreleased gemfile-go features alongside unreleased ore features.

## Implementation Approach

Following the recommended Go workspace approach, the implementation:

1. **Uses `go.work` workspace** - Clean, standard Go approach for multi-repo development
2. **No go.mod modifications** - Avoids accidental commits of replace directives
3. **Automatic in CI** - Checkouts and workspace setup handled by the action
4. **Optional for local dev** - Developers can create go.work manually if needed

## Changes Made

### 1. action.yml

- **Added `gfgo-git-ref` input** - Accepts git branch, tag, commit SHA, or fork syntax (`owner:ref`)
- **Updated ore cache key** - Includes gfgo-git-ref to prevent cache collisions
- **Enhanced build process** - Checks out gemfile-go and creates go.work workspace when gfgo-git-ref is set

### 2. .gitignore

- **Added go.work and go.work.sum** - Prevents accidental commits of local development files

### 3. Documentation

#### GIT_REF_FEATURE.md
- Added `gfgo-git-ref` input documentation
- Added Example 3a showing ore + gemfile-go from source
- Added "How It Works" section explaining go.work approach
- Added "Local Development with gemfile-go" section
- Updated caching strategy documentation

#### README.md
- Added `gfgo-git-ref` to inputs table
- Added example showing ore + gemfile-go feature branches
- Added "Developing with Local gemfile-go" section to Development

### 4. CI Workflow (.github/workflows/ci.yml)

- **Added `test-gfgo-git-ref` job** - Tests building ore with gemfile-go from main branch
- Runs on both ubuntu-latest and macos-latest
- Verifies ore installation and gem management work correctly

## Usage Examples

### Basic Usage

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "4.0"
    ore-install: true
    ore-git-ref: "main"
    gfgo-git-ref: "main"
```

### Testing Feature Branches

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "4.0"
    ore-install: true
    ore-git-ref: "feat/new-ore-feature"
    gfgo-git-ref: "feat/gemfile-go-enhancement"
```

### Testing Forks

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "4.0"
    ore-install: true
    ore-git-ref: "yourname:feat/ore-fix"
    gfgo-git-ref: "yourname:feat/gfgo-parser"
```

## How It Works

When both `ore-git-ref` and `gfgo-git-ref` are set:

1. **Setup Go toolchain** (if not already done for ore)
2. **Clone ore-light** from specified ref/fork
3. **Clone gemfile-go** from specified ref/fork
4. **Create go.work** in ore build directory:
   ```bash
   go work init .
   go work use /tmp/gemfile-go-build
   ```
5. **Build ore** - Go automatically uses the workspace
6. **Install and cache** ore binary
7. **Cleanup** temporary build directories

## Benefits

### For CI/CD
- Test unreleased features before formal releases
- Validate compatibility between ore and gemfile-go changes
- Reproducible builds with commit SHAs
- Fast cached builds on subsequent runs

### For Development
- No go.mod pollution
- Standard Go workspace approach
- Easy to enable/disable (just add/remove go.work)
- Works same way in CI and locally

### For Security
- Fork syntax allows testing security patches before merge
- Commit SHA pinning ensures reproducibility
- Separate cache keys prevent cross-contamination

## Cache Strategy

Cache keys include both ore-git-ref and gfgo-git-ref:

```
setup-ruby-flash-ore-<platform>-<ore-ref>-true-gfgo-<gfgo-ref>
```

Examples:
- `setup-ruby-flash-ore-linux-amd64-main-true-gfgo-main`
- `setup-ruby-flash-ore-darwin-arm64-feat/new-feature-true-gfgo-feat/parser`
- `setup-ruby-flash-ore-linux-amd64-main-true-gfgo-` (when gfgo-git-ref not set)

## Local Development

Developers can create a go.work file locally:

```bash
cd /path/to/ore-light
go work init .
go work use ../gemfile-go

# Build with local gemfile-go
go build -o ore ./cmd/ore
```

The go.work file is gitignored, so it won't be committed.

## Requirements

- `gfgo-git-ref` only takes effect when `ore-git-ref` is also set
- Requires Go toolchain (automatically installed)
- Both ore-light and gemfile-go must have compatible Go module structures

## Performance

### First Build (no cache)
- ore: ~1-2 minutes
- ore + gemfile-go: ~2-3 minutes (additional checkout and workspace setup)

### Cached Builds
- ~1-2 seconds (cache restore)

## Testing

The CI workflow includes a dedicated `test-gfgo-git-ref` job that:
1. Tests on Ubuntu and macOS
2. Builds ore from main with gemfile-go from main
3. Verifies ore installation works
4. Tests gem installation and management

## Future Enhancements

Possible improvements:
- Add gfgo-version input for using specific gemfile-go releases
- Support workspace with multiple gem parsers if ore architecture evolves
- Add troubleshooting guide for go.work issues
- Document performance characteristics in more detail
