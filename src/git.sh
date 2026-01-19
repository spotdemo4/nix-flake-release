#!/usr/bin/env bash

# https://github.com/gitleaks/gitleaks/issues/1364#issuecomment-2035545023
function git_check_safe() {
    local dir="$1"
    local safe_dirs=()

    if [[ "$(stat -c "%U" "${dir}")" == "$(whoami)" ]]; then
        return 0
    fi

    readarray -t safe_dirs < <(git config --global --get-all safe.directory)

    for safe_dir in "${safe_dirs[@]}"; do
        if [[ "$(realpath "${dir}")" == "$(realpath "${safe_dir}")" ]]; then
            return 0
        fi
    done

    info "adding '${dir}' to git safe directories"
    git config --global --add safe.directory "${dir}"
}

function git_changelog() {
    local last_tag
    local current_tag

    last_tag=$(git tag -l --sort=-creatordate | head -n 2 | tail -1)
    if [[ -z "${last_tag}" ]]; then
        last_tag=$(git rev-list --max-parents=0 HEAD)
    fi

    current_tag=$(git tag -l --sort=-creatordate | head -n 1)
    if [[ -z "${current_tag}" ]]; then
        current_tag="HEAD"
    fi

    git log --pretty=format:"* %s (%H)" "${last_tag}..${current_tag}"
}

git_check_safe "$(pwd)"
