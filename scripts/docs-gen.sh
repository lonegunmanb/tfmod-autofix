#!/usr/bin/env bash
set -e

generate_docs () {
  local dir=$1
  echo "===> Generating documentation in $dir"
  rm -f "$dir/.terraform.lock.hcl"
  if [ -f ".terraform-docs.yml" ]; then
    terraform-docs -c ".terraform-docs.yml" "$dir"
  else
    terraform-docs markdown table --output-file README.md --output-mode inject "$dir"
  fi
}

echo "==> Generating documentation..."
generate_docs .