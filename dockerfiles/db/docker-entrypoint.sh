#!/bin/bash

set -e

PUPPET_PATH="/etc/puppetlabs"
PUPPET_CONFIG="${PUPPET_PATH}/puppet/puppet.conf"

envsubst < "${PUPPET_PATH}/puppet/puppet.conf" | sponge "${PUPPET_PATH}/puppet/puppet.conf"
envsubst < "${PUPPET_PATH}/puppetdb/conf.d/jetty.ini" | sponge "${PUPPET_PATH}/puppetdb/conf.d/jetty.ini"
envsubst < "${PUPPET_PATH}/puppetdb/conf.d/database.ini" | sponge "${PUPPET_PATH}/puppetdb/conf.d/database.ini"

# Load private key from K8s Secret
cp /opt/puppet-cert-mount/private/* "${PUPPET_PATH}/puppet/ssl/private_keys/"

# Bootstrap certificates from PuppetServer's CA
puppet ssl bootstrap --config "$PUPPET_CONFIG"
echo "Puppet certs was loaded from Kubernetes Secrets"

# Start
puppetdb start --config "$PUPPET_CONFIG"

tail -f /var/log/puppetlabs/puppetdb/puppetdb.log & pid_tail=$!

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
