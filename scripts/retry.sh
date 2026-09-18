# shellcheck shell=bash
#
# Retry helpers for setup-ruby-flash install steps.
#
# Sourced by action.yml steps (source "$GITHUB_ACTION_PATH/scripts/retry.sh");
# not meant to be executed directly.

# Failures that retrying cannot fix: the same inputs fail the same way on every
# attempt. Each line is "reason => extended regular expression", matched
# case-insensitively against the failed attempt's output.
#
# "Could not find gem ..." is deliberately absent: a just-published gem can be
# missing from the index for a few minutes, and retrying is the fix.
SETUP_RUBY_FLASH_DETERMINISTIC_FAILURES='native extension build failure => Gem::Ext::BuildError|Failed to build gem native extension|Could not compile gem .* extension|CiError\(CompileFailures
dependency resolution conflict => could not find compatible versions|version solving has failed
incompatible Ruby version => requires ruby version|conflicting requirements for the ruby version
Gemfile or gemspec error => there was an error parsing .?gemfile|gemfile syntax error|there was an error while loading .*\.gemspec
lockfile or platform mismatch => you are trying to install in deployment mode after changing|the gemspecs for path gems changed|your bundle only supports platforms|frozen mode is set
git authentication failure => permission denied \(publickey\)|authentication failed for'

# Prints the reason and returns 0 when the log shows a deterministic failure.
#
# @param $1 path to the failed attempt's captured output
setup_ruby_flash_deterministic_failure() {
  local log="$1" line reason pattern
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    reason="${line%% => *}"
    pattern="${line#* => }"
    if grep -Eiq -- "$pattern" "$log"; then
      printf '%s\n' "$reason"
      return 0
    fi
  done <<< "$SETUP_RUBY_FLASH_DETERMINISTIC_FAILURES"
  return 1
}

# Runs a command up to MAX_ATTEMPTS times with exponential backoff (starting at
# SETUP_RUBY_FLASH_RETRY_BACKOFF seconds, default 5), keeping the configured
# Gemfile sources. Stops early when the failure is deterministic. Returns the
# command's exit status from its last attempt.
#
# Usage: setup_ruby_flash_retry LABEL MAX_ATTEMPTS COMMAND [ARGS...]
setup_ruby_flash_retry() {
  local label="$1" max_attempts="$2"
  shift 2
  local attempt=0 backoff="${SETUP_RUBY_FLASH_RETRY_BACKOFF:-5}" status=1 reason log status_file
  log="$(mktemp)"
  status_file="$(mktemp)"

  while [ "$attempt" -lt "$max_attempts" ]; do
    attempt=$((attempt + 1))
    echo "$label attempt $attempt of $max_attempts..."

    # Capture output for failure classification while still streaming it.
    # The exit status is written to a file so it survives the pipeline with or
    # without pipefail, and under errexit.
    : > "$status_file"
    { "$@" || echo "$?" > "$status_file"; } 2>&1 | tee "$log"
    status="$(cat "$status_file")"
    status="${status:-0}"

    if [ "$status" -eq 0 ]; then
      rm -f "$log" "$status_file"
      return 0
    fi

    if reason="$(setup_ruby_flash_deterministic_failure "$log")"; then
      echo "::error::$label failed with a deterministic error ($reason); not retrying because the same inputs fail the same way."
      rm -f "$log" "$status_file"
      return "$status"
    fi

    if [ "$attempt" -lt "$max_attempts" ]; then
      echo "::warning::$label failed (attempt $attempt/$max_attempts). Retrying in ${backoff}s without changing Gemfile sources..."
      sleep "$backoff"
      backoff=$((backoff * 2))
    fi
  done

  echo "::error::$label failed after $max_attempts attempts"
  rm -f "$log" "$status_file"
  return "$status"
}
