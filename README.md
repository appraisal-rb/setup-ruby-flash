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

[![CI](https://github.com/appraisal-rb/setup-ruby-flash/actions/workflows/ci.yml/badge.svg)](https://github.com/appraisal-rb/setup-ruby-flash/actions/workflows/ci.yml)  [![GitHub tag (latest SemVer)][⛳️tag-img]][⛳️tag] [![License: MIT][📄license-img]][📄license-ref]

[⛳️tag-img]: https://img.shields.io/github/tag/appraisal-rb/setup-ruby-flash.svg
[⛳️tag]: http://github.com/appraisal-rb/setup-ruby-flash/releases
[📄license-ref]: https://opensource.org/licenses/MIT
[📄license-img]: https://img.shields.io/badge/License-MIT-259D6C.svg

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

## Requirements

- **Operating Systems**: Ubuntu 22.04+, macOS 14+
- **Architectures**: x86_64, ARM64
- **Ruby Versions**: 3.2, 3.3, 3.4, 4.0

| # | Important                    | Alternative                   |
|---|------------------------------|-------------------------------|
| 1 | Windows is not supported     | [ruby/setup-ruby][setup-ruby] |
| 2 | Ruby <= 3.1 is not supported | [ruby/setup-ruby][setup-ruby] |

[setup-ruby]: https://github.com/ruby/setup-ruby

## Why?

<details>
    <summary>Click to see historical background around why I built this</summary>

| 📍 NOTE                                                                                                                                                                                                       |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RubyGems (the [GitHub org][rubygems-org], not the website) [suffered][draper-security] a [hostile takeover][ellen-takeover] in September 2025.                                                                |
| Ultimately [4 maintainers][simi-removed] were [hard removed][martin-removed] and an reason has been given for only 1 of those, while 2 others resigned in protest.                                            |
| It is a [complicated story][draper-takeover] which is difficult to [parse quickly][draper-lies].                                                                                                              |
| Simply put - there was active policy for adding or removing maintainers/owners of [rubygems][rubygems-maint-policy] and [bundler][bundler-maint-policy], and those [policies were not followed][policy-fail]. |
| I'm adding notes like this to gems because I [don't condone theft][draper-theft] of repositories or gems from their rightful owners.                                                                          |
| If a similar theft happened with my repos/gems, I'd hope some would stand up for me.                                                                                                                          |
| Disenfranchised former-maintainers have started [gem.coop][gem-coop].                                                                                                                                         |
| Once available I will publish there exclusively; unless RubyCentral makes amends with the community.                                                                                                          |
| The ["Technology for Humans: Joel Draper"][reinteractive-podcast] podcast episode by [reinteractive][reinteractive] is the most cogent summary I'm aware of.                                                  |
| See [here][gem-naming], [here][gem-coop] and [here][martin-ann] for more info on what comes next.                                                                                                             |
| What I'm doing: A (WIP) proposal for [bundler/gem scopes][gem-scopes], and a (WIP) proposal for a federated [gem server][gem-server].                                                                         |

[rubygems-org]: https://github.com/rubygems/
[draper-security]: https://joel.drapper.me/p/ruby-central-security-measures/
[draper-takeover]: https://joel.drapper.me/p/ruby-central-takeover/
[ellen-takeover]: https://pup-e.com/blog/goodbye-rubygems/
[simi-removed]: https://www.reddit.com/r/ruby/s/gOk42POCaV
[martin-removed]: https://bsky.app/profile/martinemde.com/post/3m3occezxxs2q
[draper-lies]: https://joel.drapper.me/p/ruby-central-fact-check/
[draper-theft]: https://joel.drapper.me/p/ruby-central/
[reinteractive]: https://reinteractive.com/ruby-on-rails
[gem-coop]: https://gem.coop
[gem-naming]: https://github.com/gem-coop/gem.coop/issues/12
[martin-ann]: https://martinemde.com/2025/10/05/announcing-gem-coop.html
[gem-scopes]: https://github.com/galtzo-floss/bundle-namespace
[gem-server]: https://github.com/galtzo-floss/gem-server
[reinteractive-podcast]: https://youtu.be/_H4qbtC5qzU?si=BvuBU90R2wAqD2E6
[bundler-maint-policy]: https://github.com/ruby/rubygems/blob/b1ab33a3d52310a84d16b193991af07f5a6a07c0/doc/bundler/playbooks/TEAM_CHANGES.md
[rubygems-maint-policy]: https://github.com/ruby/rubygems/blob/b1ab33a3d52310a84d16b193991af07f5a6a07c0/doc/rubygems/POLICIES.md?plain=1#L187-L196
[policy-fail]: https://www.reddit.com/r/ruby/comments/1ove9vp/rubycentral_hates_this_one_fact/

</details>

## Quick Start

### Basic Usage

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.4'
```

### With Gem Installation

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.4'
    ore-install: true
```

### Using Version Files

When `ruby-version` is set to `default` (the default), setup-ruby-flash reads from:
- `.ruby-version`
- `.tool-versions` (asdf format)
- `mise.toml`

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ore-install: true
```

## Inputs

| Input                  | Description                                                                                                                    | Default               |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------|-----------------------|
| `ruby-version`         | Ruby version to install (e.g., `3.4`, `3.4.1`). Use `ruby` for latest stable version, or `default` to read from version files. | `default`             |
| `rubygems`             | RubyGems version: `default`, `latest`, or a version number (e.g., `3.5.0`)                                                     | `default`             |
| `bundler`              | Bundler version: `Gemfile.lock`, `default`, `latest`, `none`, or a version number                                              | `Gemfile.lock`        |
| `ore-install`          | Run `ore install` and cache gems                                                                                               | `false`               |
| `working-directory`    | Directory for version files and Gemfile                                                                                        | `.`                   |
| `cache-version`        | Cache version string for invalidation                                                                                          | `v1`                  |
| `rv-version`           | Version of rv to install                                                                                                       | `latest`              |
| `ore-version`          | Version of ore to install                                                                                                      | `latest`              |
| `skip-extensions`      | Skip building native extensions                                                                                                | `false`               |
| `without-groups`       | Gem groups to exclude (comma-separated)                                                                                        | `''`                  |
| `ruby-install-retries` | Number of retry attempts for Ruby installation (with exponential backoff)                                                      | `3`                   |
| `token`                | GitHub token for API calls                                                                                                     | `${{ github.token }}` |

## Outputs

| Output             | Description                           |
|--------------------|---------------------------------------|
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
        ruby: ['3.2', '3.3', '3.4']
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
    ruby-version: '3.4'
    ore-install: true
    without-groups: 'development,test'
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
    ruby-version: '3.4'
    rubygems: '3.5.0'
    ore-install: true
```

### Skip Native Extensions

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.4'
    ore-install: true
    skip-extensions: true
```

### Custom Working Directory

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.4'
    ore-install: true
    working-directory: './my-app'
```

### Specific Tool Versions

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.4.1'
    rv-version: '0.4.0'
    ore-version: '0.1.0'
    ore-install: true
```

### Custom Retry Configuration

If you experience intermittent failures due to GitHub API rate limiting, you can adjust the number of retry attempts:

```yaml
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.4'
    ruby-install-retries: '5'
```

## Migration from setup-ruby

setup-ruby-flash is designed to be a near drop-in replacement for `ruby/setup-ruby` on supported platforms:

```yaml
# Before (setup-ruby)
- uses: ruby/setup-ruby@v1
  with:
    ruby-version: '3.4'
    bundler-cache: true
- run: bundle exec rake test

# After (setup-ruby-flash)
- uses: appraisal-rb/setup-ruby-flash@v1
  with:
    ruby-version: '3.4'
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

| Feature              | setup-ruby      | setup-ruby-flash  |
|----------------------|-----------------|-------------------|
| Ruby Install         | ~5 seconds      | < 2 seconds       |
| Gem Install          | Bundler         | ore (~50% faster) |
| `ruby-version: ruby` | ✅ latest stable | ✅ latest stable   |
| `rubygems: latest`   | ✅               | ✅                 |
| `bundler: latest`    | ✅               | ✅                 |
| Windows              | ✅               | ❌                 |
| Ruby < 3.2           | ✅               | ❌                 |
| JRuby                | ✅               | ❌ (planned)       |
| TruffleRuby          | ✅               | ❌ (planned)       |
| Security Audit       | ❌               | ✅ (`ore audit`)   |

## About rv and ore

### rv

[rv](https://github.com/spinel-coop/rv) is an extremely fast Ruby version manager written in Rust. It downloads prebuilt Ruby binaries, eliminating the need for compilation. Created by [@indirect](https://github.com/indirect), long-time project lead for Bundler and RubyGems.

### ore

[ore](https://github.com/contriboss/ore-light) is a fast gem installer written in Go. It's Bundler-compatible but performs downloads significantly faster using Go's concurrency features. Use `bundle exec` to run gem commands after ore installs your gems.

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appraisal-rb/setup-ruby-flash.

## License

This project is available as open source under the terms of the [MIT License](LICENSE).

## Acknowledgements

- [setup-ruby](https://github.com/ruby/setup-ruby) the venerable mainstay for many years, and inspiration for this project.
- [rv](https://github.com/spinel-coop/rv) by Spinel Cooperative
- [ore](https://github.com/contriboss/ore-light) by Contriboss
