[![Galtzo FLOSS Logo by Aboling0, CC BY-SA 4.0][🖼️galtzo-i]][🖼️galtzo-discord] [![Appraisal-rb Logo by Aboling0, CC BY-SA 4.0][🖼️appraisal-rb-i]][🖼️appraisal-rb] [![ruby-lang Logo, Yukihiro Matsumoto, Ruby Visual Identity Team, CC BY-SA 2.5][🖼️ruby-lang-i]][🖼️ruby-lang]

[🖼️galtzo-i]: https://logos.galtzo.com/assets/images/galtzo-floss/avatar-192px.svg
[🖼️galtzo-discord]: https://discord.gg/3qme4XHNKN
[🖼️appraisal-rb-i]: https://logos.galtzo.com/assets/images/appraisal-rb/avatar-192px.svg
[🖼️appraisal-rb]: https://github.com/appraisal-rb/
[🖼️ruby-lang-i]: https://logos.galtzo.com/assets/images/ruby-lang/avatar-192px.svg
[🖼️ruby-lang]: https://github.com/ruby-lang

# ⚡️ setup-ruby-flash

> Find out how fast my workflows can go!

- You, possibly

[![CI][ci-img]][ci] [![Runtime Heads][ci-r-heads-img]][ci-r-heads] [![GitHub tag (latest SemVer)][⛳️tag-img]][⛳️tag] [![License: MIT][📄license-img]][📄license-ref]

[⛳️tag-img]: https://img.shields.io/github/tag/appraisal-rb/setup-ruby-flash.svg
[⛳️tag]: http://github.com/appraisal-rb/setup-ruby-flash/releases
[📄license-ref]: https://opensource.org/licenses/MIT
[📄license-img]: https://img.shields.io/badge/License-MIT-259D6C.svg
[ci]: https://github.com/appraisal-rb/setup-ruby-flash/actions/workflows/ci.yml
[ci-img]: https://github.com/appraisal-rb/setup-ruby-flash/actions/workflows/ci.yml/badge.svg
[ci-r-heads]: https://github.com/appraisal-rb/setup-ruby-flash/actions/workflows/runtime-heads.yml
[ci-r-heads-img]: https://github.com/appraisal-rb/setup-ruby-flash/actions/workflows/runtime-heads.yml/badge.svg

