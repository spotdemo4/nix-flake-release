#!/usr/bin/env bash

# creates a GitHub release if it does not exist
function github_release_create () {
    local version="$1"
    local changelog="$2"

    if [[ -n ${GITHUB_TOKEN-} && -n ${GITHUB_REPOSITORY-} ]]; then
        info "creating release v$version at $GITHUB_REPOSITORY"
        run gh release create \
            --title "v$version" \
            --notes "$changelog" \
            --repo "$GITHUB_REPOSITORY" \
            "v$version" || true
    fi
}

# uploads a file to a GitHub release
function github_release () {
    local file="$1"
    local version="$2"
    local changelog="$3"

    if [[ -n ${GITHUB_TOKEN-} && -n ${GITHUB_REPOSITORY-} ]]; then
        github_release_create "$version" "$changelog"

        info "uploading to release v$version at $GITHUB_REPOSITORY"
        run gh release upload --repo "$GITHUB_REPOSITORY" "v$version" "$file" --clobber
    fi
}
