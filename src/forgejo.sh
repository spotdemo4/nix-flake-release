#!/usr/bin/env bash

function forgejo_login() {
    if [[ -z "${GITHUB_SERVER_URL-}" ]]; then
        warn "GITHUB_SERVER_URL is not set, cannot login to Forgejo"
        return 1
    fi

    if [[ -z "${GITHUB_ACTOR-}" ]]; then
        warn "GITHUB_ACTOR is not set, cannot login to Forgejo"
        return 1
    fi

    if [[ -z "${GITHUB_TOKEN-}" ]]; then
        warn "GITHUB_TOKEN is not set, cannot login to Forgejo"
        return 1
    fi

    info "logging in to ${GITHUB_SERVER_URL}"
    run fj --host "${GITHUB_SERVER_URL}" auth add-key "${GITHUB_ACTOR}" "${GITHUB_TOKEN}"
}

function forgejo_logout() {
    if [[ -z "${GITHUB_SERVER_URL-}" ]]; then
        warn "GITHUB_SERVER_URL is not set, cannot logout of Forgejo"
        return 1
    fi

    local domain
    domain="${GITHUB_SERVER_URL#*://}"

    info "logging out of Forgejo"
    run fj --host "${GITHUB_SERVER_URL}" auth logout "${domain}"
}

function forgejo_release() {
    local tag="$1"
    local changelog="$2"

    if [[ -z "${GITHUB_SERVER_URL-}" ]]; then
        warn "GITHUB_SERVER_URL is not set, cannot create Forgejo release"
        return 1
    fi

    if [[ -z "${GITHUB_REPOSITORY-}" ]]; then
        warn "GITHUB_REPOSITORY is not set, cannot create Forgejo release"
        return 1
    fi

    info "creating release ${tag} at ${GITHUB_REPOSITORY}"
    run fj --host "${GITHUB_SERVER_URL}" release create \
        --tag "${tag}" \
        --body "$(cat "${changelog}")" \
        --repo "${GITHUB_REPOSITORY}" \
        "${tag}"
}

function forgejo_release_asset() {
    local tag="$1"
    local asset="$2"

    if [[ -z "${GITHUB_SERVER_URL-}" ]]; then
        warn "GITHUB_SERVER_URL is not set, cannot upload asset to Forgejo"
        return 1
    fi

    if [[ -z "${GITHUB_REPOSITORY-}" ]]; then
        warn "GITHUB_REPOSITORY is not set, cannot upload asset to Forgejo"
        return 1
    fi

    info "uploading asset to release ${tag} at ${GITHUB_REPOSITORY}"
    run fj --host "${GITHUB_SERVER_URL}" release asset create \
        --repo "${GITHUB_REPOSITORY}" \
        "${tag}" "${asset}"
}
