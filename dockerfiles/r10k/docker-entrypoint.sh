#!/bin/bash

set -e

PUPPET_PATH="/etc/puppetlabs"
PUPPET_CONFIG="${PUPPET_PATH}/puppet/puppet.conf"

envsubst < "${PUPPET_PATH}/puppet/r10k.yaml" | sponge "${PUPPET_PATH}/puppet/r10k.yaml"

trap exit SIGINT SIGTERM

while true; do
    /usr/local/bin/r10k deploy environment --config /etc/puppetlabs/puppet/r10k.yaml
    sleep 900
done
