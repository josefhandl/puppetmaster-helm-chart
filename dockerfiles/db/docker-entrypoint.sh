#!/bin/bash

set -e

PUPPET_PATH="/etc/puppetlabs"
#PUPPET_CONFIG="${PUPPET_PATH}/puppet/puppet.conf"
PUPPET_DB_CONFIG="${PUPPET_PATH}/puppet/puppetdb.conf"

#mkdir -p "${PUPPET_PATH}/puppetserver/ca/signed"
#
## Substiture vars (set hostname) in puppet.conf file
#envsubst < "${PUPPET_PATH}/puppet/puppet.conf" | sponge "${PUPPET_PATH}/puppet/puppet.conf"
#
#if [ -n "$(ls /opt/puppet-cert/ca/)" ]; then
#    cp /opt/puppet-cert/ca/*     "${PUPPET_PATH}/puppetserver/ca/"
#    cp /opt/puppet-cert/signed/* "${PUPPET_PATH}/puppetserver/ca/signed"
#    echo "Puppet certs was loaded from Kubernetes Secrets"
#else
#    puppetserver ca setup --config "$PUPPET_CONFIG"
#fi
#
/opt/puppetlabs/bin/puppetdb start

tail -f /var/log/puppetlabs/puppetdb/puppetdb.log

#sleep infinity