A _fast_ GitHub Action for fast Ruby environment setup using [rv](https://github.com/spinel-coop/rv) for Ruby installation and [ore](https://github.com/contriboss/ore-light) for gem management.

**⚡ Install Ruby in under 2 seconds** — no compilation required!

**⚡ Install Gems 50% faster** — using ORE ✅️!

## Features

- 🚀 **Lightning-fast Ruby installation** via prebuilt binaries from rv
- 📦 **Rapid gem installation** with ore (Bundler-compatible, ~50% faster)
- 💾 **Intelligent caching** for both Ruby and gems
- 🔒 **Security auditing** via `ore audit`
- 🐧 **Linux & macOS support** (x86_64 and ARM64)
- ☕️ **Gitea [Actions](https://docs.gitea.com/usage/actions/overview) support**
- 🦊 **Forgejo [Actions](https://forgejo.org/docs/next/admin/actions/) support**
- 🧊 **Codeberg [Actions](https://docs.codeberg.org/ci/actions/) support**
- 🐙 **GitHub [Actions](https://github.com/marketplace/actions/setup-ruby-with-rv-and-ore) support**
- 🔄 **Automatic ruby/setup-ruby compatibility path** for Ruby versions and implementations not handled by rv

## Requirements

- **Operating Systems**: Ubuntu 22.04+, macOS 14+
- **Architectures**: x86_64, ARM64
- **Ruby Versions**: 3.2, 3.3, 3.4, 4.0 (MRI only)

### Automatic Compatibility Path

For configurations outside rv's fast path, setup-ruby-flash **automatically uses** [ruby/setup-ruby][setup-ruby]:

- **Ruby versions < 3.2** (e.g., 2.7, 3.0, 3.1)
- **Non-MRI implementations** (JRuby, TruffleRuby, etc.)
- **Windows** (via platform detection)

This means you can use setup-ruby-flash everywhere and get the best performance where available, with the expected setup-ruby path for Ruby heads and alternate engines.

| Ruby Version/Implementation | Behavior |
| --- | --- |
| Ruby 3.2, 3.3, 3.4, 4.0 (MRI) | ⚡ **Fast** - uses rv + ore |
| Ruby 2.7, 3.0, 3.1 (MRI) | 🔄 **Compatibility** - uses ruby/setup-ruby |
| JRuby, TruffleRuby, ruby-head, etc. | 🔄 **Compatibility** - uses ruby/setup-ruby |

[setup-ruby]: https://github.com/ruby/setup-ruby

## Why?

I am moving away from projects hosted by the ruby org, and sponsored by Ruby Central, to the degree that is possible.

<details>
    <summary>👣 How will this project approach the September 2025 hostile takeover of RubyGems? 🚑️</summary>

I've summarized my thoughts in [this blog post](https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo).

</details>

## Quick Start

### Basic Usage

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
```

### With Gem Installation

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    bundler-cache: true
```

### With Bundler Cache (ruby/setup-ruby compatible)

For easy migration from ruby/setup-ruby, use `bundler-cache`. On modern Ruby
versions this installs gems with `rv clean-install`, caches `vendor/bundle`,
and retries dependency resolution and installation without changing Gemfile
sources.

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    bundler-cache: true
```

### With Appraisal Setup

`pre-bundle-gems` and `pre-appraisal-root-gemfile-gems` are trusted workflow
configuration. Each non-empty line is passed as arguments to `gem install`;
they are not full shell commands.

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    main-bundle-install: false
    pre-bundle-gems: |
      nomono -v 1.1.0 --source https://gem.coop
    appraisal-root-gemfile: Appraisal.root.gemfile
    appraisal-name: ruby-3-4
    appraisal-install-retries: 2
    pre-appraisal-root-gemfile-gems: |
      nomono -v 1.1.0 --source https://gem.coop
```

### Manual Ore Commands

Install ore without running `ore install` automatically, allowing manual ore commands:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-setup: true      # Install ore binary
    ore-install: false   # Don't auto-install gems

- name: Custom ore workflow
  run: |
    ore fetch --all
    ore check --verbose
    ore list
```

### Using Version Files

When `ruby-version` is set to `default` (the default), setup-ruby-flash reads from:

- `.ruby-version`
- `.tool-versions` (asdf format)
- `mise.toml`

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    bundler-cache: true
```

## Inputs

| Input                  | Description                                                                                                                    | Default               |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------|-----------------------|
| `ruby-version`         | Ruby version to install (e.g., `3.4`, `3.4.1`). Use `ruby` for latest stable version, or `default` to read from version files. | `default`             |
| `rubygems`             | RubyGems version: `default`, `latest`, or a version number (e.g., `3.5.0`)                                                     | `default`             |
| `bundler`              | Bundler version: `Gemfile.lock`, `default`, `latest`, `none`, or a version number                                              | `Gemfile.lock`        |
| `ore-setup`            | Install ore binary: `true`, `false`, or `auto` (installs if `ore-install` is enabled)                                          | `auto`                |
| `ore-install`          | Run `ore install` command to install gems from lockfile (requires ore to be installed)                                         | `false`               |
| `bundler-cache`        | Enable gem caching and installation for ruby/setup-ruby compatibility; modern Ruby versions use `rv clean-install`             | `false`               |
| `main-bundle-install`  | Control main Gemfile bundle installation: `auto`, `true`, or `false`; use `false` for appraisal-only workflows                | `auto`                |
| `manual-compatibility-bundle` | Use the action's retrying Bundler installer after ruby/setup-ruby prepares a compatibility-path Ruby                         | `false`               |
| `working-directory`    | Directory for version files and Gemfile                                                                                        | `.`                   |
| `cache-version`        | Cache version string for invalidation                                                                                          | `v1`                  |
| `rv-version`           | Version of rv to install (ignored if `rv-git-ref` is set)                                                                      | `latest`              |
| `rv-git-ref`           | Git branch, tag, or commit SHA to build rv from source                                                                         | `''`                  |
| `ore-version`          | Version of ore to install (ignored if `ore-git-ref` is set)                                                                    | `latest`              |
| `ore-git-ref`          | Git branch, tag, or commit SHA to build ore from source                                                                        | `''`                  |
| `gfgo-git-ref`         | Git branch, tag, or commit SHA to build gemfile-go from source (requires `ore-git-ref`)                                        | `''`                  |
| `skip-extensions`      | Skip building native extensions                                                                                                | `false`               |
| `without-groups`       | Gem groups to exclude (comma-separated)                                                                                        | `''`                  |
| `ruby-install-retries` | Number of retry attempts for Ruby installation (with exponential backoff)                                                      | `3`                   |
| `gem-install-retries`  | Number of retry attempts for dependency resolution and gem installation                                                        | `4`                   |
| `pre-bundle-gems`      | Newline-separated `gem install` argument lines to run before installing the main Gemfile bundle                                | `''`                  |
| `pre-appraisal-root-gemfile-gems` | Newline-separated `gem install` argument lines to run before installing the appraisal root Gemfile bundle            | `''`                  |
| `appraisal-root-gemfile` | Root Gemfile used for appraisal setup when `appraisal-name` is set                                                           | `Appraisal.root.gemfile` |
| `appraisal-name`       | Appraisal name passed to `bundle exec appraisal <name> install`; empty disables appraisal setup                                | `''`                  |
| `appraisal-cache`      | Cache gems installed for the appraisal root Gemfile and selected appraisal                                                     | `true`                |
| `appraisal-install-retries` | Number of retry attempts for appraisal root bundle install and appraisal install                                          | `2`                   |
| `no-document`          | Skip generating documentation (ri/rdoc) for installed gems. Creates `~/.gemrc` with `gem: --no-document` if file doesn't exist | `true`                |
| `use-setup-ruby`       | Force the ruby/setup-ruby compatibility path for specific versions. Accepts single value or array: `'3.4'` or `['3.4', '4.0']`           | `''`                  |
| `use-setup-ruby-flash` | Force use of setup-ruby-flash for specific versions. Accepts single value or array: `'head'` or `['head', 'jruby']`           | `''`                  |
| `token`                | GitHub token for API calls                                                                                                     | `${{ github.token }}` |

## Outputs

| Output             | Description                           |
| ------------------ | ------------------------------------- |
| `ruby-version`     | The installed Ruby version            |
| `ruby-prefix`      | The path to the Ruby installation     |
| `rv-version`       | The installed rv version              |
| `rubygems-version` | The installed RubyGems version        |
| `bundler-version`  | The installed Bundler version         |
| `ore-version`      | The installed ore version             |
| `cache-hit`        | Whether gems were restored from cache |

## Examples

### Matrix Build

```yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest]
        ruby: ["3.2", "3.3", "3.4", "4.0"]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v5
      - uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          ore-install: true
      - run: bundle exec rake test
```

### Production Gems Only

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-install: true
    without-groups: "development,test"
```

### Latest Ruby with Latest RubyGems and Bundler

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: ruby
    rubygems: latest
    bundler: latest
    ore-install: true
```

### Specific RubyGems Version

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    rubygems: "3.5.0"
    ore-install: true
```

### Skip Native Extensions

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-install: true
    skip-extensions: true
```

### Custom Working Directory

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-install: true
    working-directory: "./my-app"
```

### Specific Tool Versions

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4.1"
    rv-version: "0.4.0"
    ore-version: "0.1.0"
    ore-install: true
```

### Custom Retry Configuration

If you experience intermittent failures due to GitHub API rate limiting, you can adjust the number of retry attempts:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ruby-install-retries: "5"
```

### Enable Documentation Generation

Include documentation (ri/rdoc) for installed gems (default skips documentation for faster installation):

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-install: true
    no-document: false
```

### Matrix Testing Across Ruby Versions (with Automatic Compatibility Path)

Test across multiple Ruby versions, including older versions that automatically use ruby/setup-ruby:

```yaml
jobs:
  test:
    strategy:
      matrix:
        ruby: ['2.7', '3.0', '3.1', '3.2', '3.3', '3.4']
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          bundler-cache: true
      # Ruby 2.7, 3.0, 3.1 use ruby/setup-ruby (automatic compatibility path)
      # Ruby 3.2, 3.3, 3.4 use rv + ore (fast path)
      - run: bundle exec rake test
```

### Testing Non-MRI Implementations

JRuby, TruffleRuby, and other implementations automatically use ruby/setup-ruby:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "jruby-9.4"  # Automatic compatibility path
    bundler-cache: true
```

### Benchmarking: Force ruby/setup-ruby for Supported Versions

Use `use-setup-ruby` to force specific supported versions to use ruby/setup-ruby for performance comparison:

```yaml
jobs:
  benchmark:
    strategy:
      matrix:
        ruby: ['3.4', '4.0']
        setup: ['flash', 'ruby']
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: appraisal-rb/setup-ruby-flash@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          bundler-cache: true
          # Force ruby/setup-ruby when setup == 'ruby'
          use-setup-ruby: ${{ matrix.setup == 'ruby' && matrix.ruby || '' }}
      - run: bundle exec rake benchmark
```

### Forward Compatibility: Force Flash for Unsupported Versions

Use `use-setup-ruby-flash` to test future rv support (e.g., when rv adds head or JRuby support):

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "head"
    bundler-cache: true
    # Attempt to use setup-ruby-flash even though 'head' isn't supported yet
    use-setup-ruby-flash: head
    # Warning: This will fail unless rv actually supports 'head'
```

### Building rv or ore from Source

You can build rv or ore from a git branch, tag, or commit SHA instead of using a released version.
This is useful for testing unreleased features or bug fixes. Required toolchains (Rust for rv, Go for ore)
are automatically installed. Fork syntax (`pboling:feat/myexperiment`) is supported to test out feature branches in forks of ore or rv.

```yaml
# Test an ore feature branch
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-install: true
    ore-git-ref: "feat/bundle-gemfile-support"

# Test a pre-release rv tag
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    rv-git-ref: "v0.5.0-beta1"

# Test both from main branches
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    rv-git-ref: "main"
    ore-install: true
    ore-git-ref: "main"

# Test ore and gemfile-go feature branches together
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-install: true
    ore-git-ref: "feat/new-feature"
    gfgo-git-ref: "feat/parser-update"
```

> **Note**: Building from source is slower on first run (~3-5 min for rv, ~1-2 min for ore) but cached for subsequent runs.
> Use release versions for production CI workflows.
> See [GIT_REF_FEATURE.md](GIT_REF_FEATURE.md) for comprehensive documentation.

## Automatic Compatibility Path

For Ruby versions < 3.2, Ruby heads, or non-MRI implementations (JRuby, TruffleRuby), setup-ruby-flash automatically uses ruby/setup-ruby. This enables true drop-in replacement behavior.

See [FALLBACK_FEATURE.md](FALLBACK_FEATURE.md) for detailed documentation on the automatic compatibility path feature.

## Migration from setup-ruby

setup-ruby-flash is a true drop-in replacement for `ruby/setup-ruby`. Simply change the action name:

```yaml
# Before (setup-ruby)
- uses: ruby/setup-ruby@v1
  with:
    ruby-version: "3.4"
    bundler-cache: true
- run: bundle exec rake test

# After (setup-ruby-flash) - No other changes needed!
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    bundler-cache: true  # Works exactly the same
- run: bundle exec rake test

# Or explicitly use ore-install when testing the ore integration
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: "3.4"
    ore-install: true
- run: bundle exec rake test
```


### With Latest RubyGems and Bundler

```yaml
# Before (setup-ruby)
- uses: ruby/setup-ruby@v1
  with:
    ruby-version: ruby
    rubygems: latest
    bundler: latest

# After (setup-ruby-flash)
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: ruby
    rubygems: latest
    bundler: latest
```

### Key Differences

| Feature              | setup-ruby       | setup-ruby-flash  |
| -------------------- | ---------------- | ----------------- |
| Ruby Install         | ~5 seconds       | < 2 seconds       |
| Gem Install          | Bundler          | ore (~50% faster) |
| `ruby-version: ruby` | ✅ latest stable | ✅ latest stable  |
| `rubygems: latest`   | ✅               | ✅                |
| `bundler: latest`    | ✅               | ✅                |
| Windows              | ✅               | ❌                |
| Ruby < 3.2           | ✅               | ❌                |
| JRuby                | ✅               | ❌ (planned)      |
| TruffleRuby          | ✅               | ❌ (planned)      |
| Security Audit       | ❌               | ✅ (`ore audit`)  |

## About rv and ore

### rv

[rv][rv] is an extremely fast Ruby version manager written in Rust. It downloads prebuilt Ruby binaries, eliminating the need for compilation. Created by [@indirect](https://github.com/indirect), long-time project lead for Bundler and RubyGems.

[rv]: https://github.com/spinel-coop/rv

### ore

[ore][ore] is a fast gem installer written in Go. It's Bundler-compatible but performs downloads significantly faster using Go's concurrency features. Use `bundle exec` to run gem commands after ore installs your gems. Created by [@seuros](https://github.com/seuros), a long time Rubyist, and prolific [writer](https://www.seuros.com/blog/rubygems-coup-when-parasites-take-the-host/).

[ore]: https://github.com/contriboss/ore-light

## Development

```bash
# Setup
bundle install

# Run tests
rake spec

# Run linter
rake lint

# Run all checks
rake ci
```

### Developing with Local gemfile-go

If you're working on ore-light and need to test with a local gemfile-go checkout, you can use Go workspaces:

```bash
# Assuming you have both repos checked out as siblings:
# /path/to/ore-light
# /path/to/gemfile-go

cd /path/to/ore-light

# Create a Go workspace
go work init .
go work use ../gemfile-go

# Now build ore - it will use your local gemfile-go
go build -o ore ./cmd/ore
```

The `go.work` file is in `.gitignore`, so it won't be accidentally committed. This is the cleanest way to develop with local dependencies in Go, and it's the same approach the action uses when you set `gfgo-git-ref`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appraisal-rb/setup-ruby-flash.

## License

The [MIT License][📄license-ref] covers this software.

See [LICENSE](LICENSE.txt) for details, but note the following:

1. The terms of the MIT License let you use and share this software for all purposes, commercial, and non-commercial, for free.
2. However, the MIT License allows selling copies of the software for a fee, and I have chosen to do this for [big businesses][big-business], as an ethical matter, not a legal matter.
3. Paid (optional) licenses for [big businesses][big-business] are available on fair, reasonable, and nondiscriminatory terms.
4. So, anyone can use the software for free in _any_ and _all_ cases... But to quote the MIT License itself,

> Permission is hereby granted, free of charge, to any person ..., to deal
> in the Software without restriction, including without limitation the rights
> to ... sell copies of the Software

Open source will die without commercial support, so I am letting you know when and what **you should pay**
as an ethical matter, not as a legal matter.

<details>
    <summary>Definitions of Terms (What is a Big Business?)</summary>

The purpose of these definitions is to explain when I am asking you, as an ethical matter (not a legal one),
to consider purchasing a commercial license.

These definitions are inspired by the [Big Time Public License version 2.0.2](https://bigtimelicense.com/versions/2.0.2) and
are provided solely for these voluntary ethical guidelines. They do not modify or limit the MIT License that legally governs this project.

### Noncommercial Purposes

You may use the software for any noncommercial purpose.

### Personal Uses

Personal use for research, experiment, and testing for the benefit of public knowledge, personal study, private entertainment, hobby projects, amateur pursuits, or religious observance, without any anticipated commercial application, count as use for noncommercial purposes.

### Noncommercial Organizations

Use by any charitable organization, educational institution, public research organization, public safety or health organization, environmental protection organization, or government institution counts as use for noncommercial purposes, regardless of the source of funding or obligations resulting from the funding.

### Small Business

You may use the software for the benefit of your company if it meets all these criteria:

1.  had fewer than 20 total individuals working as employees and independent contractors at all times during the last tax year

2.  earned less than $1,000,000 total revenue in the last tax year

3.  received less than $1,000,000 total debt, equity, and other investment in the last five tax years, counting investment in predecessor companies that reorganized into, merged with, or spun out your company

All dollar figures are United States dollars as of 2019. Adjust them for inflation according to the United States Bureau of Labor Statistics' consumer price index for all urban consumers, United States city average, for all items, not seasonally adjusted, with 1982–1984=100 reference base.

### Big Business

You may use the software for the benefit of your company:

1.  for 128 days after your company stops qualifying under [Small Business][small-business]

2.  indefinitely, if the licensor or their legal successor does not offer fair, reasonable, and nondiscriminatory terms for a commercial license for the software within 32 days of [written request](#how-to-request) and negotiate in good faith to conclude a deal

</details>

[big-business]: https://bigtimelicense.com/versions/2.0.2#big-business
[small-business]: https://bigtimelicense.com/versions/2.0.2#small-business

### Paid licenses

$0.25 USD per employee per year for qualifying "[Big Business][big-business]" commercial use, as defined above.
If you're interested in licensing `setup-ruby-flash` for your business,
please contact [peter@9thbit.net](mailto:peter@9thbit.net),
and join the Official Discord 👉️ [![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite].

> 40 employees = $10 USD per year

Note: You should also donate to [rv][rv] / [Spinel Cooperative](https://github.com/spinel-coop)
and [ore][ore] / [Contriboss](https://github.com/contriboss), as this project would not exist without them.

#### How to Request

Request a fair commercial license by sending an email to [peter@9thbit.net](mailto:peter@9thbit.net) _and_ messaging the `#org-appraisal-rb` channel on the Official Discord 👉️ [![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite]. If both of your contact attempts fail to elicit a response within the time period allotted in [Big Business][big-business] the licensor will consider that equivalent to a fair commercial license under [Big Business][big-business].

# 🤑 A request for help

Maintainers have teeth and need to pay their dentists.
After getting laid off in an RIF in March, and encountering difficulty finding a new one,
I began spending most of my time building open source tools.
I'm hoping to be able to pay for my kids' health insurance this month,
so if you value the work I am doing, I need your support.
Please consider sponsoring me or the project.

To join the community or get help 👇️ Join the Discord.

[![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]

To say "thanks!" ☝️ Join the Discord or 👇️ send money.

[![Sponsor appraisal-rb/ast-merge on Open Source Collective][🖇osc-all-bottom-img]][🖇osc] 💌 [![Sponsor me on GitHub Sponsors][🖇sponsor-bottom-img]][🖇sponsor] 💌 [![Sponsor me on Liberapay][⛳liberapay-bottom-img]][⛳liberapay] 💌 [![Donate on PayPal][🖇paypal-bottom-img]][🖇paypal]

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-backers]: https://opencollective.com/appraisal-rb#backer
[🖇osc-backers-i]: https://opencollective.com/appraisal-rb/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/appraisal-rb#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/appraisal-rb/sponsors/badge.svg?style=flat
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-a51611.svg?style=flat
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/O5O86SNP4
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-a51611.svg?style=flat
[🖇patreon]: https://patreon.com/galtzo
[🖇buyme-small-img]: https://img.shields.io/badge/buy_me_a_coffee-%E2%9C%93-a51611.svg?style=flat
[🖇buyme]: https://www.buymeacoffee.com/pboling
[🖇paypal-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=flat&logo=paypal
[🖇paypal]: https://www.paypal.com/paypalme/peterboling
[✉️discord-invite]: https://discord.gg/3qme4XHNKN
[✉️discord-invite-img]: https://img.shields.io/discord/1373797679469170758?style=flat
[⛳liberapay-bottom-img]: https://img.shields.io/liberapay/goal/pboling.svg?style=for-the-badge&logo=liberapay&color=a51611
[🖇osc-all-img]: https://img.shields.io/opencollective/all/appraisal-rb
[🖇osc-sponsors-img]: https://img.shields.io/opencollective/sponsors/appraisal-rb
[🖇osc-backers-img]: https://img.shields.io/opencollective/backers/appraisal-rb
[🖇osc-all-bottom-img]: https://img.shields.io/opencollective/all/appraisal-rb?style=for-the-badge
[🖇osc-sponsors-bottom-img]: https://img.shields.io/opencollective/sponsors/appraisal-rb?style=for-the-badge
[🖇osc-backers-bottom-img]: https://img.shields.io/opencollective/backers/appraisal-rb?style=for-the-badge
[🖇osc]: https://opencollective.com/appraisal-rb
[🖇sponsor-bottom-img]: https://img.shields.io/badge/Sponsor_Me!-pboling-blue?style=for-the-badge&logo=github
[🖇buyme-img]: https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20latte&emoji=&slug=pboling&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff
[🖇paypal-bottom-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=for-the-badge&logo=paypal&color=0A0A0A
[🖇floss-funding.dev]: https://floss-funding.dev
[🖇floss-funding-gem]: https://github.com/galtzo-floss/floss_funding
[✉️discord-invite-img-ftb]: https://img.shields.io/discord/1373797679469170758?style=for-the-badge

## Acknowledgements

- [setup-ruby][setup-ruby] the venerable mainstay for many years, and inspiration for this project.
- [rv][rv] by Spinel Cooperative
- [ore][ore] by Contriboss
