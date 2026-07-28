# Elapsed Time Tracking Feature

## Overview

setup-ruby-flash now tracks elapsed time for all major build and install operations, providing visibility into performance and helping identify bottlenecks.

## Tracked Operations

### 1. rv Build from Source
**Step:** `Build rv from source`  
**Output:** `steps.build-rv.outputs.build-time`  
**Includes:** Git clone, checkout, Rust compilation, binary installation

**When tracked:** Only when `rv-git-ref` is set and rv is built from source

### 2. rv Install from Release
**Step:** `Install rv from release`  
**Output:** `steps.install-rv.outputs.install-time`  
**Includes:** Download, extraction, installation

**When tracked:** When rv is installed from a release (not building from source)

### 3. Ruby Installation
**Step:** `Install Ruby`  
**Output:** `steps.install-ruby.outputs.install-time`  
**Includes:** Cache pre-seeding, rv ruby install command (with retries)

**When tracked:** When Ruby is installed (not from cache)

### 4. gemfile-go Build from Source
**Step:** `Build ore from source` (sub-timing)  
**Output:** `steps.build-ore.outputs.gfgo-build-time`  
**Includes:** Git clone, checkout, go.work setup

**When tracked:** Only when both `ore-git-ref` and `gfgo-git-ref` are set

### 5. ore Build from Source
**Step:** `Build ore from source`  
**Output:** `steps.build-ore.outputs.build-time`  
**Includes:** Git clone, checkout, Go compilation, binary installation, gemfile-go setup (if applicable)

**When tracked:** Only when `ore-git-ref` is set and ore is built from source

### 6. Gem Installation
**Step:** `Install gems with rv` or `Install gems with ore`
**Output:** Displayed in summary as "Gem Install Time"
**Includes:** `rv clean-install` for `bundler-cache`, or `ore install` for the explicit ore path

**When tracked:** Always when `bundler-cache: true` or `ore-install: true`

### 7. Compatibility Setup (ruby/setup-ruby)
**Steps:** `Start ruby/setup-ruby compatibility timer` → `Setup Ruby with ruby/setup-ruby` → `End ruby/setup-ruby compatibility timer`
**Output:** `steps.fallback-end.outputs.elapsed`
**Includes:** Complete ruby/setup-ruby action execution

**When tracked:** Only when the ruby/setup-ruby compatibility path is used

## Summary Display

All timing information is displayed in the GitHub Actions step summary:

### Fast Path (rv + gem installation)

```markdown
### setup-ruby-flash Summary ⚡

| Component | Value |
|-----------|-------|
| Ruby Version | 3.4 |
| RubyGems Version | 3.5.0 |
| Bundler Version | 2.5.0 |
| rv Version | 0.4.1 |
| Gem Manager | rv clean-install |
| Platform | linux-amd64 |
| Gem Cache Hit | false |
| rv Install Time | 2s |
| Ruby Install Time | 8s |
| Gem Install Time | 45s |
```

### With Build from Source

```markdown
### setup-ruby-flash Summary ⚡

| Component | Value |
|-----------|-------|
| Ruby Version | 3.4 |
| RubyGems Version | 3.5.0 |
| Bundler Version | 2.5.0 |
| rv Version | main |
| ore Version | feat/new-feature |
| Platform | linux-amd64 |
| Gem Cache Hit | false |
| rv Build Time | 180s |
| Ruby Install Time | 8s |
| gemfile-go Build Time | 12s |
| ore Build Time | 65s |
| Gem Install Time | 45s |
```

### Compatibility Path

When using the ruby/setup-ruby compatibility path, setup-ruby-flash writes its own summary with the selected path and elapsed time. The elapsed time is also logged:

```
ruby/setup-ruby compatibility path completed in 35s
```

## Implementation Details

### Timing Mechanism

All timing uses Unix timestamps:

```bash
START_TIME=$(date +%s)
# ... operation ...
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
echo "operation-time=$ELAPSED" >> $GITHUB_OUTPUT
```

