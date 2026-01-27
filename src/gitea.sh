#!/usr/bin/env bash

function gitea_login() {
    if [[ -z "${GITHUB_SERVER_URL-}" ]]; then
        warn "GITHUB_SERVER_URL is not set, cannot login to Gitea"
        return 1
    fi

    if [[ -z "${GITHUB_TOKEN-}" ]]; then
        warn "GITHUB_TOKEN is not set, cannot login to Gitea"
        return 1
    fi

    if [[ -z "${GITHUB_ACTOR-}" ]]; then
        warn "GITHUB_ACTOR is not set, cannot login to Gitea"
        return 1
    fi

    info "logging in to ${GITHUB_SERVER_URL}"
    run tea login add --name "${GITHUB_ACTOR}" --url "${GITHUB_SERVER_URL}" --token "${GITHUB_TOKEN}" || true
    run tea login default "${GITHUB_ACTOR}"
}

function gitea_logout() {
    if [[ -z "${GITHUB_ACTOR-}" ]]; then
        warn "GITHUB_ACTOR is not set, cannot logout of Gitea"
        return 1
    fi

    info "logging out of Gitea"
    run tea login delete "${GITHUB_ACTOR}"
}

function gitea_release() {
    local tag="$1"
    local changelog="$2"

    if [[ -z "${GITHUB_REPOSITORY-}" ]]; then
        warn "GITHUB_REPOSITORY is not set, cannot create Gitea release"
        return 1
    fi

    info "creating release ${tag} at ${GITHUB_REPOSITORY}"
    run tea release create \
        --title "${tag}" \
        --note-file "${changelog}" \
        --repo "${GITHUB_REPOSITORY}" \
        "${tag}"
}

function gitea_release_asset() {
    local tag="$1"
    local asset="$2"

    if [[ -z "${GITHUB_REPOSITORY-}" ]]; then
        warn "GITHUB_REPOSITORY is not set, cannot upload asset to Gitea"
        return 1
    fi

    info "uploading asset to release ${tag} at ${GITHUB_REPOSITORY}"
    run tea release assets create --repo "${GITHUB_REPOSITORY}" "${tag}" "${asset}"
}
