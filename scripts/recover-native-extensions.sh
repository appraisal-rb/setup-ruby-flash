#!/usr/bin/env bash
set -euo pipefail

bundle_path=${1:?Usage: recover-native-extensions.sh BUNDLE_PATH}

for gem_dir in "$bundle_path"/ruby/*/gems/*; do
  [ -d "$gem_dir" ] || continue
  gem_name_ver="$(basename "$gem_dir")"
  lib_dir="$gem_dir/lib"
  ext_src="$gem_dir/ext"
  [ -d "$ext_src" ] || continue

  while IFS= read -r so_file; do
    [ -f "$so_file" ] || continue
    makefile="$(dirname "$so_file")/Makefile"
    [ -f "$makefile" ] || continue

    target_prefix=""
    while IFS= read -r line; do
      case "$line" in
        "target_prefix = "*) target_prefix="${line#target_prefix = }"; break ;;
      esac
    done < "$makefile"
    target_prefix="${target_prefix#/}"
    case "$target_prefix" in
      ""|..|../*|*/../*)
        echo "Skipping native extension without a safe target_prefix: $so_file" >&2
        continue
        ;;
    esac

    so_name="$(basename "$so_file")"
    target_lib_dir="$lib_dir/$target_prefix"
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

  # Clean up any mangled directory created by make install (e.g., ext/**/D:a* or *:*)
  find "$ext_src" -mindepth 1 -maxdepth 3 -type d -name "*:*" -exec rm -rf {} + 2>/dev/null || true
done
