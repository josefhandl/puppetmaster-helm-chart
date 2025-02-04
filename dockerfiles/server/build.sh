#!/bin/bash

set -e

IMAGE="hub.cerit.io/josef_handl/puppetserver:mk2"
docker build -t "$IMAGE" .
docker push "$IMAGE"
