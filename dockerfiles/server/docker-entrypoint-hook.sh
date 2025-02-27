#!/bin/bash

set -ex

echo "docker-entrypoint-hook.sh"

PUPPET_PATH="/etc/puppetlabs"
PUPPET_CONFIG="${PUPPET_PATH}/puppet/puppet.conf"

mkdir -p "${PUPPET_PATH}/puppetserver/ca/signed"

# Substiture env vars (set hostname) in puppet.conf file
envsubst < "${PUPPET_PATH}/puppet/puppet.conf" | sponge "${PUPPET_PATH}/puppet/puppet.conf"
envsubst < "${PUPPET_PATH}/puppet/puppetdb.conf" | sponge "${PUPPET_PATH}/puppet/puppetdb.conf"

# Setup and start PuppetServer with CA
puppetserver ca setup --config "$PUPPET_CONFIG"
puppetserver start --config "$PUPPET_CONFIG"

# Generate certs for PuppetDB and PuppetBoard
puppetserver ca generate --config "$PUPPET_CONFIG" --certname "$HOSTNAME_FULL_PUPPETDB"
puppetserver ca generate --config "$PUPPET_CONFIG" --certname "$HOSTNAME_FULL_PUPPETBOARD"

puppetserver stop --config "$PUPPET_CONFIG"

# Save all keys and certs into K8s Secrets
puppet-cert-saver server-ca
puppet-cert-saver server-signed
puppet-cert-saver db-private
puppet-cert-saver board-private
