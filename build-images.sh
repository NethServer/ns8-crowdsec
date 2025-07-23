#!/bin/bash

#
# Copyright (C) 2022 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Terminate on error
set -e

# cleanup on exit
cleanup_list=()
trap 'rm -rf "${bouncer_tmp_dir}" crowdsec-firewall-bouncer-linux-amd64.tgz' EXIT

# Prepare variables for later use
images=()
# The image will be pushed to GitHub container registry
repobase="${REPOBASE:-ghcr.io/nethserver}"

# The crowdsec-firewall-bouncer versions can be found : https://github.com/crowdsecurity/cs-firewall-bouncer/releases
curl --netrc --fail -L -o crowdsec-firewall-bouncer-linux-amd64.tgz \
    https://github.com/crowdsecurity/cs-firewall-bouncer/releases/download/v0.0.31/crowdsec-firewall-bouncer-linux-amd64.tgz

# After updates add the new value to CHECKSUM file: sha256sum crowdsec-firewall-bouncer-linux-amd64.tgz > CHECKSUM
sha256sum -c CHECKSUM

bouncer_tmp_dir=$(mktemp -d)
tar -C "${bouncer_tmp_dir}" -x -v -z -f crowdsec-firewall-bouncer-linux-amd64.tgz

# Create a new empty container image for crowdsec-firewall-bouncer
reponame="crowdsec-firewall-bouncer"
container=$(buildah from docker.io/alpine:3.21.3)

# add to the container the crowdsec-firewall-bouncer
buildah add --chmod 750 ${container} ${bouncer_tmp_dir}/crowdsec-firewall-bouncer-v*/crowdsec-firewall-bouncer /usr/local/bin/crowdsec-firewall-bouncer

buildah config \
    --workingdir="/" \
    --cmd='["/usr/local/bin/crowdsec-firewall-bouncer", "-c", "/etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml"]' \
    --label="org.opencontainers.image.source=https://github.com/NethServer/ns8-crowdsec" \
    --label="org.opencontainers.image.authors=Stephane de Labrusse <stephdl@de-labrusse.fr>" \
    --label="org.opencontainers.image.title=Crowdsec-firewall-bouncer based on debian" \
    --label="org.opencontainers.image.description=A Crowdsec-firewall-bouncer running in a debian container" \
    --label="org.opencontainers.image.licenses=GPL-3.0-or-later" \
    --label="org.opencontainers.image.url=https://github.com/NethServer/ns8-crowdsec" \
    --label="org.opencontainers.image.documentation=https://github.com/NethServer/ns8-crowdsec/blob/main/README.md" \
    --label="org.opencontainers.image.vendor=NethServer" \
    "${container}"

# Commit the image
buildah commit "${container}" "${repobase}/${reponame}"

# Append the image URL to the images array
images+=("${repobase}/${reponame}")

# Configure the image name
reponame="crowdsec"

# Create a new empty container image
container=$(buildah from scratch)

# Reuse existing nodebuilder-crowdsec container, to speed up builds
if ! buildah containers --format "{{.ContainerName}}" | grep -q nodebuilder-crowdsec; then
    echo "Pulling NodeJS runtime..."
    buildah from --name nodebuilder-crowdsec -v "${PWD}:/usr/src:Z" docker.io/library/node:18-slim
fi

echo "Build static UI files with node..."
buildah run --env="NODE_OPTIONS=--openssl-legacy-provider" nodebuilder-crowdsec sh -c "cd /usr/src/ui && yarn install && yarn build"

# Add imageroot directory to the container image
buildah add "${container}" imageroot /imageroot
buildah add "${container}" ui/dist /ui
# Setup the entrypoint, ask to reserve one TCP port with the label and set a rootless container
buildah config --entrypoint=/ \
    --label="org.nethserver.max-per-node=1" \
    --label="org.nethserver.authorizations=" \
    --label="org.nethserver.rootfull=1" \
    --label="org.nethserver.images=docker.io/crowdsecurity/crowdsec:v1.6.11-debian ${repobase}/crowdsec-firewall-bouncer:${IMAGETAG:-latest}" \
    --label="org.nethserver.tcp-ports-demand=2" \
    "${container}"
# Commit the image
buildah commit "${container}" "${repobase}/${reponame}"

# Append the image URL to the images array
images+=("${repobase}/${reponame}")

#
# NOTICE:
#
# It is possible to build and publish multiple images.
#
# 1. create another buildah container
# 2. add things to it and commit it
# 3. append the image url to the images array
#

#
# Setup CI when pushing to Github. 
# Warning! docker::// protocol expects lowercase letters (,,)
if [[ -n "${CI}" ]]; then
    # Set output value for Github Actions
    printf "images=%s\n" "${images[*],,}" >> $GITHUB_OUTPUT
else
    # Just print info for manual push
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${IMAGETAG:-latest}" ; done
    printf "\n"
fi