### Output Strategy

- Each timed step has an `id` to make outputs accessible
- Timing is stored as step outputs for use in summaries
- Times are displayed in seconds (integer)

### Conditional Display

Timing information only appears in summaries when:
1. The operation actually ran (not cached)
2. The operation completed successfully
3. The output is available

Example:
```bash
if [ -n "${{ steps.build-rv.outputs.build-time }}" ]; then
  echo "| rv Build Time | ${{ steps.build-rv.outputs.build-time }}s |" >> $GITHUB_STEP_SUMMARY
fi
```

## Usage Examples

### Monitoring Build Performance

When testing changes that might affect build times:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-git-ref: "feat/optimization"
    gfgo-git-ref: "feat/parser-speedup"
```

Check the summary to see:
- gemfile-go Build Time
- ore Build Time
- Total impact on workflow

### Comparing Cache vs No Cache

**First run (no cache):**
```
rv Install Time: 2s
Ruby Install Time: 8s
ore Build Time: 65s (if building from source)
Gem Install Time: 45s
```

**Second run (cached):**
```
Ruby Cache Hit: true
Gem Cache Hit: true
(No install times - everything restored from cache)
```

### Debugging Slow Installs

If a workflow is slow, check the summary:
- High Ruby Install Time? Check network/rv issues
- High Gem Install Time? Large dependencies or compilation
- High Build Times? Consider using releases instead

## Performance Baselines

### Typical Times (Non-Cached)

| Operation | Typical Time | Notes |
|-----------|-------------|-------|
| rv Install | 1-3s | Download + extract binary |
| rv Build | 150-300s | Full Rust compilation |
| Ruby Install | 5-15s | Download + extract Ruby tarball |
| ore Install | 1-2s | Download ore binary (not tracked yet) |
| ore Build | 30-90s | Go compilation |
| gemfile-go Setup | 5-20s | Clone + workspace setup |
| Gem Install | 20-120s | Depends on gem count/complexity |
| Compatibility path (ruby/setup-ruby) | 30-60s | Ruby compilation on first run |

### Cached Times

All cached operations: ~1-2s (cache restore only)

## Accessing Timing Data

### In Workflow Steps

```yaml
- name: Report timing
  run: |
    echo "rv build took: ${{ steps.build-rv.outputs.build-time }}s"
    echo "ore build took: ${{ steps.build-ore.outputs.build-time }}s"
```

### In Subsequent Jobs

Timing outputs are only available within the same job. To pass to other jobs:

```yaml
jobs:
  setup:
    outputs:
      rv-build-time: ${{ steps.build-rv.outputs.build-time }}
    steps:
      - uses: appraisal-rb/setup-ruby-flash@v1
        # ...
  
  report:
    needs: setup
    steps:
      - run: echo "rv built in ${{ needs.setup.outputs.rv-build-time }}s"
```

## Future Enhancements

Potential improvements:
1. Track ore install from release time
2. Add timing for RubyGems/Bundler installation
3. Aggregate total setup time
4. Add timing comparison between runs
5. Detect and warn about unusually slow operations

## Troubleshooting

### Timing Not Appearing in Summary

**Cause:** Operation was cached or didn't run  
**Solution:** Expected behavior - cached operations don't show timing

### Timing Seems Wrong

**Cause:** Includes all retries and wait times  
**Check:** Look at the step logs for retry messages

### Want More Granular Timing

**Solution:** Add additional timing blocks in the specific operation you want to measure

## Benefits

1. **Performance Visibility**: See exactly where time is spent
2. **Optimization Opportunities**: Identify slow operations
3. **Debugging**: Diagnose slow workflows
4. **Comparison**: Compare build-from-source vs release
5. **Documentation**: Real data for performance claims

## Summary

Elapsed time tracking provides comprehensive visibility into setup-ruby-flash performance, helping users understand, optimize, and debug their workflows. All major operations are tracked, and timing is displayed clearly in the GitHub Actions summary.
