#!/usr/bin/env bash

# logs in to Gitea using the GITHUB_TOKEN
function gitea_login () {
    if [[ -n ${GITHUB_TOKEN-} && -n ${GITHUB_SERVER_URL-} ]]; then
        info "logging in to ${GITHUB_SERVER_URL}"
        run login add --name gitea --url "${GITHUB_SERVER_URL}" --token "${GITHUB_TOKEN}"
        run tea login default gitea
    fi
}

# creates a Gitea release if it does not exist
function gitea_release () {
    local file="$1"
    local version="$2"
    local changelog="$3"

    if [[ -n ${GITHUB_TOKEN-} && -n ${GITHUB_REPOSITORY-} ]]; then
        info "creating release v$version at $GITHUB_REPOSITORY"
        run tea release create \
            --title "v$version" \
            --note "$changelog" \
            --repo "$GITHUB_REPOSITORY" \
            --asset "$file" \
            "v$version" || true
    fi
}
