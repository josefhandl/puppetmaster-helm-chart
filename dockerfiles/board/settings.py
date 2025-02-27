# PuppetBoard configuration file
#
# You can tune PuppetBoard by editing this file and running PuppetBoard with
# the environment variable PUPPETBOARD_SETTINGS containing the path to this
# file.
#
# Please refer to the following URL for a list of available variables:
# https://github.com/voxpupuli/puppetboard#app-settings
#
# If you are not accessing PuppetDB locally, set the following variables:
#
PUPPETDB_HOST = "$PUPPETDB_HOST"
PUPPETDB_PORT = "$PUPPETDB_PORT"
#
# If you access PuppetDB over TLS, configure the path to the TLS certifcate,
# key and CA certificate bellow:
#
PUPPETDB_CERT = "$PUPPETDB_CERT"
PUPPETDB_KEY = "$PUPPETDB_KEY"
PUPPETDB_SSL_VERIFY = "$PUPPETDB_SSL_VERIFY"

SECRET_KEY = "$SECRET_KEY"