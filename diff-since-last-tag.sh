#!/usr/bin/env bash

set -eu
set -o pipefail

# readonly PROGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# readonly BUILDPACKDIR="$(cd "${PROGDIR}/.." && pwd)"

function main() {
  compare_diff "${@}"
}

function compare_diff(){
  local repo
  while [[ "${#}" != 0 ]]; do
    repo="${1}"
    shift 1

    # go to the repo
    printf "Comparing %s...\n\n" "${repo}"
    read -p "Press enter to continue"
 
    pushd "${HOME}/workspace/paketo-buildpacks/${repo}" > /dev/null
    # checkout main and pull, fetch all tags
    git co main
    git pull origin main -r
    git fetch -a
    # do the comparison
    git diff $(git describe --tags `git rev-list --tags --max-count=1`) main
    popd > /dev/null
  done
}

main "${@:-}"
