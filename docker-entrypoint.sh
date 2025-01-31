#!/bin/bash

set -e

mkdir -p /etc/puppetlabs/puppetserver/ca/signed

cp /opt/puppet-cert/ca/* /etc/puppetlabs/puppetserver/ca/
cp /opt/puppet-cert/signed/* /etc/puppetlabs/puppetserver/ca/signed

sleep infinity

/opt/puppetlabs/bin/puppetserver start

tail -f /var/log/puppetlabs/puppetserver/puppetserver.log

