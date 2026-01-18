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

[ore](https://github.com/contriboss/ore-light) is a fast gem installer written in Go. It's Bundler-compatible but performs downloads significantly faster using Go's concurrency features. Use `bundle exec` to run gem commands after ore installs your gems. Created by [@seuros](https://github.com/seuros), a long time Rubyist, and prolific [writer](https://www.seuros.com/blog/rubygems-coup-when-parasites-take-the-host/).

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

The [MIT License][📄license-ref] covers this software.

See [LICENSE](LICENSE.txt) for details, but note the following:

1. The terms of the MIT License let you use and share this software for noncommercial purposes and in small business for free.
2. The MIT license allows selling copies of the software for a fee, and I have chosen to do this for big businesses.
3. Paid licenses for [big businesses](#big-business) are available on fair, reasonable, and nondiscriminatory terms.
4. To be clear, [big businesses](#big-business) don't have to pay the fee, as this project exists under the _standard_ MIT license.
5. So, anyone can use the software for free in _any_ and _all_ cases... But

> Permission is hereby granted, free of charge, to any person ..., to deal
> in the Software without restriction, including without limitation the rights
> to ... sell copies of the Software

Open source will die without commercial support, so I am letting you know when and what **you should pay**
as an ethical matter, not as a legal matter.

<details>
    <summary>Definitions of Terms (What is a Big Business?)</summary>

The purpose of these definitions is to clarify the terms under which this software is free to use,
and when it is _ethical_ to purchase a commercial license.

These definitions come from the [Big Time Public License version 2.0.2](https://bigtimelicense.com/versions/2.0.2).

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

All dollar figures are United States dollars as of 2019.  Adjust them for inflation according to the United States Bureau of Labor Statistics' consumer price index for all urban consumers, United States city average, for all items, not seasonally adjusted, with 1982–1984=100 reference base.

### Big Business

You may use the software for the benefit of your company:

1.  for 128 days after your company stops qualifying under [Small Business](#small-business)

2.  indefinitely, if the licensor or their legal successor does not offer fair, reasonable, and nondiscriminatory terms for a commercial license for the software within 32 days of [written request](#how-to-request) and negotiate in good faith to conclude a deal

</details>

### Paid licenses

$0.25 per employee per year for qualifying "[Big Business](#big-business)" commercial use, as defined above.
If you're interested in licensing `setup-ruby-flash` for your business,
contact [peter@9thbit.net](mailto:peter@9thbit.net),
or join the Official Discord 👉️ [![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite].

Note: You should also donate to [Spinel Cooperative](https://github.com/spinel-coop)
and [Contriboss](https://github.com/contriboss), as this project would not exist without them.

#### How to Request

Request a fair commercial license at [peter@9thbit.net](mailto:peter@9thbit.net) _and_ on the Official Discord 👉️ [![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite].  If both of your contact attempts fail to elicit a response within the time period allotted in [Big Business](#big-business) the licensor will consider that equivalent to a fair commercial license under [Big Business](#big-business).

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

- [setup-ruby](https://github.com/ruby/setup-ruby) the venerable mainstay for many years, and inspiration for this project.
- [rv](https://github.com/spinel-coop/rv) by Spinel Cooperative
- [ore](https://github.com/contriboss/ore-light) by Contriboss
