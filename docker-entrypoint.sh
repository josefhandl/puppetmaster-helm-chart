#!/bin/bash

/opt/puppetlabs/bin/puppetserver start

tail -f /var/log/puppetlabs/puppetserver/puppetserver.log

