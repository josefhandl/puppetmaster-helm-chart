#!/bin/bash

#docker run --user 999:999 --cap-drop ALL -h "playground.internal" --rm -it -p 8140:8140 --name=ps hub.cerit.io/josef_handl/puppetdb:mk1 /bin/bash
docker run --privileged -h "playground.internal" --rm -it -p 8081:8081 --network=host --name=ps hub.cerit.io/josef_handl/puppetdb:mk1 /bin/bash

