#!/usr/bin/env bash

GLOBAL_PACKAGE="default"

function print () {
    local message="$1"

    printf '%s: %s\n' "${GLOBAL_PACKAGE}" "${message}" >&2
}

function archive () {
    local source="$1"
    local name="$2"
    local platform="$3"

    local tmpdir
    tmpdir=$(mktemp -d)

    if [[ "$platform" == "windows"* ]]; then
        zip -qr "${tmpdir}/${name}.zip" "${source}" &> /dev/null
        echo "${tmpdir}/${name}.zip"
    else
        tar -cJhf "${tmpdir}/${name}.tar.xz" "${source}" &> /dev/null
        echo "${tmpdir}/${name}.tar.xz"
    fi
}
