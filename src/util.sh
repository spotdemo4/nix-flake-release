#!/usr/bin/env bash

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
