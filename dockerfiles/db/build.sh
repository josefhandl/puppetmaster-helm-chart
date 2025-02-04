#!/bin/bash

set -e

IMAGE="hub.cerit.io/josef_handl/puppetdb:mk1"
docker build -t "$IMAGE" .
docker push "$IMAGE"
