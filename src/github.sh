#!/usr/bin/env bash

function github_release_create () {
    local version="$1"

    if [[ -n $GITHUB_TOKEN && -n $GITHUB_REPOSITORY ]]; then
        echo "creating release v$version at $GITHUB_REPOSITORY" >&2
        gh release create --repo "$GITHUB_REPOSITORY" "v$version" --generate-notes >&2 || true
    fi
}

# uploads a file to GitHub Releases
function github_upload_file () {
    local file="$1"
    local version="$2"

    if [[ -n $GITHUB_TOKEN && -n $GITHUB_REPOSITORY ]]; then
        github_release_create "$version"

        echo "uploading to release v$version at $GITHUB_REPOSITORY" >&2
        gh release upload --repo "$GITHUB_REPOSITORY" "v$version" "$file" --clobber >&2
    fi
}

# uploads a image to the GitHub Container Registry
function github_upload_image () {
    local path="$1"
    local tag="$2"

    if [[ -n $GITHUB_TOKEN && -n $GITHUB_ACTOR && -n $GITHUB_REPOSITORY ]]; then
        echo "uploading to ghcr.io/${GITHUB_REPOSITORY}:${tag}" >&2
        skopeo --insecure-policy copy \
            --dest-creds "${GITHUB_ACTOR}:${GITHUB_TOKEN}" \
            "docker-archive:${path}" \
            "docker://ghcr.io/${GITHUB_REPOSITORY}:${tag}" >&2
    fi
}

# streams an image to the GitHub Container Registry
function github_stream_image () {
    local path="$1"
    local tag="$2"

    if [[ -n $GITHUB_TOKEN && -n $GITHUB_ACTOR && -n $GITHUB_REPOSITORY ]]; then
        echo "streaming to ghcr.io/${GITHUB_REPOSITORY}:${tag}" >&2
        "${path}" |
            gzip --fast |
            skopeo --insecure-policy copy \
                --dest-creds "${GITHUB_ACTOR}:${GITHUB_TOKEN}" \
                "docker-archive:/dev/stdin" \
                "docker://ghcr.io/${GITHUB_REPOSITORY}:${tag}" >&2
    fi
}