#!/bin/bash

set -e

# Copy private key to the right location
cp /opt/puppet-cert-mount/private/* /opt/puppet-cert/

# Download PuppetBoard's certificate and CA cert bundle from PuppetServer's CA
wget --no-check-certificate -O "/opt/puppet-cert/${HOSTNAME_FULL_PUPPETBOARD}.crt" "https://${HOSTNAME_FULL_PUPPETSERVER}:8140/puppet-ca/v1/certificate/${HOSTNAME_FULL_PUPPETBOARD}"
wget --no-check-certificate -O "/opt/puppet-cert/puppet-root-ca.crt"               "https://${HOSTNAME_FULL_PUPPETSERVER}:8140/puppet-ca/v1/certificate/ca"

cd /opt/puppetboard

source venv/bin/activate

export PUPPETDB_HOST="${HOSTNAME_FULL_PUPPETDB}"
export PUPPETDB_PORT="8081"
export PUPPETDB_CERT="/opt/puppet-cert/${HOSTNAME_FULL_PUPPETBOARD}.crt"
export PUPPETDB_KEY="/opt/puppet-cert/${HOSTNAME_FULL_PUPPETBOARD}.pem"
#export PUPPETDB_SSL_VERIFY=False
export PUPPETDB_SSL_VERIFY="/opt/puppet-cert/puppet-root-ca.crt"
export SECRET_KEY="asdf"

export PUPPETBOARD_SETTINGS="/opt/puppetboard/settings.py"
envsubst < "${PUPPETBOARD_SETTINGS}" | sponge "${PUPPETBOARD_SETTINGS}"

gunicorn -b 0.0.0.0:8080 --preload --access-logfile=- puppetboard.app:app & pid_gunicorn=$!

# Register trap and wait for signal
_trap () {
    kill "$pid_gunicorn"
    while ps "$pid_gunicorn" > /dev/null ; do
        sleep 1
    done
}

trap "_trap" SIGINT SIGTERM
wait "$pid_gunicorn"
