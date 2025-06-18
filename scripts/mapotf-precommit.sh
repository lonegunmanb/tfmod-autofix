#!/usr/bin/env bash
set -e

mapotf transform --mptf-dir git::https://github.com/lonegunmanb/tfmod-autofix.git//mapotf/pre_commit --tf-dir .
avmfix -folder .
mapotf clean-backup --tf-dir .