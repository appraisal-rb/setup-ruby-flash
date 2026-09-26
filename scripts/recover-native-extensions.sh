#!/usr/bin/env bash
set -euo pipefail

bundle_path=${1:?Usage: recover-native-extensions.sh BUNDLE_PATH}

makefile_value() {
  makefile=$1
  key=$2

  while IFS= read -r line; do
    line=${line%$'\r'}
    case "$line" in
      "$key = "*) printf '%s' "${line#"$key = "}"; return 0 ;;
    esac
  done < "$makefile"

  return 1
}

for gem_dir in "$bundle_path"/ruby/*/gems/*; do
  [ -d "$gem_dir" ] || continue
  gem_name_ver="$(basename "$gem_dir")"
  lib_dir="$gem_dir/lib"
  ext_src="$gem_dir/ext"
  [ -d "$ext_src" ] || continue

  while IFS= read -r so_file; do
    [ -f "$so_file" ] || continue
    so_name="$(basename "$so_file")"
    target_name="${so_name%.*}"
    makefile=""
    target_prefix=""
    target_prefix_found=0
    while IFS= read -r candidate; do
      candidate_target="$(makefile_value "$candidate" TARGET || true)"
      if [ "$candidate_target" = "$target_name" ]; then
        makefile="$candidate"
        break
      fi
    done < <(find "$ext_src" -type f -name Makefile 2>/dev/null)
    if [ -z "$makefile" ]; then
      # rv can leave make install's DESTDIR-expanded output nested under ext/
      # without leaving the corresponding Makefile beside the staged binary.
      stage_marker="$gem_name_ver.tmp"
      case "$so_file" in
        *"$stage_marker"*)
          staged_suffix="${so_file#*"$stage_marker"}"
          staged_suffix="${staged_suffix#*/}"
          case "$staged_suffix" in
            */"$so_name")
              target_prefix="${staged_suffix%"/$so_name"}"
              target_prefix_found=1
              ;;
          esac
          ;;
      esac
      if [ "$target_prefix_found" -ne 1 ]; then
        echo "Skipping native extension without a matching Makefile TARGET or staged target path: $so_file" >&2
        continue
      fi
    else
      target_prefix="$(makefile_value "$makefile" target_prefix || true)"
      target_prefix_found=1
    fi

    target_prefix="${target_prefix#/}"
    case "$target_prefix" in
      ..|../*|*/../*|*/..)
        echo "Skipping native extension without a safe target_prefix: $so_file" >&2
        continue
        ;;
    esac

    target_lib_dir="$lib_dir"
    if [ -n "$target_prefix" ]; then
      target_lib_dir="$target_lib_dir/$target_prefix"
    fi
    mkdir -p "$target_lib_dir"
    if [ ! -f "$target_lib_dir/$so_name" ]; then
      echo "Recovered native extension $so_name -> $target_lib_dir/$so_name"
      cp -f "$so_file" "$target_lib_dir/$so_name"
    fi

    for ext_api_dir in "$bundle_path"/ruby/*/extensions/*/*; do
      [ -d "$ext_api_dir" ] || continue
      target_ext_dir="$ext_api_dir/$gem_name_ver/$target_prefix"
      mkdir -p "$target_ext_dir"
      if [ ! -f "$target_ext_dir/$so_name" ]; then
        echo "Recovered native extension $so_name -> $target_ext_dir/$so_name"
        cp -f "$so_file" "$target_ext_dir/$so_name"
      fi
    done
  done < <(find "$ext_src" -type f \( -name "*.so" -o -name "*.dll" \) 2>/dev/null)

  # Clean up mangled DESTDIR directories at any extension depth.
  find "$ext_src" -depth -mindepth 1 -type d -name "*:*" -exec rm -rf {} + 2>/dev/null || true
done
