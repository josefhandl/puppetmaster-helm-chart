#!/bin/bash

set -e

# Change dir to project workdir
cd "$(dirname "$0")"

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <tag> <image>"
    echo "Example: $0 dev db"
    exit 1
fi

image=$2
tag=$1

docker build -t hub.cerit.io/josef_handl/puppet${image}:${tag} -f "Dockerfile.${image}" .
docker push hub.cerit.io/josef_handl/puppet${image}:${tag}
