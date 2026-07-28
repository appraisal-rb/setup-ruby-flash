# Automatic Compatibility Path to ruby/setup-ruby

## Overview

setup-ruby-flash automatically uses the [ruby/setup-ruby](https://github.com/ruby/setup-ruby) compatibility path for Ruby versions and implementations that are not supported by rv and ore. This enables true drop-in replacement behavior where you can use setup-ruby-flash everywhere and get the best performance where available, with the expected setup-ruby path for versions like ruby-head.

## Supported vs Unsupported Configurations

### ⚡ Fast Path (rv + ore)

These configurations use the optimized rv and ore tools:

- **Ruby 3.2** (MRI)
- **Ruby 3.3** (MRI)
- **Ruby 3.4** (MRI)
- **Ruby 4.0** (MRI)
- **Platforms**: Linux (x86_64, ARM64), macOS (x86_64, ARM64)

### 🔄 Compatibility Path (ruby/setup-ruby)

These configurations automatically use ruby/setup-ruby:

- **Ruby versions other than 3.2, 3.3, 3.4, 4.0**: Includes 2.7, 3.0, 3.1, 3.5+, head, etc.
- **Non-MRI implementations**: JRuby, TruffleRuby, mruby, Rubinius, etc.
- **Windows**: All Ruby versions on Windows
- **Unsupported architectures**: i686, ppc64le, etc.

## How It Works

### Detection Logic

The action uses a **allowlist approach** - only explicitly supported versions use the fast path:

```yaml
1. Parse ruby-version input (including reading from version files)
2. Check if it's a non-MRI implementation (jruby, truffleruby, etc.)
3. Check if version matches 3.2, 3.3, 3.4, or 4.0 (with or without patch versions)
4. If not allowlisted: use ruby/setup-ruby
5. If allowlisted: proceed with rv + ore
```

This means any version not explicitly in the allowlist (like `ruby-head`, `3.5`, `2.7`) will use the ruby/setup-ruby compatibility path.

### User Experience

When the compatibility path is selected, you'll see an informative notice in the workflow logs:

```
::notice::Selected ruby/setup-ruby compatibility path for Ruby version '3.1' because rv fast path currently supports: 3.2 3.3 3.4 4.0.
```

or

```
::notice::Selected ruby/setup-ruby compatibility path for Ruby version 'jruby-9.4' because rv fast path currently supports: 3.2 3.3 3.4 4.0.
```

All subsequent steps in the workflow continue normally - the compatibility path is transparent.

## Usage Examples

### Example 1: Matrix Build Across All Ruby Versions

Test your gem across all supported Ruby versions automatically:

```yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    strategy:
      fail-fast: false
      matrix:
        ruby: ['2.7', '3.0', '3.1', '3.2', '3.3', '3.4', '4.0']
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      
      - name: Setup Ruby
        uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          bundler-cache: true
      
      # Ruby 2.7, 3.0, 3.1: automatic ruby/setup-ruby compatibility path
      # Ruby 3.2, 3.3, 3.4, 4.0: fast path with rv + ore
      
      - name: Run tests
        run: bundle exec rake test
```

### Example 2: Testing Alternative Ruby Implementations

Test on JRuby, TruffleRuby, or other implementations:

```yaml
jobs:
  test:
    strategy:
      matrix:
        ruby: 
          - '3.4'              # Fast path
          - 'jruby-9.4'        # Automatic compatibility path
          - 'truffleruby-24'   # Automatic compatibility path
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      
      - uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          bundler-cache: true
      
      - run: bundle exec rake test
```

### Example 3: Multi-Platform Testing

Test across platforms, including Windows:

```yaml
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        ruby: ['3.2', '3.3', '3.4']
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v5
      
      - uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          bundler-cache: true
      
      # Linux & macOS: fast path
      # Windows: automatic compatibility path (platform detection happens first)
      
      - run: bundle exec rake test
```

### Example 4: Supporting Legacy Applications

Gradually migrate from older Ruby versions:

```yaml
jobs:
  test:
    strategy:
      matrix:
        ruby: ['3.1', '3.2', '3.3']  # Mix old and new
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      
      - uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          bundler-cache: true
      
      # Ruby 3.1: compatibility path
      # Ruby 3.2, 3.3: fast path
      
      - run: bundle exec rake test
```

## Input Compatibility

All inputs are passed through to ruby/setup-ruby when compatibility path is selected:

| Input | Supported in Compatibility Path |
|-------|----------------------|
| `ruby-version` | ✅ Yes |
| `rubygems` | ✅ Yes |
| `bundler` | ✅ Yes |
| `working-directory` | ✅ Yes |
| `cache-version` | ✅ Yes |
| `bundler-cache` | ✅ Yes (passed through) |
| `ore-install` | ✅ Converted to `bundler-cache: true` |
| `rv-version` | ⚠️ Ignored (not applicable) |
| `rv-git-ref` | ⚠️ Ignored (not applicable) |
| `ore-version` | ⚠️ Ignored (not applicable) |
| `ore-git-ref` | ⚠️ Ignored (not applicable) |
| `gfgo-git-ref` | ⚠️ Ignored (not applicable) |
| `skip-extensions` | ⚠️ Ignored (not applicable) |
| `without-groups` | ⚠️ Ignored (not applicable) |
| `ruby-install-retries` | ⚠️ Ignored (not applicable) |
| `no-document` | ⚠️ Ignored (not applicable) |
| `token` | ✅ Yes |

## Migration Guide

### From ruby/setup-ruby to setup-ruby-flash

Simply replace the action name - no other changes needed:

**Before:**
```yaml
- uses: ruby/setup-ruby@v1
  with:
    ruby-version: '3.3'
    bundler-cache: true
```

**After:**
```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.3'
    bundler-cache: true
```

### Matrix Builds

No changes needed - just replace the action:

**Before:**
```yaml
- uses: ruby/setup-ruby@v1
  with:
    ruby-version: ${{ matrix.ruby }}
    bundler-cache: true
```

**After:**
```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: ${{ matrix.ruby }}
    bundler-cache: true
```

## Performance Comparison

### Ruby 3.4 on Ubuntu (Fast Path)

- **First run**: ~5-10 seconds
- **Cached run**: ~1-2 seconds
- **With ore-install**: gem installation ~50% faster

### Ruby 3.1 on Ubuntu (Compatibility Path)

- **First run**: ~30-60 seconds (compilation)
- **Cached run**: ~5-10 seconds
- **Gem installation**: standard Bundler speed

### Recommendation

For projects that need to support both old and new Ruby versions:

1. Use setup-ruby-flash everywhere
2. Get automatic performance benefits on Ruby 3.2+
3. Get automatic compatibility on older versions
4. No conditional logic needed in your workflows

## Troubleshooting

### How do I know if the compatibility path is being used?

Check the workflow logs for the notice message:

```
::notice::Selected ruby/setup-ruby compatibility path for Ruby version '3.1' because rv fast path currently supports: 3.2 3.3 3.4 4.0.
```

### Can I force the compatibility path for testing?

Yes, just specify an unsupported Ruby version:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.1'  # Will use the compatibility path
```

### Can I disable the compatibility path?

No - the compatibility path is automatic and cannot be disabled. If you only want to support Ruby 3.2+, specify that in your matrix configuration:

```yaml
matrix:
  ruby: ['3.2', '3.3', '3.4']  # No compatibility path needed
```

### Does the compatibility path work with gem installation?

When compatibility path is selected, both `ore-install` and `bundler-cache` are converted to
`bundler-cache: true` and passed to ruby/setup-ruby. This ensures compatibility
for Ruby versions and engines that rv does not support.

### What's the difference between ore-install and bundler-cache?

They both enable gem installation, but they are not aliases:
- **Fast path (Ruby 3.2+)**: `bundler-cache` uses rv's native
  `clean-install` with gem caching and retries
- **Ore path**: `ore-install` explicitly installs ore and runs `ore install`
- **Compatibility path**: both convert to `bundler-cache: true` for ruby/setup-ruby

## Implementation Details

### Detection Code

The action uses a simple **dual-allowlist approach** supporting both numeric and special versions:

```bash
# Allowlists of supported Ruby versions (update these as rv adds support)
# Numeric MRI versions (major.minor format)
SUPPORTED_NUMERIC_VERSIONS="3.2 3.3 3.4 4.0"
# Special versions and alternative implementations
SUPPORTED_SPECIAL_VERSIONS=""  # e.g., "head jruby truffleruby" when rv supports them

# Default to the compatibility path unless version is in allowlist
USE_FALLBACK="true"

# First check special versions (head, jruby-*, truffleruby-*, etc.)
if [ -n "$SUPPORTED_SPECIAL_VERSIONS" ]; then
  for allowed_version in $SUPPORTED_SPECIAL_VERSIONS; do
    if [[ "$RUBY_VERSION" == $allowed_version* ]]; then
      USE_FALLBACK="false"
      break
    fi
  done
fi

# If not found, check numeric versions
if [ "$USE_FALLBACK" = "true" ]; then
  VERSION_PREFIX=$(echo "$RUBY_VERSION" | grep -oE '^[0-9]+\.[0-9]+')
  if [ -n "$VERSION_PREFIX" ]; then
    for allowed_version in $SUPPORTED_NUMERIC_VERSIONS; do
      if [ "$VERSION_PREFIX" = "$allowed_version" ]; then
        USE_FALLBACK="false"
        break
      fi
    done
  fi
fi
```

**Adding support for new versions is trivial:**
- Numeric versions (e.g., Ruby 4.1): Add to `SUPPORTED_NUMERIC_VERSIONS="3.2 3.3 3.4 4.0 4.1"`
- Special versions (e.g., head, jruby): Add to `SUPPORTED_SPECIAL_VERSIONS="head jruby truffleruby"`

### Conditional Step Execution

All rv/ore-specific steps are conditional on `use-fallback != 'true'`:

```yaml
- name: Install Ruby
  if: steps.check-support.outputs.use-fallback != 'true'
  # ... rv installation logic
```

### Compatibility Step

When the compatibility path is needed, ruby/setup-ruby is invoked:

```yaml
- name: Setup Ruby with ruby/setup-ruby (compatibility path)
  if: steps.check-support.outputs.use-fallback == 'true'
  uses: ruby/setup-ruby@v1
  with:
    ruby-version: ${{ inputs.ruby-version }}
    # ... other inputs
```

## Benefits

1. **Simplified Workflows**: One action for all Ruby versions
2. **Best Performance**: Automatic optimization where available
3. **Full Compatibility**: Works with any Ruby version/implementation
4. **No Breaking Changes**: Drop-in replacement for ruby/setup-ruby
5. **Future Proof**: As rv/ore add support for more versions, you automatically get the benefits

## Limitations

- The compatibility path uses compilation (slower first run) for older Ruby versions
- ore-install feature not available when using the compatibility path
- Some advanced setup-ruby-flash features are unavailable in compatibility mode

## See Also

- [Main README](README.md) - General usage and features
- [GIT_REF_FEATURE.md](GIT_REF_FEATURE.md) - Building from source
- [ruby/setup-ruby](https://github.com/ruby/setup-ruby) - The compatibility action
