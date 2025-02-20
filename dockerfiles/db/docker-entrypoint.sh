#!/bin/bash

set -e

PUPPET_PATH="/etc/puppetlabs"
PUPPET_CONFIG="${PUPPET_PATH}/puppet/puppet.conf"

#mkdir -p "${PUPPET_PATH}/puppetserver/ca/signed"
#
## Substiture vars (set hostname) in puppet.conf file
#envsubst < "${PUPPET_PATH}/puppet/puppet.conf" | sponge "${PUPPET_PATH}/puppet/puppet.conf"
#
#
#

envsubst < "${PUPPET_PATH}/puppetdb/conf.d/jetty.ini" | sponge "${PUPPET_PATH}/puppetdb/conf.d/jetty.ini"
envsubst < "${PUPPET_PATH}/puppetdb/conf.d/database.ini" | sponge "${PUPPET_PATH}/puppetdb/conf.d/database.ini"

# Bootstrap certificates from Puppet Server's CA
if [ -n "$(ls /opt/puppet-cert/private/)" ]; then
    # Load already signed private key
    cp /opt/puppet-cert/private/* "${PUPPET_PATH}/puppet/ssl/private_keys/"

    # Bootstrap certificates
    puppet ssl bootstrap --config "$PUPPET_CONFIG"

    echo "Puppet certs was loaded from Kubernetes Secrets"
else
    # Bootstrap new private key and request the Puppet Server's CA for signature and wait
    puppet ssl bootstrap --config "$PUPPET_CONFIG"

    # When signed, save the private key to the Kubernetes secret
    #puppet-cert-saver db-private
fi

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
