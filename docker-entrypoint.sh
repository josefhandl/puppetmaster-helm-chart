#!/bin/bash

set -e

PUPPET_PATH="/etc/puppetlabs"
PUPPET_CONFIG="${PUPPET_PATH}/puppet/puppet.conf"

mkdir -p "${PUPPET_PATH}/puppetserver/ca/signed"

# Substiture vars (set hostname) in puppet.conf file
envsubst < "${PUPPET_PATH}/puppet/puppet.conf" | sponge "${PUPPET_PATH}/puppet/puppet.conf"

if [ -z "$(ls -A /opt/puppet-cert/ca/)" ]; then
    cp /opt/puppet-cert/ca/*     "${PUPPET_PATH}/puppetserver/ca/"
    cp /opt/puppet-cert/signed/* "${PUPPET_PATH}/puppetserver/ca/signed"
else
    puppetserver ca setup --config "$PUPPET_CONFIG"
fi

sleep infinity

/opt/puppetlabs/bin/puppetserver start

tail -f /var/log/puppetlabs/puppetserver/puppetserver.log

