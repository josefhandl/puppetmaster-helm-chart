#!/bin/bash

set -ex

echo "docker-entrypoint-hook.sh"

PUPPET_PATH="/etc/puppetlabs"
PUPPET_CONFIG="${PUPPET_PATH}/puppet/puppet.conf"

mkdir -p "${PUPPET_PATH}/puppetserver/ca/signed"

# Substiture vars (set hostname) in puppet.conf file
envsubst < "${PUPPET_PATH}/puppet/puppet.conf" | sponge "${PUPPET_PATH}/puppet/puppet.conf"
envsubst < "${PUPPET_PATH}/puppet/puppetdb.conf" | sponge "${PUPPET_PATH}/puppet/puppetdb.conf"

puppetserver ca setup --config "$PUPPET_CONFIG"
puppetserver start --config "$PUPPET_CONFIG"
#sleep infinity
#sleep 20

puppetserver ca generate --config "$PUPPET_CONFIG" --certname "$HOSTNAME_FULL_PUPPETDB"
puppetserver ca generate --config "$PUPPET_CONFIG" --certname "$HOSTNAME_FULL_PUPPETBOARD"

puppetserver stop --config "$PUPPET_CONFIG"

puppet-cert-saver server-ca
puppet-cert-saver server-signed
puppet-cert-saver db-private
puppet-cert-saver board-private

sleep 20
exit 0


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
