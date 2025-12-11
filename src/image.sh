#!/usr/bin/env bash

# uploads a image to the container registry
function upload_image () {
    local path="$1"
    local tag="$2"

    if [[ -n ${REGISTRY-} && -n ${REGISTRY_USERNAME-} && -n ${REGISTRY_PASSWORD-} ]]; then
        echo "uploading to ${REGISTRY}/${GITHUB_REPOSITORY}:${tag}" >&2
        skopeo --insecure-policy copy \
            --dest-creds "${REGISTRY_USERNAME}:${REGISTRY_PASSWORD}" \
            "docker-archive:${path}" \
            "docker://${REGISTRY}/${GITHUB_REPOSITORY}:${tag}" >&2
    fi
}

# streams an image to a container registry
function stream_image () {
    local path="$1"
    local tag="$2"

    if [[ -n ${REGISTRY-} && -n ${REGISTRY_USERNAME-} && -n ${REGISTRY_PASSWORD-} ]]; then
        echo "streaming to ${REGISTRY}/${GITHUB_REPOSITORY}:${tag}" >&2
        "${path}" |
            gzip --fast |
            skopeo --insecure-policy copy \
                --dest-creds "${REGISTRY_USERNAME}:${REGISTRY_PASSWORD}" \
                "docker-archive:/dev/stdin" \
                "docker://${REGISTRY}/${GITHUB_REPOSITORY}:${tag}" >&2
    fi
}