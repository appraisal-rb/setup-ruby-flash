# Automatic Fallback to ruby/setup-ruby

## Overview

setup-ruby-flash automatically falls back to [ruby/setup-ruby](https://github.com/ruby/setup-ruby) for Ruby versions and implementations that are not supported by rv and ore. This enables true drop-in replacement behavior where you can use setup-ruby-flash everywhere and get the best performance where available, with full compatibility as a fallback.

## Supported vs Unsupported Configurations

### ⚡ Fast Path (rv + ore)

These configurations use the optimized rv and ore tools:

- **Ruby 3.2** (MRI)
- **Ruby 3.3** (MRI)
- **Ruby 3.4** (MRI)
- **Ruby 4.0** (MRI)
- **Platforms**: Linux (x86_64, ARM64), macOS (x86_64, ARM64)

### 🔄 Fallback Path (ruby/setup-ruby)

These configurations automatically fall back to ruby/setup-ruby:

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

This means any version not explicitly in the allowlist (like `head`, `3.5`, `2.7`) will use fallback.

### User Experience

When fallback occurs, you'll see an informative notice in the workflow logs:

```
::notice::Ruby version '3.1' is not supported by setup-ruby-flash (requires 3.2+). Falling back to ruby/setup-ruby.
```

or

```
::notice::Ruby implementation 'jruby-9.4' is not supported by setup-ruby-flash. Falling back to ruby/setup-ruby.
```

All subsequent steps in the workflow continue normally - the fallback is transparent.

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
      
      # Ruby 2.7, 3.0, 3.1: automatic fallback to ruby/setup-ruby
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
          - 'jruby-9.4'        # Automatic fallback
          - 'truffleruby-24'   # Automatic fallback
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
      # Windows: automatic fallback (platform detection happens first)
      
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
      
      # Ruby 3.1: fallback
      # Ruby 3.2, 3.3: fast path
      
      - run: bundle exec rake test
```

## Input Compatibility

All inputs are passed through to ruby/setup-ruby when fallback occurs:

| Input | Supported in Fallback |
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
    bundler-cache: true  # or ore-install: true for even faster installs
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
    bundler-cache: true  # or ore-install: true
```

## Performance Comparison

### Ruby 3.4 on Ubuntu (Fast Path)

- **First run**: ~5-10 seconds
- **Cached run**: ~1-2 seconds
- **With ore-install**: gem installation ~50% faster

### Ruby 3.1 on Ubuntu (Fallback)

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

### How do I know if fallback is being used?

Check the workflow logs for the notice message:

```
::notice::Ruby version '3.1' is not supported by setup-ruby-flash (requires 3.2+). Falling back to ruby/setup-ruby.
```

### Can I force fallback for testing?

Yes, just specify an unsupported Ruby version:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.1'  # Will use fallback
```

### Can I disable fallback?

No - fallback is automatic and cannot be disabled. If you only want to support Ruby 3.2+, specify that in your matrix configuration:

```yaml
matrix:
  ruby: ['3.2', '3.3', '3.4']  # No fallback needed
```

### Does fallback work with ore-install?

oWhen fallback occurs, both `ore-install` and `bundler-cache` are converted to `bundler-cache: true` and passed to ruby/setup-ruby. This ensures compatibility.

### What's the difference between ore-install and bundler-cache?

They're aliases - both enable gem caching and installation:
- **Fast path (Ruby 3.2+)**: Both use ore for gem installation
- **Fallback path**: Both convert to `bundler-cache: true` for ruby/setup-ruby
- Use whichever name you prefer for clarity in your workflows

## Implementation Details

### Detection Code

The action uses a **allowlist approach** - checking if the version is in the supported list:

```bash
# Check if this is a non-MRI implementation
if [[ "$RUBY_VERSION" =~ ^(jruby|truffleruby|rbx|ree|maglev|mruby|topaz) ]]; then
  USE_FALLBACK="true"
# Allowlist: ONLY support MRI Ruby 3.2, 3.3, 3.4, 4.0
elif [[ "$RUBY_VERSION" =~ ^3\.2($|\.) ]] || \
     [[ "$RUBY_VERSION" =~ ^3\.3($|\.) ]] || \
     [[ "$RUBY_VERSION" =~ ^3\.4($|\.) ]] || \
     [[ "$RUBY_VERSION" =~ ^4\.0($|\.) ]]; then
  # Supported version - use fast path
  USE_FALLBACK="false"
else
  # Any other version (head, 3.5, 2.7, etc.) - use fallback
  USE_FALLBACK="true"
fi
```

This ensures that only the specific versions rv supports will use the fast path.

### Conditional Step Execution

All rv/ore-specific steps are conditional on `use-fallback != 'true'`:

```yaml
- name: Install Ruby
  if: steps.check-support.outputs.use-fallback != 'true'
  # ... rv installation logic
```

### Fallback Step

When fallback is needed, ruby/setup-ruby is invoked:

```yaml
- name: Setup Ruby with ruby/setup-ruby (fallback)
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

- Fallback uses compilation (slower first run) for older Ruby versions
- ore-install feature not available when using fallback
- Some advanced setup-ruby-flash features unavailable in fallback mode

## See Also

- [Main README](README.md) - General usage and features
- [GIT_REF_FEATURE.md](GIT_REF_FEATURE.md) - Building from source
- [ruby/setup-ruby](https://github.com/ruby/setup-ruby) - The fallback action
