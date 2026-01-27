#!/usr/bin/env bash

# creates a GitHub release if it does not exist
function github_release() {
    local tag="$1"
    local changelog="$2"

    if [[ -z "${GITHUB_REPOSITORY-}" ]]; then
        warn "GITHUB_REPOSITORY is not set, cannot create GitHub release"
        return 1
    fi

    if [[ -z "${GITHUB_TOKEN-}" ]]; then
        warn "GITHUB_TOKEN is not set, cannot create GitHub release"
        return 1
    fi

    info "creating release ${tag} at ${GITHUB_REPOSITORY}"
    run gh release create \
        --title "${tag}" \
        --notes-file "${changelog}" \
        --repo "${GITHUB_REPOSITORY}" \
        "${tag}"
}

# uploads a file to a GitHub release
function github_release_asset() {
    local tag="$1"
    local asset="$2"

    if [[ -z "${GITHUB_REPOSITORY-}" ]]; then
        warn "GITHUB_REPOSITORY is not set, cannot upload asset to GitHub"
        return 1
    fi

    if [[ -z "${GITHUB_TOKEN-}" ]]; then
        warn "GITHUB_TOKEN is not set, cannot upload asset to GitHub"
        return 1
    fi

    info "uploading asset to release ${tag} at ${GITHUB_REPOSITORY}"
    run gh release upload --repo "${GITHUB_REPOSITORY}" "${tag}" "${asset}"
}
