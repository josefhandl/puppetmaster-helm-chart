#!/bin/bash

set -ex

echo "docker-entrypoint.sh"

PUPPET_PATH="/etc/puppetlabs"
PUPPET_CONFIG="${PUPPET_PATH}/puppet/puppet.conf"

mkdir -p "${PUPPET_PATH}/puppetserver/ca/signed"

# Substiture vars (set hostname) in puppet.conf file
envsubst < "${PUPPET_PATH}/puppet/puppet.conf" | sponge "${PUPPET_PATH}/puppet/puppet.conf"
envsubst < "${PUPPET_PATH}/puppet/puppetdb.conf" | sponge "${PUPPET_PATH}/puppet/puppetdb.conf"

# Load required keys and certs from K8s Secret
cp /opt/puppet-cert/ca/*     "${PUPPET_PATH}/puppetserver/ca/"
cp /opt/puppet-cert/signed/* "${PUPPET_PATH}/puppetserver/ca/signed"
echo "Puppet certs was loaded from Kubernetes Secrets"

# Start
puppetserver start --config "$PUPPET_CONFIG"

tail -f /var/log/puppetlabs/puppetserver/puppetserver.log & pid_tail=$!

# Register trap and wait for signal
pid_java=""
while [ -z "$pid_java" ]; do
    sleep 1
    pid_java=$(pgrep "java")
done

_trap () {
    kill "$pid_java"
    while ps "$pid_java" > /dev/null ; do
        sleep 1
    done
    kill "$pid_tail"
}

trap "_trap" SIGINT SIGTERM
wait "$pid_tail"
